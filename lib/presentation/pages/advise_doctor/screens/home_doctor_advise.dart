import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:gif_view/gif_view.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/controllers/doctor_controller.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/doctor_list.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/report_appointment.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/time_slot_doctor.dart';
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
  Map<String, String> statusOptions = {
    "Tất cả": "All",
    "Chưa tham gia": "NotYet",
    "Đã tham gia": "Joined",
    "Đã hủy": "Cancelled",
  };
  String selectedStatus = "All";
  late TabController _tabController;
  bool isLoading = false;
  late DoctorData? doctorData = null;
  late List<AppoimentDoctor>? appoimentDoctor;
  bool isLoadingAppointment = false;
  bool isPackage = false;
  List<String> endowments = [
    'Lựa chọn 1 bác sĩ riêng để hỗ trợ',
    'Tư vấn sức khỏe online hoặc offline',
    'Cảnh bác khi có chỉ số bất thường',
    'Hỗ trợ những trường hợp khẩn cấp',
    'Chỉ từ 199.000đ/tháng',
  ];

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
    getDoctorData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void getDoctorData() async {
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.getDoctorData(49);
    await doctorController.getAppointmentByID(49, selectedStatus);
    Timer(const Duration(seconds: 2), () {
      setState(() {
        doctorData = doctorController.doctorData;
        appoimentDoctor = doctorController.appoimentDoctor;
        isLoading = false;
      });
    });
  }

  void getAppointmentByStatus(String status) async {
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.getAppointmentByID(49, status);
    Timer(const Duration(seconds: 2), () {
      setState(() {
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
        title: isPackage
            ? Text('Lịch hẹn với bác sĩ',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25))
            : Text('Mua gói dịch vụ',
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
        child: isPackage
            ? Padding(
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
              )
            : SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      ImageSlideshow(
                        indicatorColor: AppColors.primaryColor,
                        autoPlayInterval: 3000,
                        isLoop: true,
                        width: double.infinity,
                        height: 300,
                        initialPage: 0,
                        children: [
                          Image.network(
                            'https://images2.thanhnien.vn/528068263637045248/2024/6/3/ho-thanh-hai-1-17174077137402075003096.jpg',
                            fit: BoxFit.cover,
                          ),
                          Image.network(
                            'https://bacsitamly.vn/wp-content/uploads/2022/08/279716900_1891140167753531_2109333273842352027_n-1-640x640.jpg',
                            fit: BoxFit.cover,
                          ),
                          Image.network(
                            'https://is.vnecdn.net/objects/consultants/63869517ab11cbc24e7ad1eaf5df0ba3.png',
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                'Trải nghiệm ngay gói dịch vụ từ đội ngũ bác sĩ của chúng tôi',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor)),
                            SizedBox(height: 20),
                            ...endowments.map((e) => Row(
                                  children: [
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.check,
                                      color: AppColors.primaryColor,
                                      size: 30,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      e,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: AppColors.secondaryColor),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        width: double.infinity,
                        color: Colors.transparent,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => DoctorList()));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondaryColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(
                                    color: AppColors.secondaryColor, width: 1),
                              )),
                          icon: Icon(Icons.payment,
                              size: 25, color: AppColors.bgColor),
                          label: const Text('Mua gói ngay',
                              style: TextStyle(
                                fontSize: 25,
                                color: AppColors.bgColor,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      ),
                    ]),
            ),
      ),
      floatingActionButton: isPackage
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TimeSlotDoctor()));
              },
              shape: CircleBorder(),
              backgroundColor: AppColors.primaryColor,
              child: Icon(Icons.add, color: Colors.white),
            )
          : null,
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

    return checkTab();
  }

  Widget _buildSchdule() {
    // ignore: unnecessary_null_comparison
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(color: AppColors.grayColor1, width: 1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedStatus,
              onChanged: (String? newValue) {
                if (selectedStatus == newValue) return;
                setState(() {
                  selectedStatus = newValue!;
                  getAppointmentByStatus(newValue);
                });
              },
              items:
                  statusOptions.entries.map<DropdownMenuItem<String>>((entry) {
                return DropdownMenuItem<String>(
                  value: entry.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(fontSize: 18),
                      ),
                      if (selectedStatus == entry.value)
                        Icon(
                          Icons.check,
                          color: AppColors.primaryColor,
                          size: 30,
                        ),
                    ],
                  ),
                );
              }).toList(),
              selectedItemBuilder: (context) {
                return statusOptions.entries
                    .map<Widget>((entry) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(entry.key, style: TextStyle(fontSize: 18)),
                          ],
                        ))
                    .toList();
              },
            ),
          ),
        ),
        SizedBox(height: 10),
        (isLoading || isLoadingAppointment)
            ? Expanded(
                child: Center(
                  child: GifView.asset(
                    'assets/gif/sos_loading.gif',
                    width: 100,
                    height: 100,
                    frameRate: 60,
                  ),
                ),
              )
            : (appoimentDoctor != null && appoimentDoctor!.isNotEmpty)
                ? Column(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: appoimentDoctor!
                              .map((item) => BuildAppointmentCard(
                                    appoimentDoctor: item,
                                    onCancel: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ReportAppointment(
                                                  appoimentDoctor: item,
                                                ))),
                                    onJoin: () => Future.value(),
                                    onReport: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ReportAppointment(
                                                  appoimentDoctor: item,
                                                ))),
                                    isListCard: true,
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/img/no-data.png',
                          width: 100, height: 100),
                      SizedBox(height: 10),
                      Text('Không có dữ liệu', style: TextStyle(fontSize: 20)),
                    ],
                  ),
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
                      InfoChip(
                          text: "Lĩnh vực: ${doctorData!.specialization[0]}"),
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
                  _buildSection("Học vấn", doctorData!.qualification),
                  _buildSection("Sự nghiệp", doctorData!.career),
                  _buildSection("Thành tựu", doctorData!.achievement),
                ],
              ),
            ),
          ),
        ),
      ],
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
