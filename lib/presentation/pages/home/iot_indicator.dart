import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sep490/features/blood_oxygen/screens/add_blood_oxygen.dart';
import 'package:sep490/features/blood_pressure/screens/add_blood_pressure_screen.dart';
import 'package:sep490/features/calories_burned/screens/add_calories_burned.dart';
import 'package:sep490/features/heart_beat/screens/add_heart_beat_screen.dart';
import 'package:sep490/features/height/screens/add_height_screen.dart';
import 'package:sep490/features/sleep/screens/add_sleep.dart';
import 'package:sep490/features/steps/screens/add_steps.dart';
import 'package:sep490/features/weight/screens/add_weight_screen.dart';
import 'package:sep490/presentation/widgets/loading/loadingImgPath.dart';
import 'package:sep490/theme/color.dart';
import 'package:url_launcher/url_launcher.dart';

class IotIndicator extends StatefulWidget {
  const IotIndicator({super.key});

  @override
  State<IotIndicator> createState() => _IotIndicatorState();
}

class _IotIndicatorState extends State<IotIndicator> {
  final health = Health();
  var types = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.TOTAL_CALORIES_BURNED,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.WEIGHT,
    HealthDataType.HEIGHT,
  ];
  bool requested = true;
  var today = DateTime.now();
  List<HealthDataPoint> healthData = [];
  var permissions = [
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
  ];
  bool isHealthConnectAvailable = false;
  bool? hasPermission;

  @override
  void initState() {
    super.initState();
    initHealth();
  }

  void initHealth() async {
    var result = await Permission.activityRecognition.request();
    await Permission.location.request();
    await Permission.sensors.request();
    if (result.isDenied || result.isPermanentlyDenied) {
      openAppSettings();
    }
    await health.configure();
    try {
      await health.requestAuthorization(types);
      await health.requestAuthorization(types, permissions: permissions);
      setState(() {
        requested = true;
        isHealthConnectAvailable = true;
        hasPermission = true;
      });
    } catch (e) {
      if (e.toString().contains("Health Connect is not available")) {
        setState(() {
          requested = false;
          isHealthConnectAvailable = false;
          hasPermission = false;
        });
      } else {
      }
    }
  }

  void handleClickGetHeartRate() async {
    LoadingDialog.show(
        context, 'assets/gif/iot_loading.gif', 'Đang cập nhật chỉ số...');
    await Future.delayed(const Duration(seconds: 1));
    var typesAuth = [HealthDataType.HEART_RATE];
    List<HealthDataPoint> data = [];
    try {
      data = await health.getHealthDataFromTypes(
        types: typesAuth,
        startTime: DateTime(today.year, today.month, today.day, 0, 0, 0),
        endTime: today,
      );
      if (data.isNotEmpty) {
        data.last.value = data.last.value;
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddHeartBeatScreen(
                    isDraft: true,
                    currentValue: (data.last.value as NumericHealthValue)
                        .numericValue
                        .toInt(),
                    showHeartBeatWidget: true,
                    dataType: "Tự động",
                  )),
        );
      } else {
        Navigator.pop(context);
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Không có dữ liệu nhịp tim trong ngày hôm nay",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        return;
      }
    } catch (e) {
      Navigator.pop(context);
      CherryToast.error(
        toastDuration: Duration(seconds: 3),
        title: Text(
          "Lấy dữ liệu thất bại, vui lòng thử lại sau",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ).show(context);
      return;
    }
    CherryToast.success(
      toastDuration: Duration(seconds: 3),
      title: Text(
        "Lấy dữ liệu thành công",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    ).show(context);
  }

  void handleClickGetBloodPressure() async {
    LoadingDialog.show(
        context, 'assets/gif/iot_loading.gif', 'Đang cập nhật chỉ số...');
    await Future.delayed(const Duration(seconds: 1));
    var typesSys = [HealthDataType.BLOOD_PRESSURE_SYSTOLIC];
    var typesDia = [HealthDataType.BLOOD_PRESSURE_DIASTOLIC];
    List<HealthDataPoint> dataSys = [];
    List<HealthDataPoint> dataDia = [];
    try {
      dataSys = await health.getHealthDataFromTypes(
        types: typesSys,
        startTime: DateTime(today.year, today.month, today.day, 0, 0, 0),
        endTime: today,
      );
      dataDia = await health.getHealthDataFromTypes(
        types: typesDia,
        startTime: DateTime(today.year, today.month, today.day, 0, 0, 0),
        endTime: today,
      );
      if (dataSys.isNotEmpty && dataDia.isNotEmpty) {
        dataSys.last.value = dataSys.last.value;
        dataDia.last.value = dataDia.last.value;
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddBloodPressureScreen(
                    isDraft: true,
                    currentValueSystolic:
                        (dataSys.last.value as NumericHealthValue)
                            .numericValue
                            .toInt(),
                    currentValueDiastolic:
                        (dataDia.last.value as NumericHealthValue)
                            .numericValue
                            .toInt(),
                    showBloodPressuretWidget: true,
                    dataType: "Tự động",
                  )),
        );
      } else {
        Navigator.pop(context);
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Không có dữ liệu huyết áp trong ngày hôm nay",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        return;
      }
    } catch (e) {
      Navigator.pop(context);
      CherryToast.error(
        toastDuration: Duration(seconds: 3),
        title: Text(
          "Lấy dữ liệu thất bại, vui lòng thử lại sau",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ).show(context);
      return;
    }
    CherryToast.success(
      toastDuration: Duration(seconds: 3),
      title: Text(
        "Lấy dữ liệu thành công",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    ).show(context);
  }

  void handleClickGetBloodOxygen() async {
    LoadingDialog.show(
        context, 'assets/gif/iot_loading.gif', 'Đang cập nhật chỉ số...');
    await Future.delayed(const Duration(seconds: 1));
    var typesAuth = [HealthDataType.BLOOD_OXYGEN];
    List<HealthDataPoint> data = [];
    try {
      data = await health.getHealthDataFromTypes(
        types: typesAuth,
        startTime: DateTime(today.year, today.month, today.day, 0, 0, 0),
        endTime: today,
      );
      if (data.isNotEmpty) {
        data.last.value = data.last.value;
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddBloodOxygen(
                    isDraft: true,
                    currentValue: (data.last.value as NumericHealthValue)
                        .numericValue
                        .toDouble(),
                    showHeartBeatWidget: true,
                    dataType: "Tự động",
                  )),
        );
      } else {
        Navigator.pop(context);
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Không có dữ liệu oxy trong máu trong ngày hôm nay",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        return;
      }
    } catch (e) {
      Navigator.pop(context);
      CherryToast.error(
        toastDuration: Duration(seconds: 3),
        title: Text(
          "Lấy dữ liệu thất bại, vui lòng thử lại sau",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ).show(context);
      return;
    }
    CherryToast.success(
      toastDuration: Duration(seconds: 3),
      title: Text(
        "Lấy dữ liệu thành công",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    ).show(context);
  }

  void handleClickGetSteps() async {
    LoadingDialog.show(
        context, 'assets/gif/iot_loading.gif', 'Đang cập nhật chỉ số...');
    await Future.delayed(const Duration(seconds: 1));
    var typesAuth = [HealthDataType.STEPS];
    List<HealthDataPoint> data = [];
    try {
      data = await health.getHealthDataFromTypes(
        types: typesAuth,
        startTime: DateTime(today.year, today.month, today.day, 0, 0, 0),
        endTime: today,
      );
      if (data.isNotEmpty) {
        data.last.value = data.last.value;
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddSteps(
                    isDraft: true,
                    currentValue: (data.last.value as NumericHealthValue)
                        .numericValue
                        .toInt(),
                    showHeartBeatWidget: true,
                    dataType: "Tự động",
                  )),
        );
      } else {
        Navigator.pop(context);
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Không có dữ liệu bước chân trong ngày hôm nay",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        return;
      }
    } catch (e) {
      Navigator.pop(context);
      CherryToast.error(
        toastDuration: Duration(seconds: 3),
        title: Text(
          "Lấy dữ liệu thất bại, vui lòng thử lại sau",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ).show(context);
      return;
    }
    CherryToast.success(
      toastDuration: Duration(seconds: 3),
      title: Text(
        "Lấy dữ liệu thành công",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    ).show(context);
  }

  void handleClickGetCaloriesBurned() async {
    LoadingDialog.show(
        context, 'assets/gif/iot_loading.gif', 'Đang cập nhật chỉ số...');
    await Future.delayed(const Duration(seconds: 1));
    var typesAuth = [HealthDataType.TOTAL_CALORIES_BURNED];
    List<HealthDataPoint> data = [];
    try {
      data = await health.getHealthDataFromTypes(
        types: typesAuth,
        startTime: DateTime(today.year, today.month, today.day, 0, 0, 0),
        endTime: today,
      );
      if (data.isNotEmpty) {
        double totalCalories = 0;
        for (var e in data) {
          totalCalories +=
              (e.value as NumericHealthValue).numericValue.toDouble();
        }
        data.last.value = data.last.value;
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddCaloriesBurned(
                    isDraft: true,
                    currentValue:
                        double.parse(totalCalories.toStringAsFixed(1)),
                    showHeartBeatWidget: true,
                    dataType: "Tự động",
                  )),
        );
      } else {
        Navigator.pop(context);
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Không có dữ liệu kcal tiêu thụ trong ngày hôm nay",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        return;
      }
    } catch (e) {
      Navigator.pop(context);
      CherryToast.error(
        toastDuration: Duration(seconds: 3),
        title: Text(
          "Lấy dữ liệu thất bại, vui lòng thử lại sau",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ).show(context);
      return;
    }
    CherryToast.success(
      toastDuration: Duration(seconds: 3),
      title: Text(
        "Lấy dữ liệu thành công",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    ).show(context);
  }

  void handleClickGetSleep() async {
    LoadingDialog.show(
        context, 'assets/gif/iot_loading.gif', 'Đang cập nhật chỉ số...');
    await Future.delayed(const Duration(seconds: 1));
    var typesAuth = [HealthDataType.SLEEP_SESSION];
    List<HealthDataPoint> data = [];
    try {
      data = await health.getHealthDataFromTypes(
        types: typesAuth,
        startTime: DateTime(today.year, today.month, today.day, 0, 0, 0)
            .subtract(Duration(days: 1)),
        endTime: today,
      );
      if (data.isNotEmpty) {
        data.last.value = data.last.value;
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddSleep(
                    isDraft: true,
                    currentValue: (data.last.value as NumericHealthValue)
                        .numericValue
                        .toInt(),
                    showHeartBeatWidget: true,
                    dataType: "Tự động",
                  )),
        );
      } else {
        Navigator.pop(context);
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Không có dữ liệu giấc ngủ trong ngày hôm nay",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        return;
      }
    } catch (e) {
      Navigator.pop(context);
      CherryToast.error(
        toastDuration: Duration(seconds: 3),
        title: Text(
          "Lấy dữ liệu thất bại, vui lòng thử lại sau",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ).show(context);
      return;
    }
    CherryToast.success(
      toastDuration: Duration(seconds: 3),
      title: Text(
        "Lấy dữ liệu thành công",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    ).show(context);
  }

  void handleClickGetHeight() async {
    LoadingDialog.show(
        context, 'assets/gif/iot_loading.gif', 'Đang cập nhật chỉ số...');
    await Future.delayed(const Duration(seconds: 1));
    var typesAuth = [HealthDataType.HEIGHT];
    List<HealthDataPoint> data = [];
    try {
      data = await health.getHealthDataFromTypes(
        types: typesAuth,
        startTime: DateTime(today.year, today.month, today.day, 0, 0, 0),
        endTime: today,
      );
      if (data.isNotEmpty) {
        data.last.value = data.last.value;
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddHeightScreen(
                    isDraft: true,
                    currentValue: (data.last.value as NumericHealthValue)
                            .numericValue
                            .toDouble() *
                        100,
                    showHeightWidget: true,
                    dataType: "Tự động",
                  )),
        );
      } else {
        Navigator.pop(context);
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Không có dữ liệu chiều cao trong ngày hôm nay",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        return;
      }
    } catch (e) {
      Navigator.pop(context);
      CherryToast.error(
        toastDuration: Duration(seconds: 3),
        title: Text(
          "Lấy dữ liệu thất bại, vui lòng thử lại sau",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ).show(context);
      return;
    }
    CherryToast.success(
      toastDuration: Duration(seconds: 3),
      title: Text(
        "Lấy dữ liệu thành công",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    ).show(context);
  }

  void handleClickGetWeight() async {
    LoadingDialog.show(
        context, 'assets/gif/iot_loading.gif', 'Đang cập nhật chỉ số...');
    await Future.delayed(const Duration(seconds: 1));
    var typesAuth = [HealthDataType.WEIGHT];
    List<HealthDataPoint> data = [];
    try {
      data = await health.getHealthDataFromTypes(
        types: typesAuth,
        startTime: DateTime(today.year, today.month, today.day, 0, 0, 0),
        endTime: today,
      );
      if (data.isNotEmpty) {
        data.last.value = data.last.value;
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddWeight(
                    isDraft: true,
                    currentValue: (data.last.value as NumericHealthValue)
                        .numericValue
                        .toDouble(),
                    showWeightWidget: true,
                    dataType: "Tự động",
                  )),
        );
      } else {
        Navigator.pop(context);
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Không có dữ liệu cân nặng trong ngày hôm nay",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        return;
      }
    } catch (e) {
      Navigator.pop(context);
      CherryToast.error(
        toastDuration: Duration(seconds: 3),
        title: Text(
          "Lấy dữ liệu thất bại, vui lòng thử lại sau",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ).show(context);
      return;
    }
    CherryToast.success(
      toastDuration: Duration(seconds: 3),
      title: Text(
        "Lấy dữ liệu thành công",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text('Chỉ số tự động',
            style: TextStyle(
                color: AppColors.secondaryColor,
                fontSize: 25,
                fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.bgColor,
        centerTitle: true,
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/background_app.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: requested
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        _buildHealthDataCard(
                            handleClickGetHeartRate,
                            'assets/img3D/nhiptim.png',
                            'Nhịp tim',
                            'Thêm chỉ số đo'),
                        const SizedBox(height: 20),
                        _buildHealthDataCard(
                            handleClickGetBloodPressure,
                            'assets/img3D/huyetap.png',
                            'Huyết áp',
                            'Thêm chỉ số đo'),
                        const SizedBox(height: 20),
                        _buildHealthDataCard(
                            handleClickGetBloodOxygen,
                            'assets/img3D/oxy_mau.png',
                            'Oxy trong máu',
                            'Thêm chỉ số đo'),
                        const SizedBox(height: 20),
                        _buildHealthDataCard(
                            handleClickGetSteps,
                            'assets/img3D/buoc_chan.png',
                            'Số bước chân',
                            'Thêm chỉ số đo'),
                        const SizedBox(height: 20),
                        _buildHealthDataCard(
                            handleClickGetCaloriesBurned,
                            'assets/img3D/kcal.png',
                            'Năng lượng tiêu thụ',
                            'Thêm chỉ số đo'),
                        const SizedBox(height: 20),
                        _buildHealthDataCard(
                            handleClickGetSleep,
                            'assets/img3D/giac_ngu.png',
                            'Thời gian ngủ',
                            'Thêm chỉ số đo'),
                        // const SizedBox(height: 20),
                        // _buildHealthDataCard(
                        //     handleClickGetWeight,
                        //     'assets/img3D/cannang.png',
                        //     'Cân nặng',
                        //     'Thêm chỉ số đo'),
                        // const SizedBox(height: 20),
                        // _buildHealthDataCard(
                        //     handleClickGetHeight,
                        //     'assets/img3D/chieucao.png',
                        //     'Chiều cao',
                        //     'Thêm chỉ số đo'),
                      ],
                    ),
                  ),
                )
              : isHealthConnectAvailable
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/img3D/health_connect.png',
                            width: 200,
                            height: 200,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Vui lòng cấp quyền truy cập dữ liệu sức khỏe',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              openAppSettings();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondaryColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text('Cấp quyền', style: TextStyle(color: AppColors.bgColor),),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/img3D/health_connect.png',
                            width: 200,
                            height: 200,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Chức năng cần sự hỗ trợ của ứng dụng Health Connect',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              const url =
                                  'https://play.google.com/store/apps/details?id=com.google.android.apps.healthdata';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url),
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondaryColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text('Cài đặt ngay', style: TextStyle(color: AppColors.bgColor),),
                          ),
                        ],
                      ),
                    )),
    );
  }

  Widget _buildHealthDataCard(VoidCallback onTapFunction, String imgPath,
      String title, String description) {
    return GestureDetector(
      onTap: onTapFunction,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imgPath,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
