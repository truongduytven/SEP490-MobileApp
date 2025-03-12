import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/models/schedule.dart';
import 'package:sep490/presentation/pages/schedule/Controller/schedule_controller.dart';
import 'package:sep490/presentation/widgets/auth_field.dart';
import 'package:sep490/presentation/widgets/loading/loadingImgPath.dart';
import 'package:sep490/theme/color.dart';

class CreateCalendarScreen extends StatefulWidget {
  final Activity? data;
  final String? date;
  const CreateCalendarScreen({super.key, this.data, this.date});

  @override
  State<CreateCalendarScreen> createState() => _CreateCalendarScreenState();
}

class _CreateCalendarScreenState extends State<CreateCalendarScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  late List<Map<String, String>> schedules = [];
  late String scheduleId = "";
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int accountId = 0;
  late String fullName = "";
  late bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      accountId = sharedPrefsHelper.getInt('accountId') ?? 0;
      isUpdate = widget.date != null ? true : false;
      fullName = sharedPrefsHelper.getString('fullName') ?? "";
      titleController.text = widget.data != null ? widget.data!.title : "";
      durationController.text =
          widget.data != null ? widget.data!.duration.toString() : "";
      descriptionController.text =
          widget.data != null ? widget.data!.description : "";
      schedules.add({
        "startTime": widget.data != null
            ? "${widget.data!.startTime}:00.000"
            : "08:00:00.000",
        "endTime": widget.data != null
            ? "${widget.data!.endTime}:00.000"
            : "17:00:00.000"
      });
    });
  }

  void _addSchedule() {
    setState(() {
      schedules.add({"startTime": "08:00:00.000", "endTime": "17:00:00.000"});
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
      Map<String, dynamic> data = {
        "accountId": accountId,
        "title": titleController.text,
        "description": descriptionController.text,
        "startDate": widget.date,
        "createdBy": fullName,
        "duration": int.tryParse(durationController.text) ?? 0,
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
      LoadingDialog.show(
          context, 'assets/gif/loading_calendar.gif', "Đang cập nhật sự kiện...");
      Map<String, dynamic> data = {
        "activityId": widget.data!.activityId,
        "title": titleController.text,
        "description": descriptionController.text,
        "createdBy": fullName,
        "date": widget.date,
        "duration": int.tryParse(durationController.text) ?? 0,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tạo sự kiện',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
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
              AuthField(
                  hintText: "Nhập số ngày",
                  labelText: "Sự kiện diễn ra trong bao lâu",
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  suffixText: "(ngày)"),
              SizedBox(height: 25),
              Text('Lịch trình', style: const TextStyle(fontSize: 20)),
              Expanded(
                child: ListView.builder(
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        subtitle: Row(
                          children: [
                            RichText(
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
                                      color: AppColors.secondaryColor,
                                      fontWeight: FontWeight.w600)),
                            ])),
                            IconButton(
                              icon: const Icon(Icons.access_time),
                              onPressed: () =>
                                  _showTimePicker(index, "startTime"),
                            ),
                            RichText(
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
                                      color: AppColors.secondaryColor,
                                      fontWeight: FontWeight.w600)),
                            ])),
                            IconButton(
                              icon: const Icon(Icons.access_time),
                              onPressed: () =>
                                  _showTimePicker(index, "endTime"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 25),
              if(!isUpdate)  
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
              if(!isUpdate)
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
                  label: const Text('Lưu thay đổi',
                      style: TextStyle(
                        fontSize: 25,
                        color: AppColors.bgColor,
                        fontWeight: FontWeight.w400,
                      )),
                ),
              ),
              if(isUpdate)
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
                  icon: Icon(Icons.sync,
                      size: 25, color: AppColors.bgColor),
                  label: const Text('Cập nhật sự kiện',
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
      ),
    );
  }
}
