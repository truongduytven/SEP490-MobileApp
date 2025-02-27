import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class EditRemaining extends StatefulWidget {
  final int currentRemaining;
  const EditRemaining({super.key, required this.currentRemaining});

  @override
  State<EditRemaining> createState() => _EditRemainingState();
}

class _EditRemainingState extends State<EditRemaining> {
  final List<int> _pillCounts = List.generate(100, (index) => index + 1);
  late int _selectedPillCount;

  @override
  void initState() {
    super.initState();
    if (widget.currentRemaining != 0) {
      _selectedPillCount = widget.currentRemaining;
    } else {
      _selectedPillCount = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text('Trong hộp',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryColor)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          const Text(
            'Bạn hiện còn bao nhiêu viên thuốc?',
            style: TextStyle(
                fontSize: 22,
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 300,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                    initialItem: _pillCounts.indexOf(_selectedPillCount)),
                itemExtent: 50.0,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    _selectedPillCount = _pillCounts[index];
                  });
                },
                children: _pillCounts
                    .map((count) => Center(
                          child: Text(
                            count.toString(),
                            style: TextStyle(
                                fontSize: 25,
                                color: count == _selectedPillCount
                                    ? AppColors.secondaryColor
                                    : Colors.grey,
                                fontWeight: count == _selectedPillCount
                                    ? FontWeight.w600
                                    : FontWeight.w400),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _selectedPillCount);
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
        ],
      ),
    );
  }
}
