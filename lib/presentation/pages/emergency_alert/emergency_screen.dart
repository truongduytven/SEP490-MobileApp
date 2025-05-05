import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:pulsator/pulsator.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/presentation/pages/emergency_alert/controller/emergency_controller.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  String? frontImagePath;
  String? backImagePath;
  String? audioPath;
  Position? _currentPosition;
  Timer? _locationTimer;
  final record = AudioRecorder();
  int _countdown = 10;
  Timer? _timer;
  final int _count = 5;
  final int _duration = 2;
  final int _repeatCount = 0;
  bool _isCancelled = false;
  bool isCompleteCreateConfirmation = false;
  final Completer<void> _completer = Completer<void>();
  String title = "Tiến hành gọi khẩn cấp";
  String description = "Cuộc gọi khẩn cấp sẽ được thực hiện sau:";
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int userId;
  late int emergencyConfirmationId = 0;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    userId = sharedPrefsHelper.getInt('accountId') ?? 0;
    _requestPermissions().then((granted) {
      if (granted) {
        _initCamera();
        // _startLocationTracking();
      } else {
        print("Permissions denied!");
      }
    });
    _startEmergency();
  }

  Future<void> _startEmergency() async {
    _startCountdown();
    await _callEmergencyAPI();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          title = "Đang gửi dữ liệu khẩn cấp...";
          description = "Vui lòng đợi trong giây lát!";
        });
      }
    });
  }

  Future<void> _cancelEmergency() async {
    _timer?.cancel();
    _isCancelled = true;
    player.stop();
    await _callCancelEmergencyAPI();
    Navigator.pop(context);
  }

  void showDialogCancel() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hủy cuộc gọi khẩn cấp"),
          content: Text("Bạn có chắc chắn muốn hủy cuộc gọi khẩn cấp không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Không"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _cancelEmergency();
              },
              child: Text("Có"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _callEmergencyAPI() async {
    print("Gọi API Emergency Start...");
    var uri = Uri.parse(
        "https://api.diavan-valuation.asia/emergency-contacts/family-emergency-call?accountId=$userId");

    try {
      final response = http.post(uri).then((res) {
        if (!_completer.isCompleted) _completer.complete();
        return res;
      });

      await Future.any([
        response,
        _completer.future,
      ]);

      if (!_isCancelled) {
        setState(() {
          title = "Đang gửi tín hiệu đến người thân...";
          description =
              "Chúng tôi đang cố gắng liên hệ đến người thân của bạn!";
        });
        await player.setReleaseMode(ReleaseMode.loop);
        await player.play(AssetSource('music/sos.mp3'));
        await createConfirmation(userId);
        await _sendEmergencyData();
        _checkConfirmationStatus(0);
      }
    } catch (e) {
      print("Lỗi gọi API Emergency: $e");
    }
  }

  Future<void> _checkConfirmationStatus(int attempt) async {
    if (attempt >= 3) {
      setState(() {
        title = "Cuộc gọi khẩn cấp không được xác nhận!";
        description =
            "Chúng tôi đã gửi thông tin khẩn cấp đến người thân của bạn nhưng họ vẫn chưa xác nhận!";
        isCompleteCreateConfirmation = true;
      });
      player.stop();
      _callNumber();
      return;
    }

    await Future.delayed(Duration(seconds: 30));

    bool isConfirmed = await _checkIsConfirmed();

    if (isConfirmed) {
      if (!mounted) return;
      setState(() {
        title = "Đã xác nhận cuộc gọi khẩn cấp!";
        description =
            "Người thân của bạn đã xác nhận cuộc gọi khẩn cấp và đang trên đường đến!";
        isCompleteCreateConfirmation = true;
      });
      player.stop();
      return;
    } else {
      if (!mounted) return;
      setState(() {
        title = "Chưa xác nhận cuộc gọi khẩn cấp!";
        description =
            "Chúng tôi đã gửi thông tin khẩn cấp đến người thân của bạn và đang chờ tín hiệu từ họ!";
      });
      await _sendEmergencyData();

      if (attempt == 1) {
        await _callDoctorAPI();
      }
      _checkConfirmationStatus(attempt + 1);
      return;
    }
  }

  void _callNumber() async {
    const number = '0964160769'; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  Future<bool> _checkIsConfirmed() async {
    EmergencyController emergencyController = EmergencyController();
    await emergencyController.confirmEmergency(emergencyConfirmationId);
    if (emergencyController.isConfirmed) {
      return true;
    }
    return false;
  }

  Future<void> _callDoctorAPI() async {
    var uri = Uri.parse(
        "https://api.diavan-valuation.asia/emergency-contacts/doctor-emergency-call?accountId=$userId");

    try {
      final response = await http.post(uri);
      if (response.statusCode == 200) {
        setState(() {
          title = "Đang gọi bác sĩ...";
          description = "Chúng tôi đang cố gắng liên hệ đến bác sĩ của bạn!";
        });
      } else {
        print("Lỗi gọi bác sĩ: ${response.statusCode}");
      }
    } catch (e) {
      print("Lỗi gọi API bác sĩ: $e");
    }
  }

  Future<void> _callCancelEmergencyAPI() async {
    print("Gọi API Cancel Emergency...");
    var uri = Uri.parse(
        "https://api.diavan-valuation.asia/emergency-contacts/cancel/$userId");

    try {
      final response = await http.post(uri);
      if (response.statusCode == 200) {
        print("Đã hủy cuộc gọi khẩn cấp!");
        if (!_completer.isCompleted) _completer.complete();
      } else {
        print("Lỗi hủy cuộc gọi khẩn cấp!");
      }
    } catch (e) {
      print("Lỗi gọi API Cancel: $e");
    }

    var uri2 = Uri.parse(
        "https://api.diavan-valuation.asia/emergency-contacts/confirmation?accountId=$userId&emergencyId=$emergencyConfirmationId");

    try {
      final response = await http.post(uri2);
      if (response.statusCode == 200) {
        print("Đã hủy cuộc gọi khẩn cấp!");
        if (!_completer.isCompleted) _completer.complete();
      } else {
        print("Lỗi hủy cuộc gọi khẩn cấp!");
      }
    } catch (e) {
      print("Lỗi gọi API Cancel: $e");
    }
  }

  Future<void> createConfirmation(int accountID) async {
    EmergencyController emergencyController = EmergencyController();
    await emergencyController.createEmergencyConfirmation(accountID);
    if (emergencyController.emergencyConfirmationId != null) {
      setState(() {
        emergencyConfirmationId = emergencyController.emergencyConfirmationId!;
      });
    }
  }

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

  Future<void> expireEmergency() async {
    EmergencyController emergencyController = EmergencyController();
    await emergencyController.expireEmergency(emergencyConfirmationId);
    if (emergencyController.isExpired) {
      setState(() {
        title = "Cuộc gọi khẩn cấp đã hết hạn!";
        description =
            "Chúng tôi đã gửi thông tin khẩn cấp đến người thân của bạn nhưng họ vẫn chưa xác nhận!";
        isCompleteCreateConfirmation = true;
      });
      player.stop();
    } else {
      setState(() {
        title = "Cuộc gọi khẩn cấp đã được xác nhận!";
        description =
            "Người thân của bạn đã xác nhận cuộc gọi khẩn cấp và đang trên đường đến!";
        isCompleteCreateConfirmation = true;
      });
      player.stop();
    }
  }

  Future<void> _sendEmergencyData() async {
    await _captureImages();
    await _getLocation();
    EmergencyController emergencyController = EmergencyController();
    await emergencyController.createEmergencyInformation(
      emergencyConfirmationId,
      frontImagePath ?? "",
      backImagePath ?? "",
      _currentPosition?.longitude.toString() ?? "",
      _currentPosition?.latitude.toString() ?? "",
      false,
      true,
    );
    if (emergencyController.isCreateSuccess) {
      setState(() {
        title = "Đã gửi thông tin khẩn cấp!";
        description =
            "Chúng tôi đã gửi thông tin khẩn cấp đến người thân của bạn và đang chờ tín hiệu từ họ!";
      });
    }
  }

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

  Future<void> _captureImages() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      // 1. Store current camera direction
      final currentLensDirection = _cameraController!.description.lensDirection;

      // 2. If currently using front camera, switch to rear first
      if (currentLensDirection == CameraLensDirection.front) {
        final rearCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
        );
        await _cameraController!.dispose();
        _cameraController =
            CameraController(rearCamera, ResolutionPreset.medium);
        await _cameraController!.initialize();
        setState(() {});
      }

      // 3. Capture back image first
      XFile backImage = await _cameraController!.takePicture();
      backImagePath = backImage.path;
      print("Back image captured: $backImagePath");

      // 4. Find front camera
      final frontCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      // 5. Switch to front camera
      await _cameraController!.dispose();
      _cameraController =
          CameraController(frontCamera, ResolutionPreset.medium);
      await _cameraController!.initialize();
      setState(() {});

      // 6. Capture front image
      XFile frontImage = await _cameraController!.takePicture();
      frontImagePath = frontImage.path;
      print("Front image captured: $frontImagePath");

      // 7. Always switch back to rear camera when done
      final rearCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );
      await _cameraController!.dispose();
      _cameraController = CameraController(rearCamera, ResolutionPreset.medium);
      await _cameraController!.initialize();
      setState(() {});
    } catch (e) {
      print("Error capturing images: $e");
      // Fallback to rear camera if anything fails
      if (_cameras != null && _cameras!.isNotEmpty) {
        final rearCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
        );
        await _cameraController?.dispose();
        _cameraController =
            CameraController(rearCamera, ResolutionPreset.medium);
        await _cameraController!.initialize();
        setState(() {});
      }
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
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);
    print(
        "Vị trí: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}");
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    record.dispose();
    _locationTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      expireEmergency();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[50],
        body: SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    description,
                    style: TextStyle(fontSize: 22, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 20),

                if (!isCompleteCreateConfirmation)
                  Center(
                    child: Text(
                      "$_countdown",
                      style: TextStyle(fontSize: 50, color: Colors.red),
                    ),
                  ),

                // 🔹 Nút đếm ngược
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Pulsator(
                        style: const PulseStyle(color: Colors.red),
                        count: _count,
                        duration: Duration(seconds: _duration),
                        repeat: _repeatCount,
                      ),
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Lottie.asset(
                            "assets/img/AnimationSOS.json",
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                            frameRate: FrameRate.max,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 50),

                // 🔹 Nút "Hủy"
                if (!isCompleteCreateConfirmation)
                  ElevatedButton(
                    onPressed:
                        _countdown == 0 ? showDialogCancel : _cancelEmergency,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Hủy",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                if (isCompleteCreateConfirmation)
                  ElevatedButton(
                    onPressed: () {
                      player.stop();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Trở về",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
