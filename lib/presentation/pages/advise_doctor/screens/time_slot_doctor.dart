import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:intl/intl.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/controllers/doctor_controller.dart';
import 'package:sep490/presentation/widgets/auth_field.dart';
import 'package:sep490/theme/color.dart';

class TimeSlotDoctor extends StatefulWidget {
  const TimeSlotDoctor({super.key});

  @override
  State<TimeSlotDoctor> createState() => _TimeSlotDoctorState();
}

class _TimeSlotDoctorState extends State<TimeSlotDoctor> {
  // ignore: avoid_init_to_null
  late DoctorData? doctorData = null;
  bool isLoading = false;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;
  final ScrollController _scrollControllerDay = ScrollController();
  bool isLoadingTimeSlot = false;
  Map<String, dynamic> selectedTimeSlot = {
    'timeSlotId': 0,
    'startTime': '',
    'endTime': '',
  };
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int accountId = 0;
  late int selectedElderlyUserId = 0;

  final TextEditingController moreInformationController =
      TextEditingController();
  late List<TimeSlots>? listTimeSlot = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
    });
    accountId = sharedPrefsHelper.getInt('accountId') ?? 0;
    selectedElderlyUserId =
        sharedPrefsHelper.getInt('selectedElderlyUserId') ?? 0;
    getDoctor();
  }

  void getDoctor() async {
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.getDoctorData(
        selectedElderlyUserId == 0 ? accountId : selectedElderlyUserId);
    Timer(const Duration(seconds: 2), () {
      if(!mounted) return;
      setState(() {
        doctorData = doctorController.doctorData;
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToSelectedDay();
        });
      });
      if (doctorController.doctorData != null) {
        getSchedule();
      }
    });
  }

  void handlebooking() async {
    if (moreInformationController.text.isEmpty) {
      CherryToast.error(
        toastDuration: Duration(seconds: 3),
        title: Text(
          "Bạn nên ghi chú thêm thông tin trước khi đặt lịch để bác sĩ tư vấn dễ dàng tiếp cận hơn",
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
    await doctorController.bookingAppointment(
        selectedElderlyUserId,
        selectedTimeSlot['timeSlotId'],
        DateFormat('yyyy-MM-dd')
            .format(DateTime(selectedYear, selectedMonth, selectedDay)),
        moreInformationController.text);
    Timer(const Duration(seconds: 2), () {
      if (doctorController.isBookingAppointmentSuccess) {
        CherryToast.success(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Đặt lịch thành công",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        Navigator.pop(context);
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Đặt lịch thất bại, vui lòng thử lại sau",
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
  }

  @override
  void dispose() {
    moreInformationController.dispose();
    _scrollControllerDay.dispose();
    super.dispose();
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

  void getSchedule() async {
    setState(() {
      isLoadingTimeSlot = true;
    });
    DoctorController doctorController = DoctorController();
    String date = DateFormat('yyyy-MM-dd')
        .format(DateTime(selectedYear, selectedMonth, selectedDay));
    await doctorController.getTimeSlot(doctorData!.professorId, date);
    Timer(const Duration(seconds: 2), () {
      setState(() {
        listTimeSlot = [];

        if (doctorController.listAppoimentDoctor != null) {
          final now = DateTime.now();
          final currentDate = DateTime(now.year, now.month, now.day);
          final selectedDate =
              DateTime(selectedYear, selectedMonth, selectedDay);
          final oneHourLater = now.add(const Duration(hours: 1));

          doctorController.listAppoimentDoctor!.forEach((item) {
            // Parse the start time into a DateTime on the selected day
            final parts = item.startTime.split(":");
            final startDateTime = DateTime(
              selectedYear,
              selectedMonth,
              selectedDay,
              int.parse(parts[0]),
              int.parse(parts[1]),
            );

            // Only include slots that are:
            // - Today and start time at least 1 hour from now
            // - Or any future day
            if (selectedDate.isAfter(currentDate) ||
                (selectedDate.isAtSameMomentAs(currentDate) &&
                    startDateTime.isAfter(oneHourLater))) {
              listTimeSlot!.add(
                TimeSlots(
                  timeSlotId: item.timeSlotId,
                  startTime: item.startTime,
                  endTime: item.endTime,
                ),
              );
            }
          });
        }

        isLoadingTimeSlot = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Lịch bác sĩ',
            style: TextStyle(
                color: AppColors.secondaryColor,
                fontSize: 25,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.bgColor,
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
                Expanded(
                  child: SingleChildScrollView(
                      child: doctorData != null
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Image.network(
                                                  doctorData!.avatar,
                                                  width: 70,
                                                  height: 70,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      doctorData!.fullName,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .primaryColor),
                                                    ),
                                                    Text(
                                                      doctorData!.clinicAddress,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: AppColors
                                                            .grayColor3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color: AppColors.grayColor1,
                                              width: 1,
                                            )),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<int>(
                                            value: selectedMonth,
                                            items: List.generate(
                                              12,
                                              (index) => index + 1,
                                            )
                                                .where((month) =>
                                                    selectedYear >
                                                        DateTime.now().year ||
                                                    (selectedYear ==
                                                            DateTime.now()
                                                                .year &&
                                                        month >=
                                                            DateTime.now()
                                                                .month))
                                                .map((month) {
                                              return DropdownMenuItem<int>(
                                                value: month,
                                                child: Text('Tháng $month',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: selectedMonth ==
                                                                month
                                                            ? AppColors
                                                                .primaryColor
                                                            : AppColors
                                                                .textColor)),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              if (selectedMonth == value)
                                                return;
                                              setState(() {
                                                selectedMonth = value!;
                                                selectedDay = 1;
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
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
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color: AppColors.grayColor1,
                                              width: 1,
                                            )),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<int>(
                                            value: selectedYear,
                                            items: List.generate(
                                              2030 - DateTime.now().year + 1,
                                              (index) =>
                                                  DateTime.now().year + index,
                                            ).map((year) {
                                              return DropdownMenuItem<int>(
                                                value: year,
                                                child: Text('Năm $year',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: selectedYear ==
                                                                year
                                                            ? AppColors
                                                                .primaryColor
                                                            : AppColors
                                                                .textColor)),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              if (selectedYear == value) return;
                                              setState(() {
                                                selectedYear = value!;
                                                selectedDay = 1;
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  _scrollToSelectedDay(); // Scroll to day 1
                                                });
                                                getSchedule();
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //   decoration: BoxDecoration(),
                                      //   width: 100,
                                      //   child: ElevatedButton(
                                      //     onPressed: (selectedDay !=
                                      //                 DateTime.now().day ||
                                      //             selectedMonth !=
                                      //                 DateTime.now().month ||
                                      //             selectedYear !=
                                      //                 DateTime.now().year)
                                      //         ? () {
                                      //             setState(() {
                                      //               selectedDay =
                                      //                   DateTime.now().day;
                                      //               selectedMonth =
                                      //                   DateTime.now().month;
                                      //               selectedYear =
                                      //                   DateTime.now().year;
                                      //               WidgetsBinding.instance
                                      //                   .addPostFrameCallback(
                                      //                       (_) {
                                      //                 _scrollToSelectedDay();
                                      //               });
                                      //               getSchedule();
                                      //             });
                                      //           }
                                      //         : null,
                                      //     style: ElevatedButton.styleFrom(
                                      //         backgroundColor:
                                      //             AppColors.secondaryColor,
                                      //         padding: EdgeInsets.symmetric(
                                      //             horizontal: 10, vertical: 5),
                                      //         shape: RoundedRectangleBorder(
                                      //           borderRadius:
                                      //               BorderRadius.circular(15),
                                      //         )),
                                      //     child: const Text('Hôm nay',
                                      //         style: TextStyle(
                                      //           fontSize: 20,
                                      //           color: AppColors.bgColor,
                                      //           fontWeight: FontWeight.w400,
                                      //         )),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: _scrollControllerDay,
                                  child: Row(
                                    children:
                                        List.generate(daysInMonth, (index) {
                                      int day = index + 1;
                                      DateTime today = DateTime.now();
                                      bool isSelected = day == selectedDay;
                                      DateTime currentDate = DateTime(
                                          selectedYear, selectedMonth, day);
                                      bool isPast = currentDate.isBefore(
                                        DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day),
                                      );

                                      return GestureDetector(
                                        onTap: isPast
                                            ? null
                                            : () {
                                                setState(() {
                                                  selectedDay = day;
                                                  getSchedule();
                                                });
                                              },
                                        child: Container(
                                          width: 60,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.secondaryColor
                                                : isPast
                                                    ? AppColors.grayColor1
                                                    : AppColors.bgColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppColors.secondaryColor
                                                  : isPast
                                                      ? AppColors.grayColor1
                                                      : AppColors.secondaryColor
                                                          .withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 15),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          '$day',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: isSelected
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                                  'EEE', 'vi')
                                                              .format(DateTime(
                                                                  selectedYear,
                                                                  selectedMonth,
                                                                  day)),
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: isSelected
                                                                ? Colors.white
                                                                : AppColors
                                                                    .secondaryColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (selectedMonth ==
                                                      today.month &&
                                                  selectedYear == today.year &&
                                                  day == today.day)
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.blue,
                                                      shape: BoxShape.circle,
                                                    ),
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
                                    : listTimeSlot!.isNotEmpty
                                        ? Column(
                                            children: [
                                              SizedBox(height: 10),
                                              Wrap(
                                                runSpacing: 15,
                                                children: List.generate(
                                                    listTimeSlot!.length,
                                                    (index) {
                                                  TimeSlots timeSlot =
                                                      listTimeSlot![index];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      if (selectedTimeSlot[
                                                              'timeSlotId'] ==
                                                          timeSlot.timeSlotId) {
                                                        setState(() {
                                                          selectedTimeSlot = {
                                                            'timeSlotId': 0,
                                                            'startTime': '',
                                                            'endTime': '',
                                                          };
                                                        });
                                                      } else {
                                                        setState(() {
                                                          selectedTimeSlot[
                                                                  'timeSlotId'] =
                                                              timeSlot
                                                                  .timeSlotId;
                                                          selectedTimeSlot[
                                                                  'startTime'] =
                                                              timeSlot
                                                                  .startTime;
                                                          selectedTimeSlot[
                                                                  'endTime'] =
                                                              timeSlot.endTime;
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12),
                                                      decoration: BoxDecoration(
                                                        color: selectedTimeSlot[
                                                                    'timeSlotId'] ==
                                                                timeSlot
                                                                    .timeSlotId
                                                            ? AppColors
                                                                .primaryColor
                                                            : AppColors.bgColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        border: Border.all(
                                                          color: selectedTimeSlot[
                                                                      'timeSlotId'] ==
                                                                  timeSlot
                                                                      .timeSlotId
                                                              ? AppColors
                                                                  .primaryColor
                                                              : AppColors
                                                                  .secondaryColor
                                                                  .withOpacity(
                                                                      0.3),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            '${timeSlot.startTime} - ${timeSlot.endTime}',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: selectedTimeSlot[
                                                                          'timeSlotId'] ==
                                                                      timeSlot
                                                                          .timeSlotId
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 20),
                                              Image.asset(
                                                  'assets/img/no-data.png',
                                                  width: 60,
                                                  height: 60),
                                              SizedBox(height: 10),
                                              Text('Không có giờ khả dụng',
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                            ],
                                          ),
                                SizedBox(height: 10),
                                Text('Thông tin thêm',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondaryColor)),
                                SizedBox(height: 10),
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
                          : SizedBox(
                              height: MediaQuery.of(context).size.height - 200,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 20),
                                      Image.asset('assets/img/no-data.png',
                                          width: 60, height: 60),
                                      SizedBox(height: 10),
                                      Text(
                                          'Vui lòng chọn bác sĩ trước khi đặt lịch',
                                          style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                ),
                if (doctorData != null &&
                    listTimeSlot!.isNotEmpty &&
                    selectedTimeSlot['startTime'] != '' &&
                    selectedTimeSlot['endTime'] != '')
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    width: double.infinity,
                    color: Colors.transparent,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        handlebooking();
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
                      icon: Icon(Icons.add_circle_outline,
                          size: 25, color: AppColors.bgColor),
                      label: const Text('Đặt lịch',
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
}
