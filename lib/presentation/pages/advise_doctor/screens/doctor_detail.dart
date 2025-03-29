import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:intl/intl.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/controllers/doctor_controller.dart';
import 'package:sep490/presentation/widgets/appointment/_infoChip.dart';
import 'package:sep490/theme/color.dart';

class DoctorDetail extends StatefulWidget {
  final int doctorId;
  const DoctorDetail({super.key, required this.doctorId});

  @override
  State<DoctorDetail> createState() => _DoctorDetailState();
}

class _DoctorDetailState extends State<DoctorDetail>
    with TickerProviderStateMixin {
  bool isLoading = true;
  DoctorData? doctorData;
  late TabController tabBarController;
  bool isLoadingTimeSlot = false;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;
  late List<TimeSlots>? listTimeSlot = [];
  final ScrollController _scrollControllerDay = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
    });
    tabBarController = TabController(length: 3, vsync: this);
    tabBarController.addListener(() {
      if(tabBarController.index == 1) {
        getSchedule();
        _scrollToSelectedDay();
      }
    });
    getDoctorDetails();
    getSchedule();
  }

  void _scrollToSelectedDay() {
    if (_scrollControllerDay.hasClients) {
      double scrollPosition = (selectedDay - 1) * 76;
      _scrollControllerDay.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollControllerDay.dispose();
    super.dispose();
  }

  void getSchedule() async {
    setState(() {
      isLoadingTimeSlot = true;
    });
    DoctorController doctorController = DoctorController();
    String date = DateFormat('yyyy-MM-dd')
        .format(DateTime(selectedYear, selectedMonth, selectedDay));
    await doctorController.getTimeSlot(widget.doctorId, date);
    Timer(const Duration(seconds: 2), () {
      setState(() {
        if (doctorController.listAppoimentDoctor != null) {
          listTimeSlot = [];
          doctorController.listAppoimentDoctor!.map((item) {
            listTimeSlot!.add(
              TimeSlots(
                startTime: item.startTime,
                endTime: item.endTime,
              ),
            );
          }).toList();
        }
        isLoadingTimeSlot = false;
      });
    });
  }

  void getDoctorDetails() async {
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.getDoctorDetails(widget.doctorId);
    Timer(const Duration(seconds: 1), () {
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
        title: Text('Thông tin chi tiết',
            style: const TextStyle(
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 25)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
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
          : doctorData == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/img/no-data.png',
                        width: 100, height: 100),
                    SizedBox(height: 10),
                    Text('Không có dữ liệu', style: TextStyle(fontSize: 20)),
                  ],
                )
              : Expanded(
                  child: Column(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            InfoChip(
                                                text:
                                                    "⭐ ${doctorData!.rating}"),
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
                      TabBar(
                        controller: tabBarController,
                        indicatorColor: AppColors.primaryColor,
                        indicatorWeight: 4,
                        labelColor: AppColors.primaryColor,
                        unselectedLabelColor: AppColors.secondaryColor,
                        labelStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: [
                          Tab(text: 'Thông tin'),
                          Tab(text: 'Giờ tư vấn'),
                          Tab(text: 'Đánh giá'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child:
                            TabBarView(controller: tabBarController, children: [
                          buildInfoTab(),
                          buildScheduleTab(),
                          const Text("Lời mời kết bạn"),
                        ]),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        width: double.infinity,
                        color: Colors.transparent,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondaryColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(
                                    color: AppColors.secondaryColor, width: 1),
                              )),
                          icon: Icon(Icons.add_circle_outline,
                              size: 25, color: AppColors.bgColor),
                          label: const Text('Chọn bác sĩ',
                              style: TextStyle(
                                fontSize: 25,
                                color: AppColors.bgColor,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget buildInfoTab() {
    return SingleChildScrollView(
      child:
          Padding(padding: const EdgeInsets.all(12.0), child: _buildInfoCard()),
    );
  }

  Widget buildScheduleTab() {
    int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: AppColors.grayColor1,
                          width: 1,
                        )),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedMonth,
                        items: List.generate(12, (index) => index + 1)
                            .map((month) {
                          return DropdownMenuItem<int>(
                            value: month,
                            child: Text('Tháng $month',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: selectedMonth == month
                                        ? AppColors.primaryColor
                                        : AppColors.textColor)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMonth = value!;
                            selectedDay = 1;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _scrollToSelectedDay();
                            });
                            getSchedule();
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: AppColors.grayColor1,
                          width: 1,
                        )),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedYear,
                        items: List.generate(
                          2050 - 2025 + 1,
                          (index) => 2025 + index,
                        ).map((year) {
                          return DropdownMenuItem<int>(
                            value: year,
                            child: Text('Năm $year',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: selectedYear == year
                                        ? AppColors.primaryColor
                                        : AppColors.textColor)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value!;
                            selectedDay = 1;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _scrollToSelectedDay(); // Scroll to day 1
                            });
                            getSchedule();
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    width: 100,
                    child: ElevatedButton(
                      onPressed: (selectedDay != DateTime.now().day ||
                              selectedMonth != DateTime.now().month ||
                              selectedYear != DateTime.now().year)
                          ? () {
                              setState(() {
                                selectedDay = DateTime.now().day;
                                selectedMonth = DateTime.now().month;
                                selectedYear = DateTime.now().year;
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _scrollToSelectedDay();
                                });
                                getSchedule();
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      child: const Text('Hôm nay',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.bgColor,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollControllerDay,
              child: Row(
                children: List.generate(daysInMonth, (index) {
                  int day = index + 1;
                  bool isSelected = day == selectedDay;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDay = day;
                        getSchedule();
                      });
                    },
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.secondaryColor
                            : AppColors.bgColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.secondaryColor
                              : AppColors.secondaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$day',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            DateFormat('EEE', 'vi').format(
                                DateTime(selectedYear, selectedMonth, day)),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            Text('Giờ khả dụng',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor)),
            isLoadingTimeSlot
                ? SizedBox(
                    height: 100,
                    child: Center(
                      child: GifView.asset(
                        'assets/gif/sos_loading.gif',
                        width: 70,
                        height: 70,
                        frameRate: 60,
                      ),
                    ),
                  )
                : listTimeSlot != null
                    ? listTimeSlot!.isNotEmpty
                        ? Column(
                            children: [
                              SizedBox(height: 10),
                              Wrap(
                                runSpacing: 15,
                                children: List.generate(listTimeSlot!.length,
                                    (index) {
                                  TimeSlots timeSlot = listTimeSlot![index];
                                  return GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.bgColor,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: AppColors.secondaryColor
                                              .withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            '${timeSlot.startTime} - ${timeSlot.endTime}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 20),
                              Image.asset('assets/img/no-data.png',
                                  width: 60, height: 60),
                              SizedBox(height: 10),
                              Text('Không có giờ khả dụng',
                                  style: TextStyle(fontSize: 18)),
                            ],
                          )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Image.asset('assets/img/no-data.png',
                              width: 60, height: 60),
                          SizedBox(height: 10),
                          Text('Không có giờ khả dụng',
                              style: TextStyle(fontSize: 18)),
                        ],
                      ),
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
