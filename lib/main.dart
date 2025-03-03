import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/constants/secrets.example.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
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
