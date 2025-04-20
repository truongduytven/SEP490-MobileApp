import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/constants/secrets.example.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/call_history/repository/call_history_helper.dart';
import 'package:sep490/models/call_history.dart';
import 'package:sep490/presentation/pages/emergency_alert/emergency_screen.dart';
import 'package:sep490/presentation/pages/notification/notification_screen.dart';
import 'package:sep490/presentation/pages/opening/splash_screen.dart';
import 'package:sep490/router.dart';
import 'package:sep490/theme/color.dart';
import 'package:shake_gesture/shake_gesture.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:speech_to_text/speech_to_text.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Nhận thông báo trong nền: ${message.data}");
}

void main() async {
  await dotenv.load(fileName: ".env");
  await requestOverlayPermission();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.top,
    SystemUiOverlay.bottom,
  ]);
  await SharedPrefsHelper().init();

  /// Load cached user ID
  final prefs = await SharedPreferences.getInstance();
  final int? currentUserId = prefs.getInt('accountId');
  final String? fullName = prefs.getString('fullName');
  // final String? deviceToken = prefs.getString('deviceToken');
  // if (deviceToken == null) {
  //   await Firebase.initializeApp(
  //     options: FirebaseOptions(
  //       apiKey: dotenv.env['API_KEY'] ?? '',
  //       appId: dotenv.env['APP_ID'] ?? '',
  //       messagingSenderId: dotenv.env['MESSAGE_SENDER_ID'] ?? '',
  //       projectId: dotenv.env['PROJECT_ID'] ?? '',
  //     ),
  //   );
  // }
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['API_KEY'] ?? '',
      appId: dotenv.env['APP_ID'] ?? '',
      messagingSenderId: dotenv.env['MESSAGE_SENDER_ID'] ?? '',
      projectId: dotenv.env['PROJECT_ID'] ?? '',
    ),
  );

  /// Lấy device token
  String? deviceToken = prefs.getString('deviceToken');
  if (deviceToken == null) {
    deviceToken = await FirebaseMessaging.instance.getToken();
    if (deviceToken != null) {
      await prefs.setString('deviceToken', deviceToken);
    }
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Define a navigator key
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Initialize Zego Signaling Plugin **BEFORE** running the app
  await ZegoUIKit().initLog();

  /// Define a scaffold messenger key
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  // Error state variable
  bool hasError = false;

  // // Method to show error dialog
  // void showErrorDialog(String message) {
  //   // Ensure the context is valid and the dialog is shown after the first frame
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     showDialog(
  //       context: navigatorKey.currentContext!,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Error'),
  //           content: Text(message),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 hasError = false; // Reset error state
  //                 Navigator.of(context).pop(); // Close the dialog
  //               },
  //               child: Text('Close'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   });
  // }

  void closeAllDialogs() {
    while (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop();
    }
  }

  void showErrorDialog(String message) {
    if (navigatorKey.currentContext != null) {
      showDialog(
        barrierColor: AppColors.secondaryColor.withOpacity(0.95),
        context: navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            title: Text('Không thể gọi'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigator.of(context).pop(); // Close the dialog
                  closeAllDialogs();
                },
                child: Text('Đã hiểu'),
              ),
            ],
          );
        },
      );
    }
  }

  String? currentCallId;
  String? callerId;
  String? calleeId;
  DateTime? startTime;
  ZegoCallType? callType;
  ZegoUIKitPrebuiltCallInvitationService().init(
    appID: AppSecrets.appId, // Replace with your Zego App ID
    appSign: AppSecrets.appSign, // Replace with your Zego App Sign
    userID: currentUserId?.toString() ?? '',
    userName: fullName ?? "",

    events: ZegoUIKitPrebuiltCallEvents(
      onError: (ZegoUIKitError error) {
        if (error.code == 301003001) {
          hasError = true;
          showErrorDialog(
              'Tài khoản chưa đăng nhập trên thiết bị nào hoặc tài khoản đang không hoạt động');
        }
        // Print the error to the console
        print(
            "ZegoUIKit Error: Code: ${error.code}, Message: ${error.message}");

        // Show SnackBar for errors caught by ZegoUIKit
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text('Error: ${error.message}'),
              duration: const Duration(seconds: 5),
            ),
          );
        });
      },
      onCallEnd: (
        ZegoCallEndEvent event,
        VoidCallback defaultAction,
      ) async {
        final callEndTime = DateTime.now();
        final callDuration = startTime != null
            ? callEndTime.difference(startTime!)
            : Duration.zero; // Check if startTime is null
        startTime = null; // Reset startTime after call ends
        print(
            "cuộc gọi bị hủy ${event.invitationData!.invitationID} ${event.invitationData!.invitees}  ${event.invitationData!.inviter} heeeeehah");

        final invitationData = event.invitationData;
        final callerId = invitationData?.inviter?.id ?? 'Unknown';
        final callType = invitationData != null && invitationData.type != null
            ? (invitationData.type == ZegoCallType.videoCall
                ? ZegoCallType.videoCall
                : ZegoCallType.voiceCall)
            : ZegoCallType.voiceCall;
        List<String> inviteeIds = [];
        // Check if invitationData and invitees are not null
        if (invitationData != null && invitationData.invitees != null) {
          // Extract user IDs from invitees
          inviteeIds = invitationData.invitees.map((user) => user.id).toList();

          // Print or use the list of invitee IDs
          print("Invitee IDs: $inviteeIds");
        } else {
          print("No invitees found.");
        }

        final formattedDuration = formatDuration(callDuration);
        final callHistory = CallHistory(
          callId: 'N/A', // You can generate a unique ID or use a placeholder
          callerId: callerId,
          calleeIds: inviteeIds,
          callType: callType,
          startTime: startTime ?? callEndTime,
          endTime: callEndTime,
          duration: formattedDuration,
          callStatus: startTime != null
              ? CallStatus.success
              : CallStatus.missed, // Mark as successful call
        );

        await CallHistoryHelper.saveCallHistory(
            navigatorKey.currentContext!, callHistory);
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(
              'Call History:\n'
              'Caller: ${event.invitationData!.callID}\n'
              'Callee: ${event.invitationData}\n'
              'Duration: ${event.invitationData?.invitationID ?? 0} seconds',
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        // Call the default action to ensure the call ends properly
        // defaultAction();
        defaultAction.call();
      },
    ),
    plugins: [
      ZegoUIKitSignalingPlugin()
    ], // Ensure the signaling plugin is added

    //limited for duration call
    requireConfig: (ZegoCallInvitationData data) {
      var config = (data.invitees.length > 1)
          ? ZegoCallType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
              : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
          : ZegoCallType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

      // Modify your custom configurations here.
      config.duration.isVisible = true;
      config.duration.onDurationUpdate = (Duration duration) {
        if (duration.inSeconds == 60 * 60) {
          ZegoUIKitPrebuiltCallController()
              .hangUp(navigatorKey.currentState!.context);
        }
      };

      // Track call start time

      // Track call end event (successful call)
      // Track call start time

      // Use the onCallEnd event to track call end

      return config;
    },

    invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
      onError: (error) {
        if (error.code == 301003001) {
          hasError = true;
          showErrorDialog(
              'Tài khoản chưa đăng nhập trên thiết bị nào hoặc tài khoản đang không hoạt động');
        }
        print(
            "ZegoUIKit Error: Code: ${error.code}, Message: ${error.message}");

        // Show SnackBar for errors caught by ZegoUIKit
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text('Error: ${error.message}'),
              duration: const Duration(seconds: 5),
            ),
          );
        });
      },
      // Track outgoing call accepted (successful call)
      onOutgoingCallAccepted: (String callID, ZegoCallUser callee) async {
        currentCallId = callID;
        // callerId = currentUserId?.toString() ?? '';
        callerId = callerId;
        calleeId = callee.id;
        callType = ZegoCallType.voiceCall;
        // final callStartTime = DateTime.now();
        startTime = DateTime.now();

        // final callHistory = CallHistory(
        //   callId: callID,
        //   callerId: currentUserId?.toString() ?? '',
        //   calleeId: callee.id,
        //   callType: ZegoCallType.videoCall, // Adjust based on actual call type
        //   startTime: callStartTime,
        //   callStatus: CallStatus.success, // Mark as successful call
        // );

        // await CallHistoryHelper.saveCallHistory(callHistory);
      },

      // Track incoming call received
      onIncomingCallReceived: (
        String callID,
        ZegoCallUser caller,
        ZegoCallType callType,
        List callees,
        String customData,
      ) async {
        currentCallId = callID;
        // callerId = currentUserId?.toString() ?? '';
        callerId = caller.id.toString();
        calleeId = caller.toString();
        callType = ZegoCallType.voiceCall;
        final callStartTime = DateTime.now();

        // final callHistory = CallHistory(
        //   callId: callID,
        //   callerId: caller.id,
        //   calleeId: currentUserId?.toString() ?? '',
        //   callType: callType,
        //   startTime: callStartTime,
        //   callStatus: CallStatus.missed, // Mark as missed by default
        // );

        // await CallHistoryHelper.saveCallHistory(callHistory);
        startTime = DateTime.now();
      },

      // Track incoming call declined
      onIncomingCallDeclineButtonPressed: () async {
        // print("tắt máy: $currentCallId $callerId $callType");
        // final callHistory = CallHistory(
        //   callId: currentCallId ?? 'N/A', // Use the stored call ID
        //   callerId: currentUserId?.toString() ?? '',, // Use the stored caller ID
        //   calleeId: currentUserId?.toString() ?? '',
        //   callType:
        //       callType ?? ZegoCallType.voiceCall, // Use the stored call type
        //   startTime: DateTime.now(),
        //   callStatus: CallStatus.declined, // Mark as declined
        // );

        // await CallHistoryHelper.saveCallHistory(callHistory);

        // // Optionally, reset the stored information
        // currentCallId = null;
        // callerId = null;
        // callType = null;
      },

      // Track outgoing call declined
      onOutgoingCallDeclined: (
        String callID,
        ZegoCallUser callee,
        String customData,
      ) async {
        final callHistory = CallHistory(
          callId: callID,
          callerId: currentUserId?.toString() ?? '',
          // callerId: callerId ?? "Unknown",
          calleeIds: [callee.id],
          callType: ZegoCallType.voiceCall, // Adjust based on actual call type
          startTime: DateTime.now(),
          callStatus: CallStatus.declined, // Mark as declined
        );

        await CallHistoryHelper.saveCallHistory(
            navigatorKey.currentContext!, callHistory);
      },

      // Track outgoing call timeout
      onOutgoingCallTimeout: (
        String callID,
        List<ZegoCallUser> callees,
        bool isVideoCall,
      ) async {
        List<String> calleeIds = callees.map((user) => user.id).toList();
        final callHistory = CallHistory(
          callId: callID,
          callerId: currentUserId?.toString() ?? '',
          // callerId: callerId ?? "Unknown",
          calleeIds: calleeIds,
          callType:
              isVideoCall ? ZegoCallType.videoCall : ZegoCallType.voiceCall,
          startTime: DateTime.now(),
          callStatus: CallStatus.timedOut, // Mark as timed out
        );

        await CallHistoryHelper.saveCallHistory(
            navigatorKey.currentContext!, callHistory);
      },

      // Track incoming call timeout
      onIncomingCallTimeout: (String callID, ZegoCallUser caller) async {
        final callHistory = CallHistory(
          callId: callID,
          // callerId: caller.id,
          callerId: currentUserId?.toString() ?? '',
          calleeIds: [calleeId ?? ''],
          callType: ZegoCallType.voiceCall, // Adjust based on actual call type
          startTime: DateTime.now(),
          callStatus: CallStatus.timedOut, // Mark as timed out
        );

        await CallHistoryHelper.saveCallHistory(
            navigatorKey.currentContext!, callHistory);
      },

      // Track outgoing call canceled
      onOutgoingCallCancelButtonPressed: () async {
        print("tắt máy: $currentCallId $callerId $callType");

        // final callHistory = CallHistory(
        //   callId: currentCallId ?? 'N/A', // Use the stored call ID
        //   callerId: callerId ?? 'N/A', // Use the stored caller ID
        //   calleeId: currentUserId?.toString() ?? '',
        //   callType:
        //       callType ?? ZegoCallType.voiceCall, // Use the stored call type
        //   startTime: DateTime.now(),
        //   callStatus: CallStatus.declined, // Mark as declined
        // );

        // await CallHistoryHelper.saveCallHistory(callHistory);

        // // Optionally, reset the stored information
        // currentCallId = null;
        // callerId = null;
        // callType = null;
      },

      // Track incoming call canceled
      onIncomingCallCanceled: (
        String callID,
        ZegoCallUser caller,
        String customData,
      ) async {
        final callHistory = CallHistory(
          callId: callID,
          callerId: caller.id,
          // calleeId: currentUserId?.toString() ?? '',
          calleeIds: [caller.id],
          callType: ZegoCallType.voiceCall, // Adjust based on actual call type
          startTime: DateTime.now(),
          callStatus: CallStatus.canceled, // Mark as canceled
        );

        await CallHistoryHelper.saveCallHistory(
            navigatorKey.currentContext!, callHistory);
      },
    ),
  );

  /// Set navigator key for Zego Call Invitation Service
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  await FlutterBackground.initialize(
    androidConfig: FlutterBackgroundAndroidConfig(
      notificationTitle: "SOS Service",
      notificationText: "Running in background",
      notificationIcon: AndroidResource(name: 'ic_launcher', defType: 'mipmap'),
    ),
  );

  runApp(
    ProviderScope(
      child: MyApp(navigatorKey: navigatorKey),
    ),
  );
}

Future<void> requestOverlayPermission() async {
  bool isGranted = await FlutterOverlayWindow.isPermissionGranted();
  if (!isGranted) {
    await FlutterOverlayWindow.requestPermission();
  }
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({
    required this.navigatorKey,
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class _MyAppState extends State<MyApp>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  int roleId = 0;
  double buttonX = 5;
  double buttonY = 500;
  final double buttonSize = 60.0;
  final double borderRadius = 50.0;
  final double edgePadding = 5.0;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late AnimationController _controller;
  late Animation<double> _animationX;
  late Animation<double> _animationY;
  bool _isShakeTriggered = false;
  bool _isListening = false;
  // final SpeechToText _speech = SpeechToText();
  bool _isInEmergency = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    roleId = sharedPrefsHelper.getInt('roleId') ?? 0;
    SharedPrefsHelper.roleNotifier.addListener(_onRoleChanged);
    SharedPrefsHelper.avatarNotifier.addListener(_onRoleChanged);
    SharedPrefsHelper.fullNameNotifier.addListener(_onRoleChanged);
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    // _initSpeech();
    _setupFirebaseMessaging();
    _initializeLocalNotifications();
  }

  void _onRoleChanged() {
    setState(() {});
  }

  // void _initSpeech() async {
  //   bool available = await _speech.initialize(
  //     onStatus: (status) {
  //       if (status == "done" && !_isInEmergency) {
  //         _startListening();
  //       }
  //     },
  //     onError: (error) {
  //       print("Speech Error: $error");
  //     },
  //   );
  //   if (available) {
  //     _startListening();
  //   }
  // }

  // void _startListening() async {
  //   if (!_isListening && !_isInEmergency) {
  //     _isListening = true;
  //     _speech.listen(
  //       onResult: (result) {
  //         _processSpeech(result.recognizedWords);
  //         print(result.recognizedWords);
  //       },
  //       localeId: "vi_VN",
  //     );
  //   }
  // }

  // void _processSpeech(String words) {
  //   words = words.toLowerCase().trim();
  //   if (!_isInEmergency && (words.contains("cứu") ||
  //       words.contains("cứu tôi") ||
  //       words.contains("cứu với"))) {
  //     _stopListening();
  //     Navigator.push(
  //       widget.navigatorKey.currentState!.context,
  //       MaterialPageRoute(builder: (context) => HomeDoctorAdviseScreen()),
  //     ).then((_) {
  //       setState(() {
  //         _isInEmergency = false;
  //       });
  //       _startListening();
  //     });

  //     setState(() {
  //       _isInEmergency = true;
  //     });
  //   }
  // }

  // void _stopListening() {
  //   if (_isListening) {
  //     _isListening = false;
  //     _speech.stop();
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SharedPrefsHelper.roleNotifier.removeListener(_onRoleChanged);
    _controller.dispose();
    super.dispose();
  }

  void _animateButtonToEdge() {
    final screenSize = MediaQuery.of(context).size;
    double screenMid = screenSize.width / 2;
    double targetX = (buttonX < screenMid)
        ? edgePadding
        : screenSize.width - buttonSize - edgePadding;

    _animationX = Tween<double>(begin: buttonX, end: targetX).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _animationY = Tween<double>(begin: buttonY, end: buttonY).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward(from: 0).then((_) {
      setState(() {
        buttonX = targetX;
      });
    });
  }

  void _onShake() {
    if (!_isShakeTriggered) {
      _isShakeTriggered = true;
      setState(() {
        _isInEmergency = true;
      });
      Navigator.push(
        widget.navigatorKey.currentState!.context,
        MaterialPageRoute(builder: (context) => EmergencyScreen()),
      ).then((_) {
        _isShakeTriggered = false;
        setState(() {
          _isInEmergency = false;
        });
      });
    }
  }

  void _setupFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Đã được cấp quyền thông báo');
    } else {
      print('❌ Không được cấp quyền thông báo');
    }
    // Lấy FCM Token
    String? token = await messaging.getToken();
    print("✅ FCM Token: $token");
    // Nhận thông báo khi ứng dụng đang mở
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Nhận thông báo khi mở app: ${message.notification!.title}");
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Nhận thông báo khi mở app: ${message.notification?.title}");

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _showLocalNotification(notification);
      }
    });
    // Xử lý khi mở ứng dụng từ trạng thái đã đóng
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print(
            "📌 Nhấn vào thông báo khi app đóng: ${message.notification?.title}");
        _handleNotificationNavigation(message.notification?.title ?? "");
      }
    });

    // Xử lý khi nhấn vào thông báo khi app đang chạy nền
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          "📌 Nhấn vào thông báo khi app chạy nền: ${message.notification?.title}");
      _handleNotificationNavigation(message.notification?.title ?? "");
    });
  }

  void _showLocalNotification(RemoteNotification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel', // ID
      'Thông báo', // Tên kênh
      channelDescription: 'Kênh dành cho thông báo quan trọng',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      fullScreenIntent: true,
      enableVibration: true,
      playSound: true,
      timeoutAfter: 5000,
      channelShowBadge: true,
      category: AndroidNotificationCategory.message,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: notification.title, // Đưa payload vào thông báo (ở đây là title)
    );
  }

  void _handleNotificationNavigation(String title) {
    final navigator = widget.navigatorKey.currentState;
    if (navigator == null) {
      print("⚠️ Không tìm thấy Navigator để điều hướng!");
      return;
    }

    navigator.push(
      MaterialPageRoute(builder: (context) => NotificationScreen()),
    );
  }

  // void _initializeLocalNotifications() async {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/launcher_ic');

  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(android: initializationSettingsAndroid);

  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }
  void _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_ic');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          _onNotificationSelected, // Instance method will work for this
      // onDidReceiveBackgroundNotificationResponse:
      //     _onNotificationSelectedStatic, // Static method for background handling
    );
  }

  Future<void> _onNotificationSelected(
      NotificationResponse notificationResponse) async {
    // You can use the payload to navigate or process the data passed with the notification.
    if (notificationResponse.payload != null) {
      // Process the payload (could be the title, id, etc.)
      _handleNotificationNavigation(notificationResponse.payload!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'LeagueSpartan'),
      color: AppColors.bgColor,
      home: SplashScreen(),
      routes: {
        '/emergency_screen': (context) => EmergencyScreen(),
      },
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorKey: widget.navigatorKey,
      navigatorObservers: [routeObserver],
      onGenerateRoute: (settings) => generateRoute(settings),
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: [
            child!,
            ValueListenableBuilder<int>(
                valueListenable: SharedPrefsHelper.roleNotifier,
                builder: (context, roleId, _) {
                  if (roleId != 2) return SizedBox();
                  return ShakeGesture(
                    onShake: () {
                      _onShake();
                    },
                    child: Container(),
                  );
                }),

            ValueListenableBuilder<int>(
              valueListenable: SharedPrefsHelper.roleNotifier,
              builder: (context, roleId, _) {
                if (roleId != 2 || _isInEmergency) return SizedBox();
                return Positioned(
                  left: _controller.isAnimating ? _animationX.value : buttonX,
                  top: _controller.isAnimating ? _animationY.value : buttonY,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        buttonX += details.delta.dx;
                        buttonY += details.delta.dy;

                        // Prevent button from moving out of bounds
                        final screenSize = MediaQuery.of(context).size;
                        // buttonX = buttonX.clamp(0, screenSize.width - buttonSize);
                        buttonY = buttonY.clamp(edgePadding,
                            screenSize.height - buttonSize - edgePadding);
                      });
                    },
                    onPanEnd: (_) => _animateButtonToEdge(),
                    child: Container(
                      width: buttonSize,
                      height: buttonSize,
                      decoration: BoxDecoration(
                        color: Colors.red, // Button color
                        borderRadius: BorderRadius.circular(borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isInEmergency = true;
                          });
                          Navigator.push(
                            widget.navigatorKey.currentState!.context,
                            MaterialPageRoute(
                                builder: (context) => EmergencyScreen()),
                          ).then((_) {
                            setState(() {
                              _isInEmergency = false;
                            });
                          });
                        },
                        child: Image.asset(
                          'assets/img/SOSButton.png', // Replace with your image path
                          width: buttonSize,
                          height: buttonSize,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            /// support minimizing
            ZegoUIKitPrebuiltCallMiniOverlayPage(
              contextQuery: () {
                //This is an anonymous function (a closure) that returns the BuildContext of the current state of the navigator.
                return widget.navigatorKey.currentState!.context;
              },
            ),
          ],
        );
      },
    );
  }
}
