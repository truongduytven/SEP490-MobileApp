import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class EditFormMedical extends StatefulWidget {
  final String currentForm;
  const EditFormMedical({super.key, required this.currentForm});

  @override
  State<EditFormMedical> createState() => _EditFormMedicalState();
}

class _EditFormMedicalState extends State<EditFormMedical> {
  late String _selectedForm;

  @override
  void initState() {
    super.initState();
    _selectedForm = widget.currentForm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          title: Text('Chọn dạng thuốc', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: AppColors.secondaryColor)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.secondaryColor),
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
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildButtonForm('Viên nhộng',
                          'assets/img3D/form_medical/viennhong.png'),
                      _buildDivider(),
                      _buildButtonForm(
                          'Viên', 'assets/img3D/form_medical/vien.png'),
                      _buildDivider(),
                      _buildButtonForm(
                          'Ống', 'assets/img3D/form_medical/ong.png'),
                      _buildDivider(),
                      _buildButtonForm(
                          'Lần dùng', 'assets/img3D/form_medical/landung.png'),
                      _buildDivider(),
                      _buildButtonForm(
                          'Xịt', 'assets/img3D/form_medical/xit.png'),
                      _buildDivider(),
                      _buildButtonForm(
                          'Gói', 'assets/img3D/form_medical/goi.png'),
                      _buildDivider(),
                      _buildButtonForm(
                          'Khác', 'assets/img3D/form_medical/khac.png'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildButtonForm(String value, String image) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedForm = value;
        });
        Navigator.pop(context, _selectedForm);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        decoration: BoxDecoration(
          color: _selectedForm == value ? AppColors.borderColor : AppColors.bgColor,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[50],
              radius: 35,
              child: Image.asset(image, width: 48, height: 48),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: _selectedForm == value
                      ? AppColors.secondaryColor
                      : Colors.black,
                  fontSize: 25,
                  fontWeight: _selectedForm == value
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

  Widget _buildDivider() {
    return Divider(
      height: 0.5,
      color: Colors.grey,
      thickness: 0.5,
    );
  }
}
