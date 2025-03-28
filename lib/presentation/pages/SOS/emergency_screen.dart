import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class EmergencyScreen extends StatefulWidget {
  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  String? frontImagePath;
  String? backImagePath;
  String? audioPath;
  Position? _currentPosition;
  Timer? _locationTimer;
  final record = AudioRecorder();

  @override
  void initState() {
    super.initState();
    _requestPermissions().then((granted) {
      if (granted) {
        _initCamera();
        _startLocationTracking();
      } else {
        print("Permissions denied!");
      }
    });
  }

  // 🔹 1. Request necessary permissions
  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.locationWhenInUse,
    ].request();

    return statuses[Permission.camera]!.isGranted &&
        statuses[Permission.microphone]!.isGranted &&
        statuses[Permission.locationWhenInUse]!.isGranted;
  }

  // 🔹 1. Khởi tạo camera
  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController =
            CameraController(_cameras!.first, ResolutionPreset.medium);
        await _cameraController!.initialize();
        setState(() {});
      }
    } catch (e) {
      print("Lỗi khi khởi tạo camera: $e");
    }
  }

  // 🔹 2. Chụp ảnh trước và sau
  Future<void> _captureImages() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    // Chụp ảnh từ camera sau
    XFile backImage = await _cameraController!.takePicture();
    backImagePath = backImage.path;

    // Xử lý chuyển đổi sang camera trước
    CameraDescription? frontCamera;
    for (var camera in _cameras!) {
      if (camera.lensDirection == CameraLensDirection.front) {
        frontCamera = camera;
        break;
      }
    }

    if (frontCamera != null) {
      await _cameraController
          ?.dispose(); // 🔹 Fix crash by disposing of old controller
      _cameraController =
          CameraController(frontCamera, ResolutionPreset.medium);
      await _cameraController!.initialize();
      setState(() {});

      XFile frontImage = await _cameraController!.takePicture();
      frontImagePath = frontImage.path;
    } else {
      print("Thiết bị không có camera trước!");
      frontImagePath = null;
    }

    print("Ảnh trước: $frontImagePath");
    print("Ảnh sau: $backImagePath");
  }

  // 🔹 3. Ghi âm 15 giây
  Future<void> _recordAudio() async {
    if (await Permission.microphone.request().isGranted) {
      Directory tempDir = await getTemporaryDirectory();
      audioPath =
          '${tempDir.path}/emergency_audio.m4a'; // 🔹 Assigning path here

      await record.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: audioPath ?? '', // 🔹 Ensure it's not null
      );

      print("Bắt đầu ghi âm...");

      await Future.delayed(Duration(seconds: 15));
      await record.stop();

      print("Ghi âm xong: $audioPath");
    } else {
      print("Không có quyền truy cập microphone!");
    }
  }

  // 🔹 4. Lấy vị trí GPS
  Future<void> _getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      print("Quyền truy cập vị trí bị từ chối vĩnh viễn!");
      return;
    }

    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(
        "Vị trí: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}");
  }

  // 🔹 5. Tracking vị trí liên tục
  void _startLocationTracking() {
    _locationTimer = Timer.periodic(Duration(seconds: 10), (Timer t) async {
      await _getLocation();
      if (_currentPosition != null) {
        await _sendLiveLocation();
      }
    });
  }

  // 🔹 6. Gửi vị trí tracking
  Future<void> _sendLiveLocation() async {
    var uri = Uri.parse("https://your-backend.com/api/live-location");

    var response = await http.post(uri,
        body: jsonEncode({
          "latitude": _currentPosition?.latitude ?? 0.0,
          "longitude": _currentPosition?.longitude ?? 0.0,
          "timestamp": DateTime.now().toIso8601String(),
        }),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      print("Gửi vị trí liên tục thành công!");
    } else {
      print("Lỗi gửi vị trí: ${response.statusCode}");
    }
  }

  // 🔹 7. Gửi dữ liệu khẩn cấp lên server
  Future<void> _sendEmergencyData() async {
    var uri = Uri.parse("https://your-backend.com/api/emergency");
    var request = http.MultipartRequest('POST', uri);

    if (frontImagePath != null) {
      request.files.add(
          await http.MultipartFile.fromPath('front_image', frontImagePath!));
    }
    if (backImagePath != null) {
      request.files
          .add(await http.MultipartFile.fromPath('back_image', backImagePath!));
    }
    if (audioPath != null) {
      request.files.add(await http.MultipartFile.fromPath('audio', audioPath!));
    }
    if (_currentPosition != null) {
      request.fields['latitude'] = _currentPosition!.latitude.toString();
      request.fields['longitude'] = _currentPosition!.longitude.toString();
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Gửi dữ liệu khẩn cấp thành công!");
    } else {
      print("Lỗi gửi dữ liệu: ${response.statusCode}");
    }
  }

  // 🔥 Xử lý khi nhấn nút gọi khẩn cấp
  Future<void> _handleEmergency() async {
    await _captureImages();
    await _recordAudio();
    await _getLocation();
    await _sendEmergencyData();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    record.dispose();
    _locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _handleEmergency,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          child: Text("🚨 GỌI KHẨN CẤP"),
        ),
      ),
    );
  }
}
