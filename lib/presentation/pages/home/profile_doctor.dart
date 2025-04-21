import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/controllers/doctor_controller.dart';
import 'package:sep490/presentation/widgets/appointment/_infoChip.dart';
import 'package:sep490/theme/color.dart';

class ProfileDoctor extends StatefulWidget {
  const ProfileDoctor({super.key});

  @override
  State<ProfileDoctor> createState() => _ProfileDoctorState();
}

class _ProfileDoctorState extends State<ProfileDoctor> {
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int accountId = sharedPrefsHelper.getInt('accountId') ?? 0;
  bool isLoading = false;
  DoctorData? doctorData;

  @override
  void initState() {
    super.initState();
    getDoctorDetails();
  }

  void getDoctorDetails() async {
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.getDoctorDetailsByAccountId(accountId);
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        doctorData = doctorController.doctorData;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Hồ sơ bác sĩ",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 25)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(
              child: GifView.asset(
                'assets/gif/sos_loading.gif',
                width: 100,
                height: 100,
                frameRate: 60,
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: AppColors.grayColor2)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              doctorData!.avatar,
                              width: 100,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "BS. ${doctorData!.fullName}",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor),
                                ),
                                Text(
                                  doctorData!.clinicAddress,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.grayColor3,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(spacing: 8, runSpacing: 8, children: [
                                  InfoChip(text: "⭐ ${doctorData!.rating}"),
                                  InfoChip(
                                      text:
                                          "Kinh nghiệm: ${doctorData!.experienceYears} năm"),
                                  InfoChip(
                                      text:
                                          "Lĩnh vực: ${doctorData!.specialization[0]}"),
                                ])
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSection(
                                    "Học vấn", doctorData!.qualification),
                                _buildSection("Sự nghiệp", doctorData!.career),
                                _buildSection(
                                    "Thành tựu", doctorData!.achievement),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
    );
  }

  Widget _buildSection(String title, List<dynamic> content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        ...content.map((item) => Text(
              '• ${item.toString()}',
              style: TextStyle(fontSize: 20),
            )),
        const SizedBox(height: 12),
      ],
    );
  }
}
