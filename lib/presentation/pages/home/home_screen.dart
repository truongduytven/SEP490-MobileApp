import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sep490/presentation/pages/medicine/home_medicine.dart';
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
    // Initialize locale formatting
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/img/avatar.jpg'),
                            radius: 25,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: AppColors.bgColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 15,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[
                            Text(
                              "Xin chào,",
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1,
                                wordSpacing: 2,
                              ),
                            ),
                            Text(
                              'Nguyễn Văn A',
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                wordSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        // padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.grayColor4.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications,
                            color: AppColors.textColor,
                          ),
                          iconSize: 25,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        // padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.grayColor4
                              .withOpacity(0.3), // Gray background
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add,
                            color: AppColors.textColor,
                          ),
                          iconSize: 30,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
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
                      print("Xem tất cả clicked!");
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
            ),
            // Container(
            //   height: 1, // Thickness of the line
            //   width: double.infinity, // Full width
            //   color: AppColors.textColor.withOpacity(0.2), // Line color
            // ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    HealthCard(
                        icon: 'assets/img3D/nhiptim.png',
                        label: 'Nhịp tim',
                        value: '75',
                        index: 'BPM'),
                    HealthCard(
                        icon: 'assets/img3D/huyetap.png',
                        label: 'Huyết áp',
                        value: '120/80',
                        index: 'MmHg'),
                    HealthCard(
                        icon: 'assets/img3D/thuoc.png',
                        label: 'Thuốc',
                        value: '0/3',
                        index: 'Liều'),
                    HealthCard(
                        icon: 'assets/img3D/cannang.png',
                        label: 'Cân nặng',
                        value: '45',
                        index: 'Kg'),
                    HealthCard(
                        icon: 'assets/img3D/chieucao.png',
                        label: 'Chiều cao',
                        value: '150',
                        index: 'cm'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
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
                      print("Xem tất cả clicked!");
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mục khác',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     print("Xem tất cả clicked!");
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 5, vertical: 2),
                  //     child: Text(
                  //       'Xem tất cả',
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //         decoration: TextDecoration.underline,
                  //         color: AppColors.textColor,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryCard(
                  icon:
                      'assets/img3D/thuoc.png', // Replace with your asset path
                  label: 'Thuốc',
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
                      'assets/img3D/bacsi.png', // Replace with your asset path
                  label: 'Tư vấn bác sĩ',
                  onTap: () {
                    print("Thuốc clicked");
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
            )
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
                fontSize: 22,
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
