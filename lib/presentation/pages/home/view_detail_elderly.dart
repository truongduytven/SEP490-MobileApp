import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/features/health/screens/health_screen.dart';
import 'package:sep490/models/home_model.dart';
import 'package:sep490/presentation/pages/home/controller/home_controller.dart';
import 'package:sep490/presentation/pages/home/medical_record.dart';
import 'package:sep490/presentation/pages/medicine/home_medicine.dart';
import 'package:sep490/theme/color.dart';

class ViewDetailElderly extends StatefulWidget {
  final ElderlyUser? elderlyUser;
  final int? elderlyId;
  const ViewDetailElderly({super.key, this.elderlyUser, this.elderlyId});

  @override
  State<ViewDetailElderly> createState() => _ViewDetailElderlyState();
}

class _ViewDetailElderlyState extends State<ViewDetailElderly> {
  late ElderlyUser? elderlyUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.elderlyUser != null) {
      elderlyUser = widget.elderlyUser;
      isLoading = false;
    } else {
      getElderlyData();
    }
  }

  void getElderlyData() async {
    setState(() {
      isLoading = true;
    });
    HomeController homeController = HomeController();
    await homeController.getElderlyUserInformation(widget.elderlyId! ?? 0);
    Timer(Duration(seconds: 1), () {
      if (homeController.elderlyUser != null) {
        elderlyUser = homeController.elderlyUser;
      } else {
        elderlyUser = null;
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text(
          'Chi tiết người già',
          style: TextStyle(
              color: AppColors.secondaryColor,
              fontSize: 25,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.secondaryColor,
              ),
            )
          : Padding(
              padding: EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            elderlyUser!.avatar,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      elderlyUser!.fullName,
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      elderlyUser!.gender == 'Male' ? 'Nam' : 'Nữ',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "SĐT: ${elderlyUser!.phoneNumber}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Sinh ngày: ${DateFormat('dd/MM/yyyy').format(
                        DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                            .parse(elderlyUser!.dateOfBirth),
                      )}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryColor),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MedicalRecord(
                              elderlyId: elderlyUser!.accountId,
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
                          border: Border.all(
                            color: AppColors.secondaryColor.withOpacity(0.3),
                            width: 1,
                          ),
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
                            Image.asset('assets/img3D/sotheodoi.png',
                                width: 40),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hồ sơ bệnh án",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "xem bệnh án của người già",
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
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HealthScreen(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.bgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.secondaryColor.withOpacity(0.3),
                            width: 1,
                          ),
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
                            Image.asset('assets/img3D/dien_tim.png', width: 40),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sức khỏe",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "theo dõi chỉ số sức khỏe của người già",
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
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeMedicine(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.bgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.secondaryColor.withOpacity(0.3),
                            width: 1,
                          ),
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
                            Image.asset('assets/img3D/thuoc.png', width: 40),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Lịch uống thuốc",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "theo dõi thời gian uống thuốc của người già",
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
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
