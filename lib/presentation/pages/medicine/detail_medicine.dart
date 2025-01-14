import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/medicine/edit_dosage.dart';
import 'package:sep490/presentation/pages/medicine/edit_name.dart';
import 'package:sep490/theme/color.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailMedicine extends StatefulWidget {
  final Map<String, dynamic>? medicineData;
  const DetailMedicine({super.key, this.medicineData});

  @override
  State<DetailMedicine> createState() => _DetailMedicineState();
}

class _DetailMedicineState extends State<DetailMedicine> {
  late bool hasData;
  late Map<String, dynamic> medicineData;

  @override
  void initState() {
    super.initState();
    hasData = widget.medicineData != null;
    medicineData = widget.medicineData ??
        {
          'name': '',
          'dosage': '',
          'form': '',
          'treatment': '',
          'remaining': '',
          'frequency': '',
          'mealTime': '',
          'schedule': [],
        };
  }

  void _handleClickMedicineData(String name, String value) async {
    switch (name) {
      case 'Tên':
        {
          final newName = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditNameScreen(currentName: value),
            ),
          );

          // Update the name if the user provided a new one
          if (newName != null && newName is String) {
            setState(() {
              medicineData['name'] = newName;
            });
          }
        }
        break;
      case 'Hàm lượng':
        {
          final parts = value.split(' ');
          final currentDosage = parts[0];
          final currentUnit = parts.length > 1 ? parts[1] : 'mL';

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditDosageScreen(
                currentDosage: currentDosage,
                currentUnit: currentUnit,
              ),
            ),
          );
          if (result != null) {
            setState(() {
              medicineData['dosage'] = '${result['dosage']} ${result['unit']}';
            });
          }
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6FC),
      appBar: AppBar(
        title: Text(
          hasData ? 'Chi tiết thuốc' : 'Tạo thuốc',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Chi tiết',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailsSection(),
                  const SizedBox(height: 20),
                  const Text(
                    'Nhắc nhở',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  _buildRemindersSection(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: double.infinity,
            color: Colors.transparent,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailMedicine(),
                  ),
                );
              },
              icon: Icon(
                hasData ? Icons.pause_circle_outline : Icons.add_circle_outline,
                size: 25,
                color: hasData ? AppColors.secondaryColor : AppColors.bgColor,
              ),
              label: Text(
                hasData ? 'Cập nhật thuốc' : 'Thêm thuốc',
                style: TextStyle(
                    fontSize: 25,
                    color:
                        hasData ? AppColors.secondaryColor : AppColors.bgColor),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 25,
                ),
                backgroundColor:
                    hasData ? AppColors.bgColor : AppColors.secondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: BorderSide(
                        color: hasData
                            ? AppColors.secondaryColor
                            : Colors.transparent)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: AppColors.bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            _buildDetailRow(
              iconPath: 'assets/icons/pill.svg',
              title: 'Tên',
              value: medicineData['name'],
            ),
            _buildDivider(),
            _buildDetailRow(
              iconPath: 'assets/icons/droplets.svg',
              title: 'Hàm lượng',
              value: medicineData['dosage'],
            ),
            _buildDivider(),
            _buildDetailRow(
              iconPath: 'assets/icons/shapes.svg',
              title: 'Dạng',
              value: medicineData['form'],
            ),
            _buildDivider(),
            _buildDetailRow(
              iconPath: 'assets/icons/hospital.svg',
              title: 'Điều trị',
              value: medicineData['treatment'],
            ),
            _buildDivider(),
            _buildDetailRow(
              iconPath: 'assets/icons/briefcase_medical.svg',
              title: 'Trong hộp còn',
              value: medicineData['remaining'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemindersSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        color: AppColors.bgColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            _buildDetailRow(
              iconPath: 'assets/icons/calendar_sync.svg',
              title: 'Tần suất',
              value: medicineData['frequency'],
            ),
            _buildDivider(),
            _buildDetailRow(
              iconPath: 'assets/icons/utenslis_crossed.svg',
              title: 'Cữ uống',
              value: medicineData['mealTime'],
            ),
            _buildDivider(),
            _buildDetailRow(
              iconPath: 'assets/icons/alarm_clock.svg',
              title: 'Đặt lịch',
              value: medicineData['schedule'].isNotEmpty
                  ? medicineData['schedule'].join(', ')
                  : '-',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String iconPath,
    required String title,
    required String value,
  }) {
    return GestureDetector(
      onTap: () {
        _handleClickMedicineData(title, value);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 30,
                  height: 30,
                  colorFilter:
                      ColorFilter.mode(AppColors.iconColor, BlendMode.srcIn),
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  value.isNotEmpty ? value : '-',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Divider(
        color: Colors.grey,
        thickness: 1,
      ),
    );
  }
}
