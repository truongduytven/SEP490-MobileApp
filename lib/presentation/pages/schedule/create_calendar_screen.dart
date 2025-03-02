import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sep490/presentation/widgets/auth_field.dart';

class CreateCalendarScreen extends StatefulWidget {
  const CreateCalendarScreen({super.key});

  @override
  State<CreateCalendarScreen> createState() => _CreateCalendarScreenState();
}

class _CreateCalendarScreenState extends State<CreateCalendarScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  List<Map<String, String>> schedules = [];

  void _addSchedule() {
    setState(() {
      schedules.add({"startTime": "08:00", "endTime": "17:00"});
    });
  }

  void _removeSchedule(int index) {
    setState(() {
      schedules.removeAt(index);
    });
  }

  void _showTimePicker(int index, String key) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoPicker(
                itemExtent: 32,
                onSelectedItemChanged: (value) {
                  String time =
                      "${(value ~/ 2).toString().padLeft(2, '0')}:${(value % 2 == 0) ? '00' : '30'}";
                  setState(() {
                    schedules[index][key] = time;
                  });
                },
                children: List.generate(
                  48,
                  (index) => Text(
                      "${(index ~/ 2).toString().padLeft(2, '0')}:${(index % 2 == 0) ? '00' : '30'}"),
                ),
              ),
            ),
            CupertinoButton(
              child: const Text("Done"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo sự kiện'),
        centerTitle: true,
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
                  controller: descriptionController,
                  suffixText: "(ngày)"
                  ),
              SizedBox(height: 25),
              Text('Lịch trình', style: const TextStyle(fontSize: 20)),
              Expanded(
                child: ListView.builder(
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text("Lịch trình ${index + 1}"),
                        subtitle: Row(
                          children: [
                            Text("Bắt đầu: ${schedules[index]['startTime']}",
                                style: const TextStyle(fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.access_time),
                              onPressed: () =>
                                  _showTimePicker(index, "startTime"),
                            ),
                            Text("Kết thúc: ${schedules[index]['endTime']}",
                                style: const TextStyle(fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.access_time),
                              onPressed: () =>
                                  _showTimePicker(index, "endTime"),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeSchedule(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _addSchedule,
                child: const Text("Thêm lịch trình"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Call API to create calendar
                  }
                },
                child: const Text('Create'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
