import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/auth/complete_info.dart';
import 'package:sep490/presentation/widgets/form/medical_record_form.dart';
import 'package:sep490/theme/color.dart';

class MedicalRecordScreen extends StatefulWidget {
  const MedicalRecordScreen({super.key});

  @override
  State<MedicalRecordScreen> createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  List<Map<String, String>> selectedTreatments = [];
  Future<void> submitForm() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CompleteInfoScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Bệnh án",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompleteInfoScreen()));
            },
            child: Text(
              "Bỏ qua",
              style: TextStyle(color: AppColors.secondaryColor, fontSize: 18),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.80,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Bạn có đang gặp phải vấn đề về sức khỏe nào không?",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: AppColors.textColor, fontSize: 20),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    MedicalRecordForm(
                      onSelectionChanged: (List<Map<String, String>> selected) {
                        setState(() {
                          selectedTreatments = selected;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: selectedTreatments.isNotEmpty ? submitForm : null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: selectedTreatments.isNotEmpty ? AppColors.secondaryColor : AppColors.grayColor3,
                  foregroundColor: AppColors.bgColor,
                  minimumSize: const Size(double.infinity, 55),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                child: Text(
                  "Tiếp tục",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bgColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
