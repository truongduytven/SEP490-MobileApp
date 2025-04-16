import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/blood_pressure/screens/detail_blood_pressure_screen.dart';
import 'package:sep490/features/heart_beat/screens/detail_heart_beat_screen.dart';
import 'package:sep490/features/height/screens/detail_height_screen.dart';
import 'package:sep490/models/home_model.dart';
import 'package:sep490/models/schedule.dart';
import 'package:sep490/features/weight/screens/detail_weight_screen.dart';
import 'package:sep490/features/health/screens/health_monitoring_book.dart';
import 'package:sep490/presentation/pages/home/controller/home_controller.dart';
import 'package:sep490/presentation/pages/home/iot_indicator.dart';
import 'package:sep490/presentation/pages/home/view_detail_elderly.dart';
import 'package:sep490/presentation/pages/medicine/home_medicine.dart';
import 'package:sep490/presentation/pages/schedule/Controller/schedule_controller.dart';
import 'package:sep490/presentation/pages/schedule/schedule_screen.dart';
import 'package:sep490/presentation/widgets/header.dart';
import 'package:sep490/presentation/widgets/health_card.dart';
import 'package:sep490/presentation/widgets/loading/loadingImgPath.dart';
import 'package:sep490/theme/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String today = '';
  final Map<String, dynamic> activity = {
    "ActivityName": "Uống thuốc",
    "ActivityDescription": "Penicilin v kali 500mg\nDùng 1 vào 8:00 (sau ăn)",
    "StartTime": DateTime(2025, 2, 16, 9, 0),
    "EndTime": DateTime(2025, 2, 16, 10, 0),
  };
  String startTime = '';
  String endTime = '';
  List<HomeHealthIndicator>? homeHealthIndicators;
  bool isLoading = false;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int accountId = 0;
  late int roleId = 0;
  Map<String, dynamic> healthIndicators = {
    "HeartRate": "0",
    "BloodPressure": "0",
    "LipidProfile": "0",
    "LiverEnzyme": "0",
    "BloodGlucose": "0",
    "KidneyFunction": "0",
    "Weight": "0",
    "Height": "0",
  };
  List<Activity>? schedule;
  bool isLoadingSchedule = false;
  late List<ElderlyUser>? userList = null;
  late int? selectedElderlyUserId;
  late String? selectedElderlyUserName;
  late int? selectedElderlyId;
  bool isShowSelectUser = false;
  bool isLoadingDialog = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi', null).then((_) {
      setState(() {
        today = DateFormat('EEEE, dd MMMM yyyy', 'vi').format(DateTime.now());
      });
    });
    accountId = sharedPrefsHelper.getInt('accountId') ?? 0;
    roleId = sharedPrefsHelper.getInt('roleId') ?? 0;
    selectedElderlyUserId =
        sharedPrefsHelper.getInt('selectedElderlyUserId') ?? 0;
    selectedElderlyUserName =
        sharedPrefsHelper.getString('selectedElderlyUserName') ?? '';
    selectedElderlyId = sharedPrefsHelper.getInt('selectedElderlyId') ?? 0;
    startTime = DateFormat.jm().format(activity['StartTime'] as DateTime);
    endTime = DateFormat.jm().format(activity['EndTime'] as DateTime);
    if (roleId == 2) {
      getHealthIndicator();
      getSchedule();
    }
    if (roleId == 3) {
      getElderlyUser();
    }
    if (roleId == 4) {
      getElderlyUserProfessor();
    }
  }

  void _showSelectDialog() {
    showDialog(
      barrierColor: AppColors.secondaryColor.withOpacity(0.95),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(20),
          backgroundColor: AppColors.bgColor,
          title: const Text(
            "Hỗ trợ từ người thân",
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w600, height: 1.2),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Chọn một người để xem hoặc thêm mới",
                  style: TextStyle(
                      color: AppColors.grayColor5, fontSize: 16, height: 1.2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: SizedBox(
                    height: 300,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: userList!.length,
                      itemBuilder: (context, index) {
                        // if (index == userList!.length) {
                        //   return Container(
                        //     decoration: BoxDecoration(
                        //       border: Border.all(
                        //         color: AppColors.borderColor,
                        //         width: 1.5,
                        //       ),
                        //       borderRadius: BorderRadius.circular(8.0),
                        //     ),
                        //     margin: const EdgeInsets.symmetric(vertical: 4.0),
                        //     padding: EdgeInsets.symmetric(vertical: 5),
                        //     child: ListTile(
                        //       leading: CircleAvatar(
                        //         radius: 22,
                        //         backgroundColor: Colors.transparent,
                        //         child: const Icon(
                        //             Icons.person_add_alt_1_outlined,
                        //             color: AppColors.primaryColor),
                        //       ),
                        //       title: const Text(
                        //         "Thêm người mới",
                        //         style: TextStyle(fontSize: 20),
                        //       ),
                        //       onTap: () {
                        //         Navigator.of(context).pop();
                        //       },
                        //     ),
                        //   );
                        // }

                        final user = userList![index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedElderlyUserId =
                                  userList![index].accountId;
                              selectedElderlyUserName =
                                  userList![index].fullName;
                            });
                            sharedPrefsHelper.setInt('selectedElderlyUserId',
                                userList![index].accountId);
                            sharedPrefsHelper.setString(
                                'selectedElderlyUserName',
                                userList![index].fullName);
                            sharedPrefsHelper.setInt('selectedElderlyId',
                                userList![index].elderlyId);
                            CherryToast.success(
                              toastDuration: Duration(seconds: 3),
                              title: Text(
                                'Bạn đang hỗ trợ ${userList![index].fullName}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ).show(context);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: user.accountId == selectedElderlyUserId
                                    ? AppColors.primaryColor
                                    : AppColors.borderColor,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  user.avatar,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: user.accountId ==
                                              selectedElderlyUserId
                                          ? AppColors.primaryColor
                                          : AppColors.textColor,
                                      fontWeight: user.accountId ==
                                              selectedElderlyUserId
                                          ? FontWeight.w600
                                          : null,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    user.phoneNumber,
                                    style: TextStyle(
                                      color: AppColors.grayColor3,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: user.accountId == selectedElderlyUserId
                                  ? const Icon(Icons.check_circle_rounded,
                                      size: 28, color: AppColors.primaryColor)
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Đóng",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  void getHealthIndicator() async {
    setState(() {
      isLoading = true;
    });
    HomeController homeController = HomeController();
    await homeController.getHealthIndicator(accountId);
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        homeHealthIndicators = homeController.homeHealthIndicators;
      });
      if (homeController.homeHealthIndicators != null) {
        filterDataHealth();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void getSchedule() async {
    setState(() {
      isLoadingSchedule = true;
    });
    ScheduleController scheduleController = ScheduleController();
    await scheduleController.getSchedule(accountId,
        '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, "0")}-${DateTime.now().day.toString().padLeft(2, "0")}');
    Timer(Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        schedule = scheduleController.schedule;
        isLoadingSchedule = false;
      });
    });
  }

  void getElderlyUser() async {
    setState(() {
      isLoadingDialog = true;
    });
    HomeController homeController = HomeController();
    await homeController.getElderlyUser(accountId);
    if (!mounted) return;
    setState(() {
      isLoadingDialog = false;
      userList = homeController.elderlyUsers;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userList == null) {
        return;
      }
      if (sharedPrefsHelper.getInt('selectedElderlyUserId') != null) {
        return;
      }
      if (userList!.isNotEmpty && selectedElderlyUserId == 0) {
        selectedElderlyUserId = userList![0].accountId;
        selectedElderlyUserName = userList![0].fullName;
        sharedPrefsHelper.setInt(
            'selectedElderlyUserId', userList![0].accountId);
        sharedPrefsHelper.setString(
            'selectedElderlyUserName', userList![0].fullName);
        sharedPrefsHelper.setInt('selectedElderlyId', userList![0].elderlyId);
      }
      _showSelectDialog();
    });
  }

  void getElderlyUserProfessor() async {
    setState(() {
      isLoadingDialog = true;
    });
    HomeController homeController = HomeController();
    await homeController.getElderlyUserProfessor(accountId);
    if (!mounted) return;
    setState(() {
      isLoadingDialog = false;
      userList = homeController.elderlyUsers;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userList == null) {
        return;
      }
      if (sharedPrefsHelper.getInt('selectedElderlyUserId') != null) {
        return;
      }
      if (userList!.isNotEmpty && selectedElderlyUserId == 0) {
        // selectedElderlyUserId = userList![0].accountId;
        // selectedElderlyUserName = userList![0].fullName;
        // sharedPrefsHelper.setInt(
        //     'selectedElderlyUserId', userList![0].accountId);
        // sharedPrefsHelper.setString(
        //     'selectedElderlyUserName', userList![0].fullName);
        // sharedPrefsHelper.setInt('selectedElderlyId', userList![0].elderlyId);
      }
    });
  }

  void filterDataHealth() {
    if (homeHealthIndicators == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    for (var e in homeHealthIndicators!) {
      switch (e.tabs) {
        case "HeartRate":
          healthIndicators['HeartRate'] = e.indicator;
          break;
        case "BloodPressure":
          healthIndicators['BloodPressure'] = e.indicator;
          break;
        case "LipidProfile":
          healthIndicators['LipidProfile'] = e.indicator;
          break;
        case "LiverEnzyme":
          healthIndicators['LiverEnzyme'] = e.indicator;
          break;
        case "BloodGlucose":
          healthIndicators['BloodGlucose'] = e.indicator;
          break;
        case "KidneyFunction":
          healthIndicators['KidneyFunction'] = e.indicator;
          break;
        case "Weight":
          healthIndicators['Weight'] = e.indicator;
          break;
        case "Height":
          healthIndicators['Height'] = e.indicator;
          break;
        default:
          break;
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget _getActivityIcon(String activityName) {
    switch (activityName) {
      case "Medication":
        return Image.asset('assets/img3D/thuoc.png', width: 50, height: 50);
      case "Professor Appointment":
        return Image.asset('assets/img3D/bacsi.png', width: 50, height: 50);
      default:
        return Image.asset('assets/img3D/calendar.png', width: 50, height: 50);
    }
  }

  Color? getColors(String activityName) {
    switch (activityName) {
      case "Medication":
        return Colors.yellow[200];
      case "Professor Appointment":
        return Colors.blue[200];
      default:
        return Colors.green[200];
    }
  }

  void handleClickLoading() {
    LoadingDialog.show(context, 'assets/gif/opd.gif', 'Đang tải dữ liệu...');
    Timer(Duration(seconds: 10), () {
      Navigator.pop(context);
      LoadingDialog.show(context, 'assets/gif/create_success.gif',
          'Tạo toa thuốc thành công!');
    });
    Timer(Duration(seconds: 20), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/background_app.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Header(
                        onPressed: _showSelectDialog,
                        isChooseElderly: roleId == 3,
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          if (roleId == 2)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sức khỏe',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            HealthMonitoringBook(
                                          initialTopic: "all",
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Text(
                                      'Xem tất cả',
                                      style: TextStyle(
                                        fontSize: 18,
                                        decoration: TextDecoration.underline,
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (roleId == 2) const SizedBox(height: 20),
                          if (roleId == 2)
                            isLoading
                                ? SizedBox(
                                    height: 120,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        HealthCard(
                                          icon: 'assets/img3D/nhiptim.png',
                                          label: 'Nhịp tim',
                                          value:
                                              '${healthIndicators['HeartRate']}',
                                          index: 'BPM',
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailHeartBeatScreen(), // Replace with the correct screen
                                              ),
                                            );
                                          },
                                        ),
                                        HealthCard(
                                          icon: 'assets/img3D/huyetap.png',
                                          label: 'Huyết áp',
                                          value:
                                              '${healthIndicators['BloodPressure']}',
                                          index: 'MmHg',
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailBloodPressureScreen(), // Replace with the correct screen
                                              ),
                                            );
                                          },
                                        ),
                                        HealthCard(
                                          icon:
                                              'assets/img3D/treatment_medical/momau.webp',
                                          label: 'Mỡ máu',
                                          value:
                                              '${healthIndicators['LipidProfile']}',
                                          index: 'mmol/l',
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailWeightScreen(), // Replace with the correct screen
                                              ),
                                            );
                                          },
                                        ),
                                        HealthCard(
                                          icon:
                                              'assets/img3D/treatment_medical/gan.png',
                                          label: 'Men gan',
                                          value:
                                              '${healthIndicators['LiverEnzyme']}',
                                          index: 'UI/L',
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailWeightScreen(), // Replace with the correct screen
                                              ),
                                            );
                                          },
                                        ),
                                        HealthCard(
                                          icon:
                                              'assets/img3D/treatment_medical/tieuduong.png',
                                          label: 'Đường huyết',
                                          value:
                                              '${healthIndicators['BloodGlucose']}',
                                          index: 'mmol/l',
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailWeightScreen(), // Replace with the correct screen
                                              ),
                                            );
                                          },
                                        ),
                                        HealthCard(
                                          icon:
                                              'assets/img3D/treatment_medical/than.png',
                                          label: 'Chức năng thận',
                                          value:
                                              '${healthIndicators['KidneyFunction']}',
                                          index: 'mL/phút/1.73m2',
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailWeightScreen(), // Replace with the correct screen
                                              ),
                                            );
                                          },
                                        ),
                                        HealthCard(
                                          icon: 'assets/img3D/cannang.png',
                                          label: 'Cân nặng',
                                          value:
                                              '${healthIndicators['Weight']}',
                                          index: 'Kg',
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailWeightScreen(), // Replace with the correct screen
                                              ),
                                            );
                                          },
                                        ),
                                        HealthCard(
                                          icon: 'assets/img3D/chieucao.png',
                                          label: 'Chiều cao',
                                          value:
                                              '${healthIndicators['Height']}',
                                          index: 'cm',
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailHeightScreen(), // Replace with the correct screen
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                          if (roleId == 2) const SizedBox(height: 20),
                          if (roleId == 2)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Lịch trình hôm nay',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ScheduleScreen()),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Text(
                                      'Xem tất cả',
                                      style: TextStyle(
                                        fontSize: 18,
                                        decoration: TextDecoration.underline,
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (roleId == 2) SizedBox(height: 15),
                          if (roleId == 2)
                            Center(
                              child: Text(today,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryColor)),
                            ),
                          if (roleId == 2)
                            isLoadingSchedule
                                ? SizedBox(
                                    height: 170,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  )
                                : schedule != null
                                    ? schedule!.isNotEmpty
                                        ? CarouselSlider(
                                            options: CarouselOptions(
                                                height: 170,
                                                autoPlay: true,
                                                enlargeCenterPage: false,
                                                aspectRatio: 16 / 9,
                                                viewportFraction: 0.85,
                                                enableInfiniteScroll: false),
                                            items: schedule!.map((item) {
                                              return Builder(
                                                builder:
                                                    (BuildContext context) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ScheduleScreen(),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10,
                                                          horizontal: 16),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      decoration: BoxDecoration(
                                                        color: getColors(
                                                            item.type),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: AppColors
                                                                .secondaryColor
                                                                .withOpacity(
                                                                    0.3),
                                                            blurRadius: 4,
                                                            offset:
                                                                const Offset(
                                                                    0, 4),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          // Activity Icon
                                                          _getActivityIcon(
                                                              item.type),
                                                          const SizedBox(
                                                              width: 12),
                                                          // Activity Details
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  item.title,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: AppColors
                                                                          .textColor),
                                                                ),
                                                                const SizedBox(
                                                                    height: 8),
                                                                Text(
                                                                  item.description,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                                const SizedBox(
                                                                    height: 8),
                                                                Text(
                                                                  "Còn ${item.duration} ngày nữa",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                                const SizedBox(
                                                                    height: 8),
                                                                Text(
                                                                  '${item.startTime} ${item.endTime != '' ? '-' : ''} ${item.endTime}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: AppColors
                                                                          .textColor),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }).toList(),
                                          )
                                        : SizedBox(
                                            height: 170,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(height: 10),
                                                Image.asset(
                                                    'assets/img/no-data.png',
                                                    width: 50,
                                                    height: 50),
                                                const SizedBox(height: 10),
                                                const Text(
                                                  'Không có lịch trình nào trong ngày hôm nay',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.textColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                    : SizedBox(
                                        height: 170,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 10),
                                            Image.asset(
                                                'assets/img/no-data.png',
                                                width: 50,
                                                height: 50),
                                            const SizedBox(height: 10),
                                            const Text(
                                              'Không có lịch trình nào trong ngày hôm nay',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                          if (roleId == 2) const SizedBox(height: 20),
                          if (roleId == 2)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tùy chọn khác',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor),
                                ),
                              ],
                            ),
                          if (roleId == 3)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tùy chọn',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor),
                                ),
                              ],
                            ),
                          if (roleId != 4)
                          SizedBox(height: 20),
                          if (roleId != 4)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCategoryCard(
                                icon:
                                    'assets/img3D/thuoc.png', // Replace with your asset path
                                label: 'Lịch uống thuốc',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeMedicine(),
                                    ),
                                  );
                                },
                              ),
                              if (roleId == 3)
                                _buildCategoryCard(
                                  icon:
                                      'assets/img3D/calendar_create.webp', // Replace with your asset path
                                  label: 'Lịch trình hằng ngày',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ScheduleScreen(),
                                      ),
                                    );
                                  },
                                ),
                              if (roleId == 2)
                                _buildCategoryCard(
                                  icon:
                                      'assets/img3D/uong_nuoc.png', // Replace with your asset path
                                  label: 'Uống nước',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ScheduleScreen(),
                                      ),
                                    );
                                  },
                                ),
                              if (roleId == 2)
                                _buildCategoryCard(
                                  icon:
                                      'assets/img3D/thietbideotay.png', // Replace with your asset path
                                  label: 'Thiết bị đeo tay',
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IotIndicator()));
                                  },
                                ),
                            ],
                          ),
                          if (roleId == 4)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Danh sách người già đang hỗ trợ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor),
                                ),
                              ],
                            ),
                          if (roleId == 4) const SizedBox(height: 20),
                          if (roleId == 4)
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  if (userList != null)
                                    for (var user in userList!)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedElderlyUserId =
                                                user.accountId;
                                            selectedElderlyUserName =
                                                user.fullName;
                                          });
                                          sharedPrefsHelper.setInt(
                                              'selectedElderlyUserId',
                                              user.accountId);
                                          sharedPrefsHelper.setString(
                                              'selectedElderlyUserName',
                                              user.fullName);
                                          sharedPrefsHelper.setInt(
                                              'selectedElderlyId',
                                              user.elderlyId);
                                        },
                                        child: _buildElderlyUserCard(
                                          user: user,
                                        ),
                                      ),
                                  if (userList == null)
                                    const Center(
                                      child: Text(
                                        'Không có người già nào được hỗ trợ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 30,
                backgroundImage: AssetImage(icon),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElderlyUserCard({required ElderlyUser user}) {
    return GestureDetector(
      onTap: () {
        selectedElderlyUserId = user.accountId;
        selectedElderlyUserName = user.fullName;
        sharedPrefsHelper.setInt('selectedElderlyUserId', user.accountId);
        sharedPrefsHelper.setString('selectedElderlyUserName', user.fullName);
        sharedPrefsHelper.setInt('selectedElderlyId', user.elderlyId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewDetailElderly(
              elderlyUser: user,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryColor.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                user.avatar,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.phoneNumber,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.grayColor3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}
