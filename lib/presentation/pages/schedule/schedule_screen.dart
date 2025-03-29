import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gif_view/gif_view.dart';
import 'package:intl/intl.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/models/schedule.dart';
import 'package:sep490/presentation/pages/medicine/controller/medicine_controller.dart';
import 'package:sep490/presentation/pages/schedule/Controller/schedule_controller.dart';
import 'package:sep490/presentation/pages/schedule/create_calendar_screen.dart';
import 'package:sep490/presentation/widgets/loading/loadingImgPath.dart';
import 'package:sep490/theme/color.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;
  late Timer _timer;
  late DateTime _currentTime = DateTime.now();
  final ScrollController _scrollControllerDay = ScrollController();
  List<Activity>? schedule;
  bool isLoading = false;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int userId = sharedPrefsHelper.getInt('accountId')!;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
    });
    _currentTime = DateTime.now();
    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
    getSchedule();
  }

  void getSchedule() async {
    setState(() {
      isLoading = true;
    });
    ScheduleController scheduleController = ScheduleController();
    await scheduleController.getSchedule(userId,
        '$selectedYear-${selectedMonth < 10 ? "0$selectedMonth" : selectedMonth}-${selectedDay < 10 ? "0$selectedDay" : selectedDay}');
    Timer(Duration(seconds: 2), () {
      setState(() {
        schedule = scheduleController.schedule;
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _scrollToSelectedDay() {
    double scrollPosition = (selectedDay - 1) * 80;
    _scrollControllerDay.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _getActivityIcon(String activityName) {
    switch (activityName) {
      case "Medication":
        return Image.asset('assets/img3D/thuoc.png', width: 50, height: 50);
      case "Professor Appointment":
        return Image.asset('assets/img3D/bacsi.png', width: 50, height: 50);
      default:
        return Image.asset('assets/img3D/calendar.png', width: 50, height: 50);
    }
  }

  Color? getColors(String activityName) {
    switch (activityName) {
      case "Medication":
        return Colors.yellow[200];
      case "Professor Appointment":
        return Colors.blue[200];
      default:
        return Colors.green[200];
    }
  }

  void _showActivityDialog(BuildContext context, Activity activity) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return ScaleTransition(
          scale: anim1,
          child: Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: getColors(activity.type),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _getActivityIcon(activity.type),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity.title,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textColor),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              activity.description,
                              style: const TextStyle(fontSize: 20),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${activity.startTime} ${activity.endTime.isNotEmpty ? '-' : ''} ${activity.endTime}',
                              style: TextStyle(
                                  fontSize: 20,
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        handleChangeStatusActivity(activity.activityId);
                      },
                      icon: Icon(Icons.delete, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      label: const Text('Dừng',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateCalendarScreen(
                              data: activity,
                              date: "$selectedYear-$selectedMonth-$selectedDay",
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      label: const Text('Cập nhật',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void handleChangeStatusActivity(int activityId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: Text(
              'Bạn có chắc chắn muốn dừng hoạt động này từ ngày $selectedDay/$selectedMonth/$selectedYear không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                LoadingDialog.show(context, 'assets/gif/loading_calendar.gif',
                    'Đang hủy hoạt động...');
                ScheduleController scheduleController = ScheduleController();
                await scheduleController.changeStatusActivity(activityId,
                    "$selectedYear-${selectedMonth < 10 ? "0$selectedMonth" : selectedMonth}-${selectedDay < 10 ? "0$selectedDay" : selectedDay}");
                Timer(const Duration(seconds: 1), () {
                  if (scheduleController.isChangeStatusSuccess) {
                    Navigator.pop(context);
                    LoadingDialog.show(context, 'assets/gif/schedule_success.gif',
                        'Dừng hoạt động thành công!');
                    Timer(const Duration(seconds: 2), () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      setState(() {
                        getSchedule();
                      });
                    });
                  } else {
                    Fluttertoast.showToast(
                      msg: "Có lỗi trong quá trình xử lý!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    Navigator.pop(context);
                  }
                });
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    if (schedule != null) {
      schedule?.sort((a, b) => (a.startTime).compareTo(b.startTime));
    }

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        title: Text(
          'Lịch của tôi',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<int>(
                  value: selectedMonth,
                  items: List.generate(12, (index) => index + 1).map((month) {
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
                DropdownButton<int>(
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
                              WidgetsBinding.instance.addPostFrameCallback((_) {
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
          const SizedBox(height: 30),
          // Horizontal Calendar
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
                    width: 64,
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
                          '$day', // Display day number
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
                            fontSize: 16,
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
          const SizedBox(height: 30),

          isLoading
              ? Expanded(
                  child: Center(
                    child: GifView.asset(
                      'assets/gif/loading_calendar.gif',
                      width: 100,
                      height: 100,
                      frameRate: 90,
                    ),
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                          children: List.generate(24, (index) {
                        DateTime hour = DateTime(
                            selectedYear, selectedMonth, selectedDay, index);
                        bool haveActivity = false;
                        final filteredActivities = schedule?.where((activity) {
                          String startTime = activity.startTime;
                          List<String> startTimeSplit = startTime.split(':');
                          return int.parse(startTimeSplit[0]) == index;
                        }).toList();
                        bool isCurrentHour = _currentTime.hour == index;
                        double percentHeight = _currentTime.minute / 60;
                        double hourBlockHeight = 100;

                        if (filteredActivities == null ||
                            filteredActivities.isEmpty) {
                          haveActivity = false;
                        } else {
                          haveActivity = true;
                          hourBlockHeight = 66 +
                              130 * filteredActivities.length.toDouble() +
                              15 * (filteredActivities.length.toDouble() - 1);
                        }

                        return Stack(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 70, // Adjust width as needed
                                      child: Text(
                                        DateFormat.jm().format(hour),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            10), // Spacing between text and line
                                    CustomPaint(
                                      size: Size(
                                          MediaQuery.of(context).size.width -
                                              120,
                                          1), // Full width, height 1px
                                      painter: DashedLinePainter(),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                if (!haveActivity)
                                  SizedBox(
                                    height: 40,
                                  ),
                                if (haveActivity)
                                  ...List.generate(filteredActivities!.length,
                                      (index) {
                                    final activity = filteredActivities[index];

                                    return GestureDetector(
                                      onLongPress: () {
                                        _showActivityDialog(context, activity);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 16),
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: getColors(activity.type),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.secondaryColor
                                                  .withOpacity(0.3),
                                              blurRadius: 4,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            // Activity Icon
                                            _getActivityIcon(activity.type),
                                            const SizedBox(width: 12),
                                            // Activity Details
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    activity.title,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors
                                                            .textColor),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    activity.description,
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    '${activity.startTime} ${activity.endTime != '' ? '-' : ''} ${activity.endTime}',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .textColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                SizedBox(height: 20),
                              ],
                            ),
                            _buildCurrentTimeIndicator(
                                percentHeight, isCurrentHour, hourBlockHeight)
                          ],
                        );
                      })),
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateCalendarScreen(
                        data: null,
                      )));
          if (result != null) {
            getSchedule();
          }
        },
        backgroundColor: AppColors.primaryColor,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCurrentTimeIndicator(
      double percentHeight, bool isCurrentHour, double hourBlockHeight) {
    if (!isCurrentHour) return SizedBox.shrink();

    return Positioned(
      top: hourBlockHeight *
          percentHeight, // Adjust based on the available height
      left: 0,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 2, // Make the line more visible
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    double dashWidth = 5, dashSpace = 3;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
