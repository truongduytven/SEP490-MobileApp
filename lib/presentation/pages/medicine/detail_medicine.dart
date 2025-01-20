import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/medicine/edit_dosage.dart';
import 'package:sep490/presentation/pages/medicine/edit_form_medical.dart';
import 'package:sep490/presentation/pages/medicine/edit_frequency.dart';
import 'package:sep490/presentation/pages/medicine/edit_name.dart';
import 'package:sep490/presentation/pages/medicine/edit_remaining.dart';
import 'package:sep490/presentation/pages/medicine/edit_schedule.dart';
import 'package:sep490/presentation/pages/medicine/edit_treatment.dart';
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
          'typeFrequency': '',
          'frequencyEvery': '',
          'frequencySelect': [],
          'mealTime': '',
          'schedule': [],
        };
  }

  void _handleClickMedicineData(String name) async {
    switch (name) {
      case 'Tên':
        {
          final newName = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditNameScreen(currentName: medicineData['name']),
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
      case 'Liều dùng':
        {
          final firstSpaceIndex = medicineData['dosage'].indexOf(' ');
          final String currentDosage;
          final String currentUnit;

          if (firstSpaceIndex != -1) {
            currentDosage =
                medicineData['dosage'].substring(0, firstSpaceIndex).trim();
            currentUnit =
                medicineData['dosage'].substring(firstSpaceIndex + 1).trim();
          } else {
            currentDosage = medicineData['dosage'].trim();
            currentUnit = 'viên';
          }

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
      case 'Dạng':
        {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditFormMedical(currentForm: medicineData['form']),
            ),
          );
          if (result != null) {
            setState(() {
              medicineData['form'] = result;
            });
          }
        }
        break;
      case 'Điều trị':
        {
          final newTreatment = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditTreatment(currentTreatment: medicineData['treatment']),
            ),
          );
          if (newTreatment != null && newTreatment is String) {
            setState(() {
              medicineData['treatment'] = newTreatment;
            });
          }
        }
        break;
      case 'Trong hộp còn':
        {
          final newRemaining = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditRemaining(currentRemaining: medicineData['remaining']),
            ),
          );
          if (newRemaining != null && newRemaining is String) {
            setState(() {
              medicineData['remaining'] = newRemaining;
            });
          }
        }
        break;
      case 'Tần suất':
        {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditFrequency(
                initialFrequencyData: {
                  'typeFrequency': medicineData['typeFrequency'],
                  'frequencyEvery': medicineData['frequencyEvery'],
                  'frequencySelect': medicineData['frequencySelect'],
                },
              ),
            ),
          );
          if (result != null) {
            setState(() {
              medicineData['typeFrequency'] = result['typeFrequency'];
              medicineData['frequencyEvery'] = result['frequencyEvery'];
              medicineData['frequencySelect'] = result['frequencySelect'];
            });
          }
        }
      case 'Cữ uống':
        {
          final result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              String selectedOption = medicineData['mealTime'].isNotEmpty
                  ? medicineData['mealTime']
                  : '';
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      const Text(
                        'Cữ uống',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Nên uống vào khoảng nào của bữa ăn?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Options
                      _buildOption(
                        title: 'Trước khi ăn',
                        isSelected: selectedOption == 'Trước khi ăn',
                        onTap: () {
                          selectedOption = 'Trước khi ăn';
                          Navigator.pop(context, selectedOption);
                        },
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      _buildOption(
                        title: 'Sau khi ăn',
                        isSelected: selectedOption == 'Sau khi ăn',
                        onTap: () {
                          selectedOption = 'Sau khi ăn';
                          Navigator.pop(context, selectedOption);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );

          if (result != null) {
            setState(() {
              medicineData['mealTime'] = result; // Update the meal time
            });
          }
        }
        break;
      case 'Đặt lịch':
        {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditSchedule(
                schedules: List<String>.from(medicineData['schedule']),
              ),
            ),
          );

          if (result != null) {
            setState(() {
              medicineData['schedule'] = result;
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
        scrolledUnderElevation: 0,
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
              title: 'Liều dùng',
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
            _buildFrequencyRow(
              iconPath: 'assets/icons/calendar_sync.svg',
              title: 'Tần suất',
              value: medicineData['typeFrequency'],
              frequencyEvery: medicineData['frequencyEvery'],
              frequencySelect: medicineData['frequencySelect'],
            ),
            _buildDivider(),
            _buildDetailRow(
              iconPath: 'assets/icons/utenslis_crossed.svg',
              title: 'Cữ uống',
              value: medicineData['mealTime'],
            ),
            _buildDivider(),
            _buildSheduleRow(
              iconPath: 'assets/icons/alarm_clock.svg',
              title: 'Đặt lịch',
              value: medicineData['schedule'],
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
        _handleClickMedicineData(title);
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
                if (title == 'Dạng' && value.isNotEmpty) _buildImgForm(value),
                if (title == 'Điều trị' && value.isNotEmpty)
                  _buildImgTreatment(value),
                SizedBox(
                  width: 10,
                ),
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

  Widget _buildSheduleRow({
    required String iconPath,
    required String title,
    required List<dynamic> value,
  }) {
    return GestureDetector(
      onTap: () {
        _handleClickMedicineData(title);
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: value.map((day) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color(0xFF00d688),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          day,
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (value.isEmpty)
                    const Text(
                      '-',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyRow({
    required String iconPath,
    required String title,
    required String value,
    required String frequencyEvery,
    required List<dynamic> frequencySelect,
  }) {
    return GestureDetector(
      onTap: () {
        _handleClickMedicineData(title);
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (value == 'Cách ngày')
                    Text(
                      'Mỗi $frequencyEvery ngày',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  if (value == 'Ngày cụ thể trong tuần')
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: frequencySelect.map((day) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Color(0xFF00d688),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            day,
                            style: const TextStyle(
                              fontSize: 18,
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  if (value.isEmpty)
                    const Text(
                      '-',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImgTreatment(String value) {
    String imgPath = 'assets/img3D/treatment_medical/huyetap.png';
    if (value == 'Tiểu đường') {
      imgPath = 'assets/img3D/treatment_medical/tieuduong.png';
    } else if (value == 'Tim mạch') {
      imgPath = 'assets/img3D/treatment_medical/timmach.png';
    } else if (value == 'Não') {
      imgPath = 'assets/img3D/treatment_medical/nao.png';
    } else if (value == 'Gan') {
      imgPath = 'assets/img3D/treatment_medical/gan.png';
    } else if (value == 'Phổi') {
      imgPath = 'assets/img3D/treatment_medical/phoi.png';
    } else if (value == 'Thận') {
      imgPath = 'assets/img3D/treatment_medical/than.png';
    } else if (value == 'Xương khớp') {
      imgPath = 'assets/img3D/treatment_medical/xuong.png';
    } else if (value == 'Khác') {
      imgPath = 'assets/img3D/form_medical/khac.png';
    }
    return CircleAvatar(
      backgroundColor: Colors.blue[50],
      radius: 20,
      child: Image.asset(imgPath, width: 30, height: 30),
    );
  }

  Widget _buildImgForm(String value) {
    String imgPath = 'assets/img3D/form_medical/viennhong.png';
    if (value == 'Viên') {
      imgPath = 'assets/img3D/form_medical/vien.png';
    } else if (value == 'Ống') {
      imgPath = 'assets/img3D/form_medical/ong.png';
    } else if (value == 'Lần dùng') {
      imgPath = 'assets/img3D/form_medical/landung.png';
    } else if (value == 'Xịt') {
      imgPath = 'assets/img3D/form_medical/xit.png';
    } else if (value == 'Gói') {
      imgPath = 'assets/img3D/form_medical/goi.png';
    } else if (value == 'Khác') {
      imgPath = 'assets/img3D/form_medical/khac.png';
    }
    return CircleAvatar(
      backgroundColor: Colors.blue[50],
      radius: 20,
      child: Image.asset(imgPath, width: 30, height: 30),
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

  Widget _buildOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // color: isSelected
          //     ? AppColors.primaryLowColor.withOpacity(0.4)
          //     : Colors.white,
          // border: Border.all(
          //   color: isSelected ? AppColors.primaryColor : Colors.grey,
          //   width: 1.5,
          // ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primaryColor : Colors.black,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
