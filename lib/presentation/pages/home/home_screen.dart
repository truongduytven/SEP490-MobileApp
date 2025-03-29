import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sep490/features/blood_pressure/screens/detail_blood_pressure_screen.dart';
import 'package:sep490/features/heart_beat/screens/detail_heart_beat_screen.dart';
import 'package:sep490/features/height/screens/detail_height_screen.dart';
import 'package:sep490/presentation/pages/health/detail_medicine_screen.dart';
import 'package:sep490/features/weight/screens/detail_weight_screen.dart';
import 'package:sep490/features/health/screens/health_monitoring_book.dart';
import 'package:sep490/presentation/pages/medicine/home_medicine.dart';
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

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi', null).then((_) {
      setState(() {
        today = DateFormat('EEEE, dd MMMM yyyy', 'vi').format(DateTime.now());
      });
    });
    startTime = DateFormat.jm().format(activity['StartTime'] as DateTime);
    endTime = DateFormat.jm().format(activity['EndTime'] as DateTime);
  }

  Widget _getActivityIcon(String activityName) {
    switch (activityName) {
      case "Uống thuốc":
        return Image.asset('assets/img3D/thuoc.png', width: 50, height: 50);
      case "Tư vấn với bác sĩ":
        return Image.asset('assets/img3D/bacsi.png', width: 50, height: 50);
      case "Tập luyện":
        return Image.asset('assets/img3D/cannang.png', width: 50, height: 50);
      default:
        return Icon(Icons.event, color: AppColors.secondaryColor, size: 50);
    }
  }

  Color? getColors(String activityName) {
    switch (activityName) {
      case "Uống thuốc":
        return Colors.yellow[400];
      case "Tư vấn với bác sĩ":
        return Colors.blue[400];
      case "Tập luyện":
        return Colors.green[400];
      default:
        return Colors.orange[400];
    }
  }

  void handleClickLoading() {
    LoadingDialog.show(context, 'assets/gif/opd.gif', 'Đang tải dữ liệu...');
    Timer(Duration(seconds: 10), () {
      Navigator.pop(context);
      LoadingDialog.show(context, 'assets/gif/create_success.gif', 'Tạo toa thuốc thành công!');
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
                      Header(),
                      const SizedBox(height: 10),
                      Column(
                        children: [
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
                          const SizedBox(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                HealthCard(
                                  icon: 'assets/img3D/nhiptim.png',
                                  label: 'Nhịp tim',
                                  value: '75',
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
                                  value: '120/80',
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
                                  icon: 'assets/img3D/thuoc.png',
                                  label: 'Thuốc',
                                  value: '0/3',
                                  index: 'Liều',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailMedicineScreen(), // Replace with the correct screen
                                      ),
                                    );
                                  },
                                ),
                                HealthCard(
                                  icon: 'assets/img3D/cannang.png',
                                  label: 'Cân nặng',
                                  value: '45',
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
                                  value: '150',
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
                          const SizedBox(height: 20),
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
                                        builder: (context) => ScheduleScreen()),
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
                          SizedBox(height: 15),
                          Center(
                            child: Text(today,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryColor)),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: getColors(activity['ActivityName']),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.secondaryColor.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Activity Icon
                                _getActivityIcon(activity['ActivityName']),
                                const SizedBox(width: 12),
                                // Activity Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        activity['ActivityName'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textColor),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        activity['ActivityDescription'],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '$startTime - $endTime',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mục khác',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              _buildCategoryCard(
                                icon:
                                    'assets/img3D/uong_nuoc.png', // Replace with your asset path
                                label: 'Nhắc nhở uống nước',
                                onTap: () {
                                  print("Bác sĩ clicked");
                                },
                              ),
                              _buildCategoryCard(
                                icon:
                                    'assets/img3D/thietbideotay.png', // Replace with your asset path
                                label: 'Thiết bị đeo tay',
                                onTap: handleClickLoading,
                              ),
                            ],
                          ),
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
}
