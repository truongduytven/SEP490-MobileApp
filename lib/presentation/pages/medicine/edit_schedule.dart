import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class EditSchedule extends StatefulWidget {
  final List<String> schedules;
  const EditSchedule({super.key, required this.schedules});

  @override
  State<EditSchedule> createState() => _EditScheduleState();
}

class _EditScheduleState extends State<EditSchedule> {
  late List<String> schedules;
  int selectedHour = 0;
  int selectedMinute = 0;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;

  @override
  void initState() {
    super.initState();
    schedules = widget.schedules;
    final now = TimeOfDay.now();
    selectedHour = now.hour;
    selectedMinute = now.minute;

    hourController = FixedExtentScrollController(initialItem: selectedHour);
    minuteController = FixedExtentScrollController(initialItem: selectedMinute);
  }

  void _addNewSchedule() async {
    final result = '$selectedHour:${selectedMinute.toString().padLeft(2, '0')}';
    setState(() {
      schedules.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đặt lịch',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryColor),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context, schedules);
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildPicker(
                              type: 'hour',
                              controller: hourController,
                              value: selectedHour,
                              items: List.generate(24, (index) => index),
                              onChanged: (value) {
                                setState(() {
                                  selectedHour = value;
                                });
                              },
                            ),
                            const Text(
                              ':',
                              style: TextStyle(fontSize: 22),
                            ),
                            _buildPicker(
                              type: 'minute',
                              controller: minuteController,
                              value: selectedMinute,
                              items: List.generate(60, (index) => index),
                              onChanged: (value) {
                                setState(() {
                                  selectedMinute = value;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _addNewSchedule,
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  backgroundColor: Color(0xFFE3E6EC),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  '+ Thêm lịch cữ thuốc',
                                  style: TextStyle(
                                      fontSize: 22, color: AppColors.iconColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: schedules.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.bgColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(left: 20),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                leading: Text(
                                  schedules[index], // Time string
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      schedules.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Save button fixed at the bottom
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, schedules); // Save and return schedules
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Lưu',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPicker<T>({
    required String type,
    required FixedExtentScrollController controller,
    required T value,
    required List<T> items,
    required ValueChanged<T> onChanged,
  }) {
    return Column(
      children: [
        Text(
          type == 'hour' ? 'Giờ' : 'Phút',
          style: TextStyle(
              fontSize: 20,
              color: AppColors.secondaryColor,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 120,
          height: 140,
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              onChanged(items[index]);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                return Center(
                  child: Text(
                    items[index].toString(),
                    style: TextStyle(
                      fontSize: value == items[index] ? 25 : 20,
                      fontWeight: value == items[index]
                          ? FontWeight.bold
                          : FontWeight.w400,
                      color: value == items[index]
                          ? Colors.black
                          : Colors.grey.shade600,
                    ),
                  ),
                );
              },
              childCount: items.length,
            ),
          ),
        ),
      ],
    );
  }
}
