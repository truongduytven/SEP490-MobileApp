import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sep490/common/constants/secrets.example.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/presentation/pages/SOS/emergency_screen.dart';
import 'package:sep490/presentation/pages/SOS/record_button.dart';
import 'package:sep490/presentation/pages/opening/splash_screen.dart';
import 'package:sep490/router.dart';
import 'package:sep490/theme/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.top,
    SystemUiOverlay.bottom,
  ]);
  await SharedPrefsHelper().init();

  final prefs = await SharedPreferences.getInstance();
  final int? currentUserId = prefs.getInt('accountId');
  final String? fullName = prefs.getString('fullName');

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  await ZegoUIKit().initLog();

  ZegoUIKitPrebuiltCallInvitationService().init(
    appID: AppSecrets.appId, // Replace with your Zego App ID
    appSign: AppSecrets.appSign, // Replace with your Zego App Sign
    userID: currentUserId?.toString() ?? '',
    userName: fullName ?? "",
    plugins: [ZegoUIKitSignalingPlugin()],
  );

  /// Set navigator key for Zego Call Invitation Service
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  runApp(
    ProviderScope(
      child: MyApp(navigatorKey: navigatorKey),
    ),
  );
}

Future<void> requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.microphone,
    Permission.location,
    Permission.locationAlways,
    Permission.locationWhenInUse,
    Permission.bluetooth,
    Permission.notification,
    Permission.audio,
    Permission.contacts,
    Permission.storage,
    // Permission.systemAlertWindow,
  ].request();
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
  double buttonX = 5;
  double buttonY = 500;
  final double buttonSize = 60.0;
  final double borderRadius = 50.0;
  final double edgePadding = 5.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'LeagueSpartan'),
      color: AppColors.bgColor,
      home: SplashScreen(),
      navigatorKey: widget.navigatorKey,
      onGenerateRoute: (settings) => generateRoute(settings),
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: [
            child!,
            // DraggableButton(
            //   color: Colors.white,
            //   size: 50,
            //   radius: 50,
            //   defaultPosition: const Offset(10.0, 100.0),
            //   onTap: () {},
            //   child: const Icon(
            //     Icons.phone,
            //     color: Colors.red,
            //   ),
            // ),
            Positioned(
              left: buttonX,
              top: buttonY,
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
                onPanEnd: (details) {
                  setState(() {
                    final screenSize = MediaQuery.of(context).size;
                    double screenMid = screenSize.width / 2;

                    buttonX = (buttonX < screenMid)
                        ? edgePadding
                        : screenSize.width - buttonSize - edgePadding;
                  });
                },
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
                  child:
                      // IconButton(
                      //   icon: Icon(Icons.sos, color: Colors.white, size: 30),
                      //   onPressed: () {},
                      // ),
                      GestureDetector(
                    onTap: () {
                      Navigator.push(
                        widget.navigatorKey.currentState!.context,
                        MaterialPageRoute(
                            builder: (context) => EmergencyScreen()),
                      );
                    },
                    child: Image.asset(
                      'assets/img/SOSButton.png', // Replace with your image path
                      width: buttonSize,
                      height: buttonSize,
                    ),
                  ),
                ),
              ),
            ),
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
