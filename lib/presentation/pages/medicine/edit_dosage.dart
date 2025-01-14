import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  late TextEditingController _dosageController;
  late TextEditingController _diffController;
  late String _selectedUnit;
  final FocusNode _focusNode = FocusNode();
  bool _isOtherUnitSelected = false;

  @override
  void initState() {
    super.initState();
    _dosageController = TextEditingController(text: widget.currentDosage);
    _diffController = TextEditingController();
    _selectedUnit = widget.currentUnit;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _dosageController.dispose();
    _diffController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Thêm hàm lượng thuốc',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hàm lượng',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _dosageController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Nhập hàm lượng',
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
              ],
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Đơn vị',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                          _buildUnitButton('mL'),
                          _buildUnitButton('IU'),
                          _buildUnitButton('%'),
                          _buildUnitButton('mcg'),
                          _buildUnitButton('mg'),
                          _buildUnitButton('g'),
                          _buildUnitButton('Khác'),
                        ],
                      ),
                    ],
                  ),
                ),
                if(_isOtherUnitSelected) SizedBox(height: 20),
                if (_isOtherUnitSelected)
                TextField(
                  controller: _dosageController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
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
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, {
                  'dosage': _dosageController.text,
                  'unit': _isOtherUnitSelected
                      ? _diffController.text
                      : _selectedUnit,
                });
              },
              icon: SvgPicture.asset(
                'assets/icons/droplets.svg',
                colorFilter:
                    ColorFilter.mode(AppColors.bgColor, BlendMode.srcIn),
              ),
              label: const Text(
                'Lưu hàm lượng',
                style: TextStyle(fontSize: 22, color: AppColors.bgColor),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 25,
                ),
                backgroundColor: AppColors.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
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
