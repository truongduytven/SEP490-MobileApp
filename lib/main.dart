import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/constants/secrets.example.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/call_history/repository/call_history_helper.dart';
import 'package:sep490/models/call_history.dart';
import 'package:sep490/presentation/pages/opening/splash_screen.dart';
import 'package:sep490/router.dart';
import 'package:sep490/theme/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

void main() async {
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

  runApp(
    ProviderScope(
      child: MyApp(navigatorKey: navigatorKey),
    ),
  );
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

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'LeagueSpartan'),
      color: AppColors.bgColor,
      home: SplashScreen(),
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorKey: widget.navigatorKey,
      onGenerateRoute: (settings) => generateRoute(settings),
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: [
            child!,

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
