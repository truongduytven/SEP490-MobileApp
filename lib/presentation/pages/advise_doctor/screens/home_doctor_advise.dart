import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/controllers/doctor_controller.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/report_appointment.dart';
import 'package:sep490/presentation/widgets/appointment/_infoChip.dart';
import 'package:sep490/presentation/widgets/appointment/buildAppointmentCard.dart';
import 'package:sep490/theme/color.dart';

class HomeDoctorAdviseScreen extends StatefulWidget {
  const HomeDoctorAdviseScreen({super.key});

  @override
  State<HomeDoctorAdviseScreen> createState() => _HomeDoctorAdviseScreenState();
}

class _HomeDoctorAdviseScreenState extends State<HomeDoctorAdviseScreen>
    with SingleTickerProviderStateMixin {
  final List<String> tabs = ['Lịch hẹn', 'Cảnh báo', 'Bác sĩ'];
  late TabController _tabController;
  bool isLoading = false;
  late DoctorData? doctorData;
  late List<AppoimentDoctor>? appoimentDoctor;

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
    getDoctorData();
  }

  void getDoctorData() async {
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.getDoctorData(49);
    await doctorController.getAppointmentByID(49, 'NotYet');
    Timer(const Duration(seconds: 2), () {
      setState(() {
        doctorData = doctorController.doctorData;
        appoimentDoctor = doctorController.appoimentDoctor;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text('Lịch hẹn với bác sĩ',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25)),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/background_app.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: TabBar(
                  dividerHeight: 0,
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColors.secondaryColor,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.white,
                  labelStyle: const TextStyle(fontSize: 18),
                  tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTabContent(1),
                    _buildTabContent(2),
                    _buildTabContent(3),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        shape: CircleBorder(),
        backgroundColor: AppColors.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTabContent(int index) {
    Widget checkTab() {
      switch (index) {
        case 1:
          return _buildSchdule();
        case 2:
          return _buildWarning();
        case 3:
          return _buildDoctor();
        default:
          return Container();
      }
    }

    return isLoading
        ? Center(
            child: GifView.asset(
              'assets/gif/sos_loading.gif',
              width: 100,
              height: 100,
              frameRate: 60,
            ),
          )
        : checkTab();
  }

  Widget _buildSchdule() {
    // ignore: unnecessary_null_comparison
    return (appoimentDoctor != null && appoimentDoctor!.isNotEmpty)
        ? SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: appoimentDoctor!
                  .map((item) => BuildAppointmentCard(
                        appoimentDoctor: item,
                        onCancel: () => Future.value(),
                        onJoin: () => Future.value(),
                        onReport: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportAppointment(
                                      appoimentDoctor: item,
                                    ))),
                        isListCard: true,
                      ))
                  .toList(),
            ),
          )
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/no-data.png',
                width: 100, height: 100),
            SizedBox(height: 10),
            Text('Không có dữ liệu', style: TextStyle(fontSize: 20)),
          ],
        );
  }

  Widget _buildWarning() {
    return Column(
      children: [
        Text('Cảnh báo'),
      ],
    );
  }

  Widget _buildDoctor() {
    // ignore: unnecessary_null_comparison
    return doctorData != null
        ? SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileCard(),
                const SizedBox(height: 16),
                _buildInfoCard()
              ],
            ),
          )
        : Center(
            child: Text('Không có dữ liệu'),
          );
  }

  Widget _buildProfileCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    doctorData!.avatar,
                    width: 150,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        doctorData!.fullName,
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
                      InfoChip(text: "⭐ ${doctorData!.rating}"),
                      const SizedBox(height: 8),
                      InfoChip(
                          text:
                              "Kinh nghiệm: ${doctorData!.experienceYears} năm"),
                      const SizedBox(height: 8),
                      InfoChip(text: "Lĩnh vực: ${doctorData!.specialization}"),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection("Học vấn", doctorData!.qualification[0]),
                  _buildSection("Sự nghiệp", doctorData!.career[0]),
                  _buildSection("Thành tựu", doctorData!.achievement[0]),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
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
        Text(
          content,
          style: TextStyle(
            fontSize: 18,
            color: AppColors.secondaryColor,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
