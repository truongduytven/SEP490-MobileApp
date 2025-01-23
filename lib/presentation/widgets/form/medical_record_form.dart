import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class MedicalRecordForm extends StatefulWidget {
  final Function(List<Map<String, String>>) onSelectionChanged;

  const MedicalRecordForm({super.key, required this.onSelectionChanged});

  @override
  State<MedicalRecordForm> createState() => _MedicalRecordFormState();
}

class _MedicalRecordFormState extends State<MedicalRecordForm> {
  final List<Map<String, String>> treatmentOptions = [
    {
      "name": "Gan",
      "image": "assets/img3D/treatment_medical/gan.png",
    },
    {
      "name": "Huyết áp",
      "image": "assets/img3D/treatment_medical/huyetap.png",
    },
    {
      "name": "Não",
      "image": "assets/img3D/treatment_medical/nao.png",
    },
    {
      "name": "Phổi",
      "image": "assets/img3D/treatment_medical/phoi.png",
    },
    {
      "name": "Thận",
      "image": "assets/img3D/treatment_medical/than.png",
    },
    {
      "name": "Tiểu đường",
      "image": "assets/img3D/treatment_medical/tieuduong.png",
    },
    {
      "name": "Tim mạch",
      "image": "assets/img3D/treatment_medical/timmach.png",
    },
    {
      "name": "Xương khớp",
      "image": "assets/img3D/treatment_medical/xuong.png",
    },
    {
      "name": "Khác",
      "image": "assets/img3D/form_medical/khac.png",
    },
  ];
  final List<Map<String, String>> selectedTreatments = [];
  String additionalTreatment = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: treatmentOptions.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                _buildButtonForm(treatmentOptions[index]),
                if (index != treatmentOptions.length - 1)
                  const Divider(color: AppColors.borderColor),
              ],
            );
          },
        ),
        if (selectedTreatments.any((treatmean) =>
            treatmean['name'] == 'Khác')) // If "Khác" is selected
          TextField(
            decoration: InputDecoration(
              labelText: 'Nhập thêm điều trị',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              additionalTreatment = value;
            },
          ),
      ],
    );
  }

  Widget _buildButtonForm(Map<String, String> treatment) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedTreatments.contains(treatment)) {
            selectedTreatments.remove(treatment);
          } else {
            selectedTreatments.add(treatment);
          }
        });
        widget.onSelectionChanged(selectedTreatments);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: selectedTreatments.contains(treatment)
              ? AppColors.borderColor
              : AppColors.bgColor,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[50],
              radius: 35,
              child: Image.asset(treatment['image']!, width: 48, height: 48),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                treatment['name']!,
                style: TextStyle(
                  color: selectedTreatments.contains(treatment)
                      ? AppColors.secondaryColor
                      : Colors.black,
                  fontSize: 25,
                  fontWeight: selectedTreatments.contains(treatment)
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
