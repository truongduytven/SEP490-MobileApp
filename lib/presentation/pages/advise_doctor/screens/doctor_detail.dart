import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:intl/intl.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/controllers/doctor_controller.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/checkout.dart';
import 'package:sep490/presentation/pages/navigation_menu.dart';
import 'package:sep490/presentation/widgets/appointment/_infoChip.dart';
import 'package:sep490/presentation/widgets/auth_field.dart';
import 'package:sep490/theme/color.dart';

class DoctorDetail extends StatefulWidget {
  final int doctorId;
  final int? accountId;
  final bool isChoosePackage;
  final ComboData? comboData;
  const DoctorDetail(
      {super.key,
      required this.doctorId,
      this.accountId,
      required this.isChoosePackage,
      this.comboData});

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
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int selectedElderlyUserId;
  late int accountId = sharedPrefsHelper.getInt('accountId') ?? 0;
  List<FeedBackDoctor>? feedbackDoctor = [];
  Map<String, dynamic> selectedTimeSlot = {
    'startTime': '',
    'endTime': '',
    'day': '',
  };
  final TextEditingController moreInformationController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedElderlyUserId =
        sharedPrefsHelper.getInt('selectedElderlyUserId') ?? 0;
    tabBarController =
        TabController(length: widget.isChoosePackage ? 3 : 2, vsync: this);
    if (widget.isChoosePackage) {
      tabBarController.addListener(() {
        if (tabBarController.index == 0) {
          getSchedule();
          setState(() {
            selectedTimeSlot = {
              'startTime': '',
              'endTime': '',
              'day': '',
            };
          });
          _scrollToSelectedDay();
        }
      });
    }
    getDoctorDetails();
    getSchedule();
    getRating();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
    });
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
    moreInformationController.dispose();
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
      if (!mounted) return;
      setState(() {
        if (doctorController.listAppoimentDoctor != null) {
          listTimeSlot = [];
          doctorController.listAppoimentDoctor!.map((item) {
            bool isToday = selectedYear == DateTime.now().year &&
                selectedMonth == DateTime.now().month &&
                selectedDay == DateTime.now().day;
            if (isToday) {
              // Parse the start time (e.g., "08:00" -> 8:00 AM)
              final startTimeParts = item.startTime.split(':');
              final startHour = int.parse(startTimeParts[0]);
              final startMinute = int.parse(startTimeParts[1]);

              // Get current time
              final now = DateTime.now();
              final currentHour = now.hour;

              int minAllowedHour = currentHour + 2;
              // Check if the time slot is in the future
              if (startHour > currentHour ||
                  (startHour == minAllowedHour && startMinute >= 0)) {
                listTimeSlot!.add(
                  TimeSlots(
                    startTime: item.startTime,
                    endTime: item.endTime,
                  ),
                );
              }
            } else {
              // If not today, add all time slots
              listTimeSlot!.add(
                TimeSlots(
                  startTime: item.startTime,
                  endTime: item.endTime,
                ),
              );
            }
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
      if (!mounted) return;
      setState(() {
        doctorData = doctorController.doctorData;
        isLoading = false;
      });
    });
  }

  void getRating() async {
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.getFeedbackDoctor(widget.accountId ?? 0);
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        feedbackDoctor = doctorController.feedbackDoctor;
        isLoading = false;
      });
    });
  }

  void handleBookingDoctor() async {
    if (moreInformationController.text.isEmpty) {
      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Vui lòng nhập thông tin thêm!!",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ).show(context);
      return;
    }
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.getOneTimeSubscription(
        selectedElderlyUserId != 0 ? selectedElderlyUserId : accountId);
    if (doctorController.isCheckSuccess) {
      await doctorController.bookingAppointment(
          selectedElderlyUserId != 0 ? selectedElderlyUserId : accountId,
          doctorData!.accountId,
          selectedTimeSlot['startTime'],
          selectedTimeSlot['endTime'],
          selectedTimeSlot['day'],
          moreInformationController.text.trim());
      if (doctorController.isBookingAppointmentSuccess) {
        CherryToast.success(
          toastDuration: Duration(seconds: 2),
          title: Text(
            "Đặt lịch tư vấn thành công!!",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NavigationMenu(keyIndex: 3)));
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 2),
          title: Text(
            doctorController.errorMessage,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Checkout(
                    comboData: widget.comboData!,
                    doctorData: doctorData,
                    timeSlots: selectedTimeSlot,
                    description: moreInformationController.text.trim(),
                  ))).then((value) {
        if (value != null && value) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  void handleSelectedDoctor() async {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Thông báo chọn bác sĩ'),
            content: const Text(
                'Bạn có chắc chắn chọn bác sĩ này để tư vấn và theo dõi sức khỏe cho người già không?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () async {
                  // Handle the action when the user confirms
                  Navigator.of(context).pop();
                  setState(() {
                    isLoading = true;
                  });
                  DoctorController doctorController = DoctorController();
                  await doctorController.selectDoctor(
                      doctorData!.accountId,
                      selectedElderlyUserId != 0
                          ? selectedElderlyUserId
                          : accountId);
                  Timer(Duration(seconds: 2), () {
                    if (doctorController.isSelectDoctorSuccess) {
                      CherryToast.success(
                        toastDuration: Duration(seconds: 3),
                        title: Text(
                          "Chọn bác sĩ thành công!!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ).show(context);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    } else {
                      CherryToast.error(
                        toastDuration: Duration(seconds: 3),
                        title: Text(
                          "Chọn bác sĩ thất bại!!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ).show(context);
                      setState(() {
                        isLoading = false;
                      });
                    }
                  });
                },
                child: const Text('Đồng ý'),
              ),
            ],
          );
        });
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 300,
            width: 300,
            child: Center(
              child: const CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
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
                      tabs: widget.isChoosePackage
                          ? [
                              Tab(text: 'Giờ tư vấn'),
                              Tab(text: 'Thông tin'),
                              Tab(text: 'Đánh giá'),
                            ]
                          : [
                              Tab(text: 'Thông tin'),
                              Tab(text: 'Đánh giá'),
                            ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child:
                          TabBarView(controller: tabBarController, children: [
                        if (widget.isChoosePackage) buildScheduleTab(),
                        buildInfoTab(),
                        buildRatingTab(),
                      ]),
                    ),
                    const SizedBox(height: 12),
                    if (!widget.isChoosePackage)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        width: double.infinity,
                        color: Colors.transparent,
                        child: ElevatedButton.icon(
                          onPressed: handleSelectedDoctor,
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
                    if (widget.isChoosePackage)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        width: double.infinity,
                        color: Colors.transparent,
                        child: ElevatedButton.icon(
                          onPressed: handleBookingDoctor,
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
                          label: const Text('Đặt lịch tư vấn',
                              style: TextStyle(
                                fontSize: 25,
                                color: AppColors.bgColor,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      ),
                  ],
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            .where((month) =>
                                selectedYear > DateTime.now().year ||
                                (selectedYear == DateTime.now().year &&
                                    month >= DateTime.now().month))
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
                          if (selectedMonth == value) return;
                          var now = DateTime.now();
                          setState(() {
                            selectedMonth = value!;
                            selectedDay = value == now.month ? now.day : 1;
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
                          2030 - 2025 + 1,
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
                          if (selectedYear == value) return;
                          var now = DateTime.now();
                          setState(() {
                            selectedYear = value!;
                            selectedMonth = value == now.year ? now.month : 1;
                            selectedDay = value == now.year
                                ? now.month == selectedMonth
                                    ? now.day
                                    : 1
                                : 1;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _scrollToSelectedDay(); // Scroll to day 1
                            });
                            getSchedule();
                          });
                        },
                      ),
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
                  DateTime currentDate =
                      DateTime(selectedYear, selectedMonth, day);
                  bool isPast = currentDate.isBefore(
                    DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day),
                  );
                  return GestureDetector(
                    onTap: () {
                      isPast
                          ? null
                          : setState(() {
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
                            : isPast
                                ? AppColors.grayColor1
                                : AppColors.bgColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.secondaryColor
                              : isPast
                                  ? AppColors.grayColor1
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
                                spacing: 5,
                                children: List.generate(listTimeSlot!.length,
                                    (index) {
                                  TimeSlots timeSlot = listTimeSlot![index];
                                  bool isSelected = selectedTimeSlot[
                                              'startTime'] ==
                                          timeSlot.startTime &&
                                      selectedTimeSlot['endTime'] ==
                                          timeSlot.endTime &&
                                      selectedTimeSlot['day'] ==
                                          '${selectedYear.toString()}-${selectedMonth.toString().padLeft(2, '0')}-${selectedDay.toString().padLeft(2, '0')}';

                                  return GestureDetector(
                                    onTap: () {
                                      if (widget.isChoosePackage) {
                                        setState(() {
                                          selectedTimeSlot = {
                                            'startTime': timeSlot.startTime,
                                            'endTime': timeSlot.endTime,
                                            'day':
                                                '${selectedYear.toString()}-${selectedMonth.toString().padLeft(2, '0')}-${selectedDay.toString().padLeft(2, '0')}',
                                          };
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.28,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primaryColor
                                            : AppColors.bgColor,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primaryColor
                                              : AppColors.secondaryColor
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
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 20),
                              if (widget.isChoosePackage)
                                Text(
                                  'Thông tin thêm',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondaryColor),
                                ),
                              if (widget.isChoosePackage)
                                const SizedBox(height: 10),
                              if (widget.isChoosePackage)
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: AuthField(
                                        hintText: 'Nhập thông tin thêm',
                                        labelText: "",
                                        maxLines: 3,
                                        controller: moreInformationController)),
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
                  _buildSection(
                      "Thời gian tư vấn", ["07:00 - 19:00 hằng ngày"]),
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

  Widget buildRatingTab() {
    if (feedbackDoctor!.isEmpty) {
      return const Center(
        child: Text(
          'Không có đánh giá',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    final averageRating = feedbackDoctor!
            .map((feedback) => feedback.star)
            .reduce((a, b) => a + b) /
        feedbackDoctor!.length;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // Rating summary section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Text(
                      'Điểm trung bình',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      feedbackDoctor!.length.toString(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Text(
                      'Lượt đánh giá',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Star distribution (optional)
          // You can add a star distribution chart here if needed

          const SizedBox(height: 16),

          // Feedback list
          Expanded(
            child: ListView.builder(
              itemCount: feedbackDoctor!.length,
              itemBuilder: (context, index) {
                final feedback = feedbackDoctor![index];
                return buildRatingCard(feedback);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRatingCard(FeedBackDoctor feedback) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  feedback.createdBy == '' ? 'Người dùng' : feedback.createdBy,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      feedback.star.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              feedback.content,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
