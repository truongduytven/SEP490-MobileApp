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
  ZegoUIKitPrebuiltCallInvitationService().init(
    appID: AppSecrets.appId, // Replace with your Zego App ID
    appSign: AppSecrets.appSign, // Replace with your Zego App Sign
    userID: currentUserId?.toString() ?? '',
    userName: fullName ?? "",
    events: ZegoUIKitPrebuiltCallEvents(
      onCallEnd: (
        ZegoCallEndEvent event,
        VoidCallback defaultAction,
      ) async {
        final callStartTime = DateTime.now();

        final callEndTime = DateTime.now();
        final callDuration = callEndTime.difference(callStartTime);
        print(
            "cuộc gọi bị hủy ${event.invitationData!.invitationID} ${event.invitationData!.invitees}  ${event.invitationData!.inviter} heeeeehah");
        // final callHistory = CallHistory(
        //   callId: 'N/A', // You can generate a unique ID or use a placeholder
        //   callerId: currentUserId?.toString() ?? '',
        //   calleeId: event.callUsers.firstWhere((user) => user.id != currentUserId?.toString()).id,
        //   callType: event.isVideoCall ? ZegoCallType.videoCall : ZegoCallType.voiceCall,
        //   startTime: callStartTime,
        //   endTime: callEndTime,
        //   duration: callDuration,
        //   callStatus: CallStatus.success, // Mark as successful call
        // );

        // await CallHistoryHelper.saveCallHistory(callHistory);
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
      // Track outgoing call accepted (successful call)
      onOutgoingCallAccepted: (String callID, ZegoCallUser callee) async {
        final callStartTime = DateTime.now();

        final callHistory = CallHistory(
          callId: callID,
          callerId: currentUserId?.toString() ?? '',
          calleeId: callee.id,
          callType: ZegoCallType.videoCall, // Adjust based on actual call type
          startTime: callStartTime,
          callStatus: CallStatus.success, // Mark as successful call
        );

        await CallHistoryHelper.saveCallHistory(callHistory);
      },

      // Track incoming call received
      onIncomingCallReceived: (
        String callID,
        ZegoCallUser caller,
        ZegoCallType callType,
        List callees,
        String customData,
      ) async {
        final callStartTime = DateTime.now();

        final callHistory = CallHistory(
          callId: callID,
          callerId: caller.id,
          calleeId: currentUserId?.toString() ?? '',
          callType: callType,
          startTime: callStartTime,
          callStatus: CallStatus.missed, // Mark as missed by default
        );

        await CallHistoryHelper.saveCallHistory(callHistory);
      },

      // Track incoming call declined
      onIncomingCallDeclineButtonPressed: () async {
        final callHistory = CallHistory(
          callId: 'N/A', // You can generate a unique ID or use a placeholder
          callerId: 'N/A',
          calleeId: currentUserId?.toString() ?? '',
          callType: ZegoCallType.voiceCall, // Adjust based on actual call type
          startTime: DateTime.now(),
          callStatus: CallStatus.declined, // Mark as declined
        );

        await CallHistoryHelper.saveCallHistory(callHistory);
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
          calleeId: callee.id,
          callType: ZegoCallType.voiceCall, // Adjust based on actual call type
          startTime: DateTime.now(),
          callStatus: CallStatus.declined, // Mark as declined
        );

        await CallHistoryHelper.saveCallHistory(callHistory);
      },

      // Track outgoing call timeout
      onOutgoingCallTimeout: (
        String callID,
        List<ZegoCallUser> callees,
        bool isVideoCall,
      ) async {
        final callHistory = CallHistory(
          callId: callID,
          callerId: currentUserId?.toString() ?? '',
          calleeId: callees.first.id,
          callType:
              isVideoCall ? ZegoCallType.videoCall : ZegoCallType.voiceCall,
          startTime: DateTime.now(),
          callStatus: CallStatus.timedOut, // Mark as timed out
        );

        await CallHistoryHelper.saveCallHistory(callHistory);
      },

      // Track incoming call timeout
      onIncomingCallTimeout: (String callID, ZegoCallUser caller) async {
        final callHistory = CallHistory(
          callId: callID,
          callerId: caller.id,
          calleeId: currentUserId?.toString() ?? '',
          callType: ZegoCallType.voiceCall, // Adjust based on actual call type
          startTime: DateTime.now(),
          callStatus: CallStatus.timedOut, // Mark as timed out
        );

        await CallHistoryHelper.saveCallHistory(callHistory);
      },

      // Track outgoing call canceled
      onOutgoingCallCancelButtonPressed: () async {
        final callHistory = CallHistory(
          callId: 'N/A', // You can generate a unique ID or use a placeholder
          callerId: currentUserId?.toString() ?? '',
          calleeId: 'N/A',
          callType: ZegoCallType.voiceCall, // Adjust based on actual call type
          startTime: DateTime.now(),
          callStatus: CallStatus.canceled, // Mark as canceled
        );

        await CallHistoryHelper.saveCallHistory(callHistory);
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
          calleeId: currentUserId?.toString() ?? '',
          callType: ZegoCallType.voiceCall, // Adjust based on actual call type
          startTime: DateTime.now(),
          callStatus: CallStatus.canceled, // Mark as canceled
        );

        await CallHistoryHelper.saveCallHistory(callHistory);
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
