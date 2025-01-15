import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class EditFrequency extends StatefulWidget {
  final Map<String, dynamic> initialFrequencyData;
  const EditFrequency({super.key, required this.initialFrequencyData});

  @override
  State<EditFrequency> createState() => _EditFrequencyState();
}

class _EditFrequencyState extends State<EditFrequency> {
  late String _selectedFrequency; // Default selection
  late int _selectedDays = 1;
  final List<int> _days = List.generate(30, (index) => index + 1); // 1 to 30
  final List<String> _daysOfWeek = [
    'Thứ 2',
    'Thứ 3',
    'Thứ 4',
    'Thứ 5',
    'Thứ 6',
    'Thứ 7',
    'Chủ nhật'
  ];
  final Set<String> _selectedDaysOfWeek = {};
  late Map<String, dynamic> _frequencyData; // For "Ngày cụ thể trong tuần"

  @override
  void initState() {
    super.initState();
    _frequencyData = Map.from(widget.initialFrequencyData);
    _selectedFrequency = _frequencyData['typeFrequency'] ?? 'Cách ngày';

    if (_selectedFrequency == 'Cách ngày') {
      _selectedDays =
          int.tryParse(_frequencyData['frequencyEvery'] ?? '1') ?? 1;
    } else if (_selectedFrequency == 'Ngày cụ thể trong tuần') {
      _selectedDaysOfWeek
          .addAll(List<String>.from(_frequencyData['frequencySelect'] ?? []));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Tần suất',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryColor)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context, widget.initialFrequencyData);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFrequency = "Cách ngày";
                });
              },
              child:
                  _buildOption("Cách ngày", _selectedFrequency == "Cách ngày"),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFrequency = "Ngày cụ thể trong tuần";
                });
              },
              child: _buildOption("Ngày cụ thể trong tuần",
                  _selectedFrequency == "Ngày cụ thể trong tuần"),
            ),
            const SizedBox(height: 30),
            if (_selectedFrequency == "Cách ngày") _buildEveryFewDaysPicker(),
            if (_selectedFrequency == "Ngày cụ thể trong tuần")
              _buildDaysOfWeekSelection(),
            const Spacer(),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    _saveFrequencyData();
                    Navigator.pop(context, _frequencyData);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                  child: const Text('Lưu',
                      style: TextStyle(
                        fontSize: 28,
                        color: AppColors.bgColor,
                        fontWeight: FontWeight.w400,
                      )),
                ),
              ),
            ],
          ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.borderColor : AppColors.bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? AppColors.secondaryColor : Colors.grey,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 22,
                color: isSelected ? AppColors.secondaryColor : Colors.black,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildEveryFewDaysPicker() {
    return Column(
      children: [
        const Text(
          'Mỗi bao nhiêu ngày?',
          style: TextStyle(
              fontSize: 22, color: Colors.grey, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 300,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
                initialItem: _days.indexOf(_selectedDays)),
            itemExtent: 50.0,
            onSelectedItemChanged: (int index) {
              setState(() {
                _selectedDays = _days[index];
              });
            },
            children: _days
                .map((day) => Center(
                      child: Text(
                        day.toString(),
                        style: TextStyle(
                          fontSize: 25,
                          color: day == _selectedDays ? AppColors.secondaryColor : Colors.grey,
                          fontWeight: day == _selectedDays ? FontWeight.w600 : FontWeight.w400, 
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDaysOfWeekSelection() {
    return Column(
      children: _daysOfWeek.map((day) {
        final isSelected = _selectedDaysOfWeek.contains(day);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedDaysOfWeek.remove(day);
              } else {
                _selectedDaysOfWeek.add(day);
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryLowColor.withOpacity(0.5) : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? AppColors.primaryColor : Colors.grey,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 22,
                      color: isSelected ? AppColors.primaryColor : Colors.black,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: AppColors.primaryColor),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _saveFrequencyData() {
    _frequencyData['typeFrequency'] = _selectedFrequency;
    if (_selectedFrequency == "Cách ngày") {
      _frequencyData['frequencyEvery'] = _selectedDays.toString();
      _frequencyData['frequencySelect'] = [];
    } else if (_selectedFrequency == "Ngày cụ thể trong tuần") {
      _frequencyData['frequencyEvery'] = '';
      _frequencyData['frequencySelect'] = _selectedDaysOfWeek.toList();
    }
  }
}
