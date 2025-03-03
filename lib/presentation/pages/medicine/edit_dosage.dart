import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class EditDosageScreen extends StatefulWidget {
  final String currentDosage;
  final String currentUnit;

  const EditDosageScreen(
      {super.key, required this.currentDosage, required this.currentUnit});

  @override
  State<EditDosageScreen> createState() => _EditDosageScreenState();
}

class _EditDosageScreenState extends State<EditDosageScreen> {
  late TextEditingController _diffController;
  late String _selectedUnit;
  final FocusNode _focusNode = FocusNode();
  bool _isOtherUnitSelected = false;
  final List<String> _units = ['Viên', 'Muỗng', 'Lần dùng'];
  final List<String> _pillCounts = [
    '1/4',
    '1/3',
    '1/2',
    ...List.generate(20, (index) => (index + 1).toString())
  ];
  late String _selectedPillCount = '1';

  @override
  void initState() {
    super.initState();
    if (widget.currentDosage != '') {
      _selectedPillCount = widget.currentDosage;
    } else {
      _selectedPillCount = '1';
    }
    if (_units.contains(widget.currentUnit)) {
      _selectedUnit = widget.currentUnit;
      _diffController = TextEditingController();
      _isOtherUnitSelected = false;
    } else {
      _selectedUnit = 'Khác';
      _diffController = TextEditingController(text: widget.currentUnit);
      _isOtherUnitSelected = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _diffController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6FC),
      appBar: AppBar(
        title: Text(
          'Thêm liều dùng thuốc',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFFFFF6FC),
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Đơn vị',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 300,
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                                initialItem:
                                    _pillCounts.indexOf(_selectedPillCount)),
                            itemExtent: 50.0,
                            onSelectedItemChanged: (int index) {
                              setState(() {
                                _selectedPillCount = _pillCounts[index];
                              });
                            },
                            children: _pillCounts
                                .map((count) => Center(
                                      child: Text(
                                        count,
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: count == _selectedPillCount
                                                ? AppColors.secondaryColor
                                                : Colors.grey,
                                            fontWeight:
                                                count == _selectedPillCount
                                                    ? FontWeight.w600
                                                    : FontWeight.w400),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Đơn vị',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      if (_isOtherUnitSelected)
                        TextField(
                          controller: _diffController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: 'Nhập đơn vị khác',
                            hintStyle:
                                const TextStyle(fontSize: 20, color: Colors.grey),
                            filled: true,
                            fillColor: AppColors
                                .bgColor, // Background color of the input field
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ), // Padding inside the input
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Rounded corners
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey, // Border color when enabled
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: AppColors
                                    .secondaryColor, // Border color when focused
                                width: 2,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: 20, color: AppColors.secondaryColor),
                        ),
                      if (_isOtherUnitSelected) SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _buildUnitButton('Viên'),
                                _buildUnitButton('Muỗng'),
                                _buildUnitButton('Lần dùng'),
                                _buildUnitButton('Khác'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30), 
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context, {
                              'dosage': _selectedPillCount.toString(),
                              'unit': _isOtherUnitSelected
                                  ? _diffController.text
                                  : _selectedUnit,
                            });
                          },
                          label: const Text(
                            'Lưu',
                            style: TextStyle(fontSize: 25, color: AppColors.bgColor),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 50,
                            ),
                            backgroundColor: AppColors.secondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnitButton(String unit) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUnit = unit;
          _isOtherUnitSelected = unit == 'Khác';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: _selectedUnit == unit
              ? AppColors.secondaryColor
              : AppColors.bgColor,
          // border: Border.all(
          //     color: _selectedUnit == unit ? Colors.blueAccent : Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          unit,
          style: TextStyle(
            fontSize: 20,
            color: _selectedUnit == unit ? Colors.white : Colors.black,
            fontWeight:
                _selectedUnit == unit ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
