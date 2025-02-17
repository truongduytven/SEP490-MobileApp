import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sep490/presentation/pages/health/detail_blood_pressure_screen.dart';
import 'package:sep490/presentation/pages/health/detail_heart_beat_screen.dart';
import 'package:sep490/presentation/pages/health/detail_height_screen.dart';
import 'package:sep490/presentation/pages/health/detail_medicine_screen.dart';
import 'package:sep490/presentation/pages/health/detail_weight_screen.dart';
import 'package:sep490/presentation/pages/health/health_monitoring_book.dart';
import 'package:sep490/presentation/pages/medicine/home_medicine.dart';
import 'package:sep490/presentation/pages/schedule/schedule_screen.dart';
import 'package:sep490/presentation/widgets/header.dart';
import 'package:sep490/presentation/widgets/health_card.dart';
import 'package:sep490/theme/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String today = '';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi', null).then((_) {
      setState(() {
        today = DateFormat('EEEE, dd MMMM yyyy', 'vi').format(DateTime.now());
      });
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
                      const SizedBox(height: 20),
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
                          const SizedBox(height: 40),
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
                          SizedBox(height: 150),
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
                                onTap: () {
                                  print("Thuốc clicked");
                                },
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
