import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayService {
  static const MethodChannel _channel = MethodChannel('com.example.sepp490/overlay');

  static Future<void> showOverlay() async {
    bool isPermissionGranted = await FlutterOverlayWindow.isPermissionGranted();
    if (!isPermissionGranted) {
      await FlutterOverlayWindow.requestPermission();
    }

    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      overlayTitle: "SOS Button",
      overlayContent: "Click to open Emergency Screen",
      flag: OverlayFlag.defaultFlag,
      alignment: OverlayAlignment.centerRight,
      height: 100,
      width: 100,
    );
  }

  // static Future<void> closeOverlay() async {
  //   await FlutterOverlayWindow.closeOverlay();
  // }

  static Future<void> onClickOverlay() async {
    try {
      await _channel.invokeMethod('openApp'); // Call native method
    } on PlatformException catch (e) {
      print("Failed to invoke method: ${e.message}");
    }
  }
}
