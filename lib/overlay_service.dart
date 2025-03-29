import 'package:flutter/services.dart';

class OverlayService {
  static const MethodChannel _channel = MethodChannel('overlay_service');

  static Future<void> showOverlay() async {
    try {
      await _channel.invokeMethod('showOverlay');
    } on PlatformException catch (e) {
      print("Failed to show overlay: '${e.message}'.");
    }
  }
}