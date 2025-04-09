import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/models/schedule.dart';
import 'package:sep490/presentation/pages/schedule/Controller/schedule_controller.dart';
import 'package:sep490/presentation/widgets/auth_field.dart';
import 'package:sep490/presentation/widgets/loading/loadingImgPath.dart';
import 'package:sep490/theme/color.dart';
import 'package:table_calendar/table_calendar.dart';

class CreateCalendarScreen extends StatefulWidget {
  final Activity? data;
  final List<Map<String, String>>? times;
  final String? date;
  const CreateCalendarScreen({super.key, this.data, this.date, this.times});

  @override
  State<CreateCalendarScreen> createState() => _CreateCalendarScreenState();
}

class _CreateCalendarScreenState extends State<CreateCalendarScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  late DateTime _focusedDay;
  late String _startDate = "";
  late String _endDate = "";
  // ignore: unused_field
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final FocusNode _focusNode = FocusNode();
  late List<Map<String, String>> schedules = [];
  late String scheduleId = "";
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int accountId = 0;
  late String fullName = "";
  late bool isUpdate = false;
  DateTime selectedDate = DateTime.now();
  late int selectedElderlyUserId = 0;
  late String selectedElderlyUserName = "";

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _startDate = widget.date ?? '';
    if (widget.data != null) {
      _endDate = addDaytoDate(widget.date ?? '', widget.data!.duration);
    } else {
      _endDate = widget.date ?? '';
    }
    setState(() {
      accountId = sharedPrefsHelper.getInt('accountId') ?? 0;
      selectedElderlyUserId =
          sharedPrefsHelper.getInt('selectedElderlyUserId') ?? 0;
      selectedElderlyUserName =
          sharedPrefsHelper.getString('selectedElderlyUserName') ?? "";
      isUpdate = widget.data != null ? true : false;
      fullName = sharedPrefsHelper.getString('fullName') ?? "";
      titleController.text = widget.data != null ? widget.data!.title : "";

      descriptionController.text =
          widget.data != null ? widget.data!.description : "";
      // ignore: unnecessary_null_comparison
      if (widget.times != null) {
        schedules = widget.times!;
      } else {
        schedules.add({
          "startTime":
              "${selectedDate.add(const Duration(minutes: 30)).hour < 10 ? "0${selectedDate.add(const Duration(minutes: 30)).hour}" : selectedDate.add(const Duration(minutes: 30)).hour}:${selectedDate.add(const Duration(minutes: 30)).minute < 10 ? "0${selectedDate.add(const Duration(minutes: 30)).minute}" : selectedDate.add(const Duration(minutes: 30)).minute}:00.000",
          "endTime":
              "${selectedDate.add(const Duration(minutes: 90)).hour < 10 ? "0${selectedDate.add(const Duration(minutes: 90)).hour}" : selectedDate.add(const Duration(minutes: 90)).hour}:${selectedDate.add(const Duration(minutes: 90)).minute < 10 ? "0${selectedDate.add(const Duration(minutes: 90)).minute}" : selectedDate.add(const Duration(minutes: 90)).minute}:00.000"
        });
      }
    });
  }

  void _addSchedule() {
    DateTime selectedDate = DateTime.now();
    setState(() {
      schedules.add({
        "startTime":
            "${selectedDate.add(const Duration(minutes: 30)).hour < 10 ? "0${selectedDate.add(const Duration(minutes: 30)).hour}" : selectedDate.add(const Duration(minutes: 30)).hour}:${selectedDate.add(const Duration(minutes: 30)).minute < 10 ? "0${selectedDate.add(const Duration(minutes: 30)).minute}" : selectedDate.add(const Duration(minutes: 30)).minute}:00.000",
        "endTime":
            "${selectedDate.add(const Duration(minutes: 90)).hour < 10 ? "0${selectedDate.add(const Duration(minutes: 90)).hour}" : selectedDate.add(const Duration(minutes: 90)).hour}:${selectedDate.add(const Duration(minutes: 90)).minute < 10 ? "0${selectedDate.add(const Duration(minutes: 90)).minute}" : selectedDate.add(const Duration(minutes: 90)).minute}:00.000"
      });
    });
  }

  void _removeSchedule(int index) {
    setState(() {
      schedules.removeAt(index);
    });
  }

  void _showTimePicker(int index, String key) async {
    List<String> timeSplit = schedules[index][key]!.split(":");
    int hour = int.parse(timeSplit[0]);
    int minute = int.parse(timeSplit[1]);
    FixedExtentScrollController hourController =
        FixedExtentScrollController(initialItem: hour);
    FixedExtentScrollController minuteController =
        FixedExtentScrollController(initialItem: minute);
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              title: const Text("Chọn thời gian"),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Giờ"),
                      SizedBox(
                        height: 200,
                        width: 100,
                        child: CupertinoPicker(
                          scrollController: hourController,
                          itemExtent: 50,
                          looping: true,
                          onSelectedItemChanged: (value) {
                            setState(() {
                              hour = value;
                            });
                          },
                          children: List.generate(24, (index) => index)
                              .map((item) => Center(
                                    child: Text(
                                      item.toString(),
                                      style: TextStyle(
                                        fontSize: hour == item ? 25 : 20,
                                        fontWeight: hour == item
                                            ? FontWeight.bold
                                            : FontWeight.w400,
                                        color: hour == item
                                            ? Colors.black
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        ":",
                        style: TextStyle(fontSize: 25),
                      )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Phút"),
                      SizedBox(
                        height: 200,
                        width: 100,
                        child: CupertinoPicker(
                          scrollController: minuteController,
                          itemExtent: 50,
                          looping: true,
                          onSelectedItemChanged: (value) {
                            setState(() {
                              minute = value;
                            });
                          },
                          children: List.generate(60, (index) => index)
                              .map((item) => Center(
                                    child: Text(
                                      item.toString(),
                                      style: TextStyle(
                                        fontSize: minute == item ? 25 : 20,
                                        fontWeight: minute == item
                                            ? FontWeight.bold
                                            : FontWeight.w400,
                                        color: minute == item
                                            ? Colors.black
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    FocusScope.of(context).unfocus();
                  },
                  child: const Text(
                    "Hủy",
                    style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
                TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          AppColors.secondaryColor),
                    ),
                    onPressed: () {
                      String time =
                          "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00.000";
                      Navigator.pop(context, time);
                      FocusScope.of(context).unfocus();
                    },
                    child: const Text(
                      "Chọn",
                      style: TextStyle(
                          color: AppColors.bgColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    )),
              ],
            );
          },
        );
      },
    );
    if (result != null) {
      setState(() {
        schedules[index][key] = result;
      });
    }
  }

  void handleAddActivity() async {
    if (_formKey.currentState!.validate()) {
      LoadingDialog.show(
          context, 'assets/gif/loading_calendar.gif', "Đang tạo sự kiện...");

      DateTime startDate = DateFormat("dd/MM/yyyy").parse(_startDate);
      DateTime endDate = DateFormat("dd/MM/yyyy").parse(_endDate);
      int duration = endDate.difference(startDate).inDays + 1;

      Map<String, dynamic> data = {
        "accountId":
            selectedElderlyUserId == 0 ? accountId : selectedElderlyUserId,
        "title": titleController.text,
        "description": descriptionController.text,
        "startDate":
            "${_endDate.split('/')[2]}-${_endDate.split('/')[1].padLeft(2, '0')}-${_endDate.split('/')[0].padLeft(2, '0')}",
        "createdBy":
            selectedElderlyUserName == "" ? fullName : selectedElderlyUserName,
        "duration": duration,
        "schedules": schedules
      };
      ScheduleController scheduleController = ScheduleController();
      await scheduleController.createActivity(data);
      Timer(const Duration(seconds: 2), () {
        if (scheduleController.isCreateSuccess) {
          Navigator.pop(context);
          LoadingDialog.show(context, 'assets/gif/schedule_success.gif',
              "Tạo sự kiện thành công!");
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
            Navigator.pop(context, true);
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
    }
  }

  void handleUpdateActivity() async {
    if (_formKey.currentState!.validate()) {
      DateTime startDate = DateFormat("dd/MM/yyyy").parse(_startDate);
      DateTime endDate = DateFormat("dd/MM/yyyy").parse(_endDate);
      int duration = endDate.difference(startDate).inDays + 1;
      LoadingDialog.show(context, 'assets/gif/loading_calendar.gif',
          "Đang cập nhật sự kiện...");
      Map<String, dynamic> data = {
        "activityId": widget.data!.activityId,
        "title": titleController.text,
        "description": descriptionController.text,
        "createdBy": fullName,
        "date":
            "${_startDate.split('/')[2]}-${_startDate.split('/')[1].padLeft(2, '0')}-${_startDate.split('/')[0].padLeft(2, '0')}",
        "duration": duration,
        "schedules": schedules
      };
      ScheduleController scheduleController = ScheduleController();
      await scheduleController.updateActivity(data);
      Timer(const Duration(seconds: 2), () {
        if (scheduleController.isUpdateSuccess) {
          Navigator.pop(context);
          LoadingDialog.show(context, 'assets/gif/schedule_success.gif',
              "Cập nhật sự kiện thành công!");
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
            Navigator.pop(context, true);
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
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isUpdate ? "Chỉnh sửa sự kiện" : 'Tạo sự kiện',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          Image.asset(
            'assets/img3D/calendar_create.webp',
            width: 40,
            height: 40,
          ),
          SizedBox(
            width: 10,
          ),
        ],
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: double.infinity,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20),
                        AuthField(
                            hintText: "Nhập tiêu đề",
                            labelText: "Tiêu đề",
                            controller: titleController),
                        SizedBox(height: 25),
                        AuthField(
                            hintText: "Nhập mô tả",
                            labelText: "Mô tả",
                            controller: descriptionController),
                        SizedBox(height: 25),
                        // AuthField(
                        //     hintText: "Nhập số ngày",
                        //     labelText: "Sự kiện diễn ra trong bao lâu",
                        //     controller: durationController,
                        //     keyboardType: TextInputType.number,
                        //     suffixText: "(ngày)"),
                        // SizedBox(height: 25),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller:
                                    TextEditingController(text: _startDate),
                                textInputAction: TextInputAction.next,
                                readOnly: true,
                                onTap: () async {
                                  // ignore: unused_local_variable
                                  DateTime? pickedDate = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        contentPadding: EdgeInsets.zero,
                                        content: SizedBox(
                                          height: 400,
                                          width: 300,
                                          child: TableCalendar(
                                            locale: 'vi_VN',
                                            firstDay: DateTime.now(),
                                            lastDay: _endDate == _startDate
                                                ? DateTime(2030)
                                                : DateTime.parse(
                                                    "${_endDate.split('/')[2]}-${_endDate.split('/')[1].padLeft(2, '0')}-${_endDate.split('/')[0].padLeft(2, '0')}"),
                                            focusedDay: _focusedDay,
                                            availableCalendarFormats: const {
                                              CalendarFormat.month: 'Month',
                                              CalendarFormat.twoWeeks: 'Year',
                                            },
                                            selectedDayPredicate: (day) {
                                              if (_startDate.isNotEmpty) {
                                                final parsedDate =
                                                    DateTime.parse(
                                                  "${_startDate.split('/')[2]}-${_startDate.split('/')[1].padLeft(2, '0')}-${_startDate.split('/')[0].padLeft(2, '0')}",
                                                );
                                                final isSameDate = day.year ==
                                                        parsedDate.year &&
                                                    day.month ==
                                                        parsedDate.month &&
                                                    day.day == parsedDate.day;
                                                return isSameDate;
                                              }
                                              return false;
                                            },
                                            calendarFormat:
                                                CalendarFormat.month,
                                            headerStyle: HeaderStyle(
                                              formatButtonVisible: false,
                                              titleCentered: true,
                                              leftChevronVisible: true,
                                              rightChevronVisible: true,
                                            ),
                                            availableGestures:
                                                AvailableGestures.all,
                                            calendarStyle: CalendarStyle(
                                              selectedDecoration: BoxDecoration(
                                                color: AppColors.primaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            onDaySelected:
                                                (selectedDay, focusedDay) {
                                              Navigator.pop(context);
                                              // Update the selected date when a day is selected
                                              setState(() {
                                                if (_startDate == _endDate) {
                                                  _endDate =
                                                      "${selectedDay.day}/${selectedDay.month}/${selectedDay.year}";
                                                }
                                                _startDate =
                                                    "${selectedDay.day}/${selectedDay.month}/${selectedDay.year}";
                                                _focusedDay = focusedDay;
                                              });
                                            },
                                            onFormatChanged: (format) {
                                              setState(() {
                                                _calendarFormat = format;
                                              });
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                decoration: InputDecoration(
                                  hintText: "Chọn ngày kết thúc thuốc",
                                  labelText: "Ngày bắt đầu",
                                  labelStyle: TextStyle(
                                      color: AppColors.textColor, fontSize: 20),
                                  hintStyle: TextStyle(
                                      color: AppColors.grayColor3,
                                      fontSize: 20),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: const BorderSide(
                                        color: AppColors.grayColor1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: const BorderSide(
                                        color: AppColors.grayColor1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: const BorderSide(
                                        color: AppColors.secondaryColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng chọn ngày kết thúc sự kiện';
                                  }
                                  return null;
                                },
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            SizedBox(width: 25),
                            Expanded(
                              child: TextFormField(
                                controller:
                                    TextEditingController(text: _endDate),
                                textInputAction: TextInputAction.next,
                                readOnly: true,
                                onTap: () async {
                                  // ignore: unused_local_variable
                                  DateTime? pickedDate = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        contentPadding: EdgeInsets.zero,
                                        content: SizedBox(
                                          height: 400,
                                          width: 300,
                                          child: TableCalendar(
                                            locale: 'vi_VN',
                                            firstDay: DateTime.parse(
                                              "${_startDate.split('/')[2]}-${_startDate.split('/')[1].padLeft(2, '0')}-${_startDate.split('/')[0].padLeft(2, '0')}",
                                            ),
                                            lastDay: DateTime(2030),
                                            focusedDay: _focusedDay,
                                            availableCalendarFormats: const {
                                              CalendarFormat.month: 'Month',
                                              CalendarFormat.twoWeeks: 'Year',
                                            },
                                            selectedDayPredicate: (day) {
                                              if (_endDate.isNotEmpty) {
                                                final parsedDate =
                                                    DateTime.parse(
                                                  "${_endDate.split('/')[2]}-${_endDate.split('/')[1].padLeft(2, '0')}-${_endDate.split('/')[0].padLeft(2, '0')}",
                                                );
                                                final isSameDate = day.year ==
                                                        parsedDate.year &&
                                                    day.month ==
                                                        parsedDate.month &&
                                                    day.day == parsedDate.day;
                                                return isSameDate;
                                              }
                                              return false;
                                            },
                                            calendarFormat:
                                                CalendarFormat.month,
                                            headerStyle: HeaderStyle(
                                              formatButtonVisible: false,
                                              titleCentered: true,
                                              leftChevronVisible: true,
                                              rightChevronVisible: true,
                                            ),
                                            availableGestures:
                                                AvailableGestures.all,
                                            calendarStyle: CalendarStyle(
                                              selectedDecoration: BoxDecoration(
                                                color: AppColors.primaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            onDaySelected:
                                                (selectedDay, focusedDay) {
                                              Navigator.pop(context);
                                              // Update the selected date when a day is selected
                                              setState(() {
                                                _endDate =
                                                    "${selectedDay.day}/${selectedDay.month}/${selectedDay.year}";
                                                _focusedDay = focusedDay;
                                              });
                                            },
                                            onFormatChanged: (format) {
                                              setState(() {
                                                _calendarFormat = format;
                                              });
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                decoration: InputDecoration(
                                  hintText: "Chọn ngày kết thúc thuốc",
                                  labelText: "Ngày kết thúc",
                                  labelStyle: TextStyle(
                                      color: AppColors.textColor, fontSize: 20),
                                  hintStyle: TextStyle(
                                      color: AppColors.grayColor3,
                                      fontSize: 20),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: const BorderSide(
                                        color: AppColors.grayColor1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: const BorderSide(
                                        color: AppColors.grayColor1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: const BorderSide(
                                        color: AppColors.secondaryColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng chọn ngày kết thúc sự kiện';
                                  }
                                  return null;
                                },
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        Center(
                          child: Text('Lịch trình',
                              style: const TextStyle(fontSize: 20)),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: schedules.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Lịch trình ${index + 1}",
                                      style: TextStyle(
                                          color: AppColors.secondaryColor,
                                          fontSize: 18),
                                    ),
                                    GestureDetector(
                                      onTap: () => _removeSchedule(index),
                                      child: const Icon(Icons.delete),
                                    )
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          _showTimePicker(index, "startTime");
                                        },
                                        child: RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              text: "Bắt đầu: ",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: AppColors.secondaryColor,
                                              )),
                                          TextSpan(
                                              text:
                                                  "${schedules[index]['startTime']!.split(":")[0]}:${schedules[index]['startTime']!.split(":")[1]}",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      AppColors.secondaryColor,
                                                  fontWeight: FontWeight.w600)),
                                        ])),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          _showTimePicker(index, "endTime");
                                        },
                                        child: RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              text: "Kết thúc: ",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: AppColors.secondaryColor,
                                              )),
                                          TextSpan(
                                              text:
                                                  "${schedules[index]['endTime']!.split(":")[0]}:${schedules[index]['endTime']!.split(":")[1]}",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      AppColors.secondaryColor,
                                                  fontWeight: FontWeight.w600)),
                                        ])),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              if (!isUpdate)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: double.infinity,
                  color: Colors.transparent,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _addSchedule();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.bgColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                              color: AppColors.secondaryColor, width: 1),
                        )),
                    icon: Icon(Icons.add_circle_outline,
                        size: 25, color: AppColors.secondaryColor),
                    label: const Text('Thêm lịch trình',
                        style: TextStyle(
                          fontSize: 25,
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ),
              if (!isUpdate)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: double.infinity,
                  color: Colors.transparent,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      handleAddActivity();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                    icon: Icon(Icons.edit_calendar,
                        size: 25, color: AppColors.bgColor),
                    label: const Text('Tạo sự kiện',
                        style: TextStyle(
                          fontSize: 25,
                          color: AppColors.bgColor,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ),
              if (isUpdate)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: double.infinity,
                  color: Colors.transparent,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      handleUpdateActivity();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                    icon: Icon(Icons.sync, size: 25, color: AppColors.bgColor),
                    label: const Text('Cập nhật sự kiện',
                        style: TextStyle(
                          fontSize: 25,
                          color: AppColors.bgColor,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
