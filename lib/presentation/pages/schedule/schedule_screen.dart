import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final ScrollController _scrollControllerDay = ScrollController();
  final ScrollController _scrollControllerActivity = ScrollController();

  // Example data for tasks or appointments
  final List<Map<String, dynamic>> activities = [
    {
      "ActivityName": "Uống thuốc",
      "ActivityDescription": "Penicilin v kali 500mg\nDùng 1 vào 8:00 (sau ăn)",
      "StartTime": DateTime(2025, 2, 16, 9, 0),
      "EndTime": DateTime(2025, 2, 16, 10, 0),
    },
    {
      "ActivityName": "Tư vấn với bác sĩ",
      "ActivityDescription": "Bác sĩ Phan Văn Anh",
      "StartTime": DateTime(2025, 2, 16, 11, 0),
      "EndTime": DateTime(2025, 2, 16, 12, 0),
    },
    {
      "ActivityName": "Tập luyện",
      "ActivityDescription": "Bài tập cổ vai gáy",
      "StartTime": DateTime(2025, 2, 16, 13, 0),
      "EndTime": DateTime(2025, 2, 16, 14, 0),
    },
    {
      "ActivityName": "Sự kiện gia đình",
      "ActivityDescription": "Tiệc tất niên",
      "StartTime": DateTime(2025, 2, 16, 13, 0),
      "EndTime": DateTime(2025, 2, 16, 14, 0),
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToNextActivity();
    });
  }

  void _scrollToNextActivity() {
    final now = DateTime.now();
    for (int i = 0; i < activities.length; i++) {
      if (activities[i]['StartTime'].isAfter(now)) {
        double scrollPosition = i * 150;
        _scrollControllerActivity.animateTo(
          scrollPosition,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        break;
      }
    }
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
      case "Uống thuốc":
        return Image.asset('assets/img3D/thuoc.png', width: 50, height: 50);
      case "Tư vấn với bác sĩ":
        return Image.asset('assets/img3D/bacsi.png', width: 50, height: 50);
      case "Tập luyện":
        return Image.asset('assets/img3D/cannang.png', width: 50, height: 50);
      default:
        return Icon(Icons.event, color: AppColors.secondaryColor, size: 50);
    }
  }

  Color? getColors (String activityName) {
    switch (activityName) {
      case "Uống thuốc":
        return Colors.yellow[400];
      case "Tư vấn với bác sĩ":
        return Colors.blue[400];
      case "Tập luyện":
        return Colors.green[400];
      default:
        return Colors.orange[400];
    }
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    activities.sort((a, b) =>
        (a['StartTime'] as DateTime).compareTo(b['StartTime'] as DateTime));

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
                          style: TextStyle(fontSize: 20, color: selectedMonth == month ? AppColors.primaryColor : AppColors.textColor)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = value!;
                      selectedDay = 1;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToSelectedDay(); 
                      });
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
                          style: TextStyle(fontSize: 20, color: selectedYear == year ? AppColors.primaryColor : AppColors.textColor)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value!;
                      selectedDay = 1;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToSelectedDay(); // Scroll to day 1
                      });
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
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? Colors.transparent
                              : AppColors.secondaryColor.withOpacity(0.3),
                          blurRadius: 1,
                          offset: const Offset(0, 0),
                        )
                      ],
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
          const SizedBox(height: 20),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Builder(builder: (context) {
                final filteredActivities = activities.where((activity) {
                  DateTime startTime = activity['StartTime'];
                  return startTime.year == selectedYear &&
                      startTime.month == selectedMonth &&
                      startTime.day == selectedDay;
                }).toList();

                if(filteredActivities.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Text('Không có hoạt động nào', style: TextStyle(fontSize: 20, color: AppColors.textColor)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollControllerActivity,
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    final startTime =
                        DateFormat('h:mm a').format(activity['StartTime']);
                    final endTime =
                        DateFormat('h:mm a').format(activity['EndTime']);
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Time Column
                        SizedBox(
                          width: 60,
                          child: Column(
                            children: [
                              Text(
                                startTime,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 2,
                                height: 60,
                                color: AppColors.primaryColor,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Activity Card
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: getColors(activity['ActivityName']),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  // color: Colors.black.withOpacity(0.1),
                                  color: AppColors.secondaryColor.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Activity Icon
                                _getActivityIcon(activity['ActivityName']),
                                const SizedBox(width: 12),
                                // Activity Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        activity['ActivityName'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textColor),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        activity['ActivityDescription'],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '$startTime - $endTime',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
