import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/constants/secrets.example.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/presentation/pages/advise_doctor/home_doctor_advise.dart';
import 'package:sep490/presentation/pages/emergency_alert/emergency_screen.dart';
import 'package:sep490/presentation/pages/opening/splash_screen.dart';
import 'package:sep490/router.dart';
import 'package:sep490/theme/color.dart';
import 'package:shake_gesture/shake_gesture.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await requestOverlayPermission();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['API_KEY'] ?? '',
      appId: dotenv.env['APP_ID'] ?? '',
      messagingSenderId: dotenv.env['MESSAGE_SENDER_ID'] ?? '',
      projectId: dotenv.env['PROJECT_ID'] ?? '',
    ),
  );
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

  /// Define a navigator key
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Initialize Zego Signaling Plugin **BEFORE** running the app
  await ZegoUIKit().initLog();

  ZegoUIKitPrebuiltCallInvitationService().init(
    appID: AppSecrets.appId, // Replace with your Zego App ID
    appSign: AppSecrets.appSign, // Replace with your Zego App Sign
    userID: currentUserId?.toString() ?? '',
    userName: fullName ?? "",
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
      return config;
    },

    invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
      onInvitationUserStateChanged: (List) {
        ///  Add your custom logic here.
        print("onInvitationUserStateChanged nè");
      },
      onIncomingCallDeclineButtonPressed: () {
        ///  Add your custom logic here.
        print("onIncomingCallDeclineButtonPressed nè");
      },
      onIncomingCallAcceptButtonPressed: () {
        ///  Add your custom logic here.
        print("onIncomingCallAcceptButtonPressed nè");
      },
      onIncomingCallReceived: (
        String callID,
        ZegoCallUser caller,
        ZegoCallType callType,
        List callees,
        String customData,
      ) {
        ///  Add your custom logic here.
        print("onIncomingCallReceived nè $callID $caller");
      },
      onIncomingCallCanceled: (
        String callID,
        ZegoCallUser caller,
        String customData,
      ) {
        ///  Add your custom logic here.
        print("onIncomingCallCanceled nè $callID $caller");
      },
      onIncomingCallTimeout: (String callID, ZegoCallUser caller) {
        ///  Add your custom logic here.
        print("onIncomingCallTimeout nè $callID $caller");
      },
      onOutgoingCallCancelButtonPressed: () {
        ///  Add your custom logic here.
        print("onOutgoingCallCancelButtonPressed nè");
      },
      onOutgoingCallAccepted: (String callID, ZegoCallUser callee) {
        ///  Add your custom logic here.
        print("onOutgoingCallAccepted nè $callID $callee");
      },
      onOutgoingCallRejectedCauseBusy: (
        String callID,
        ZegoCallUser callee,
        String customData,
      ) {
        ///  Add your custom logic here.
        print("onOutgoingCallRejectedCauseBusy nè $callID $callee");
      },
      onOutgoingCallDeclined: (
        String callID,
        ZegoCallUser callee,
        String customData,
      ) {
        ///  Add your custom logic here.
        print("onOutgoingCallDeclined nè $callID $callee");
      },
      onOutgoingCallTimeout: (
        String callID,
        List<ZegoCallUser> callees,
        bool isVideoCall,
      ) {
        ///  Add your custom logic here.
        print("onOutgoingCallDeclined nè $callID $callees");
      },
      onIncomingMissedCallClicked: (
        String callID,
        ZegoCallUser caller,
        ZegoCallInvitationType callType,
        List<ZegoCallUser> callees,
        String customData,

        /// The default action is to dial back the missed call

        Future<void> Function() defaultAction,
      ) async {
        /// Add your custom logic here.

        await defaultAction.call();
      },
      onIncomingMissedCallDialBackFailed: () {
        /// Add your custom logic here.
        print("onIncomingMissedCallDialBackFailed nè");
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    roleId = sharedPrefsHelper.getInt('roleId') ?? 0;
    SharedPrefsHelper.roleNotifier.addListener(_onRoleChanged);
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    // _initSpeech();
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
      Navigator.push(
        widget.navigatorKey.currentState!.context,
        MaterialPageRoute(builder: (context) => EmergencyScreen()),
      ).then((_) {
        _isShakeTriggered = false;
      });
      print('Lắc nè');
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
      onGenerateRoute: (settings) => generateRoute(settings),
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: [
            child!,
            ShakeGesture(
              onShake: () {
                _onShake();
              },
              child: Container(),
            ),
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
