import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class EditTreatment extends StatefulWidget {
  final String currentTreatment;
  const EditTreatment({super.key, required this.currentTreatment});

  @override
  State<EditTreatment> createState() => _EditTreatmentState();
}

class _EditTreatmentState extends State<EditTreatment> {
  late String _selectedTreatment;

  @override
  void initState() {
    super.initState();
    _selectedTreatment = widget.currentTreatment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          title: Text('Chọn bệnh điều trị',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryColor)),
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildButtonForm('Huyết Áp',
                          'assets/img3D/treatment_medical/huyetap.png'),
                      _buildDivider(),
                      _buildButtonForm(
                          'Tiểu đường', 'assets/img3D/treatment_medical/tieuduong.png'),
                      _buildDivider(),
                      _buildButtonForm(
                          'Tim mạch', 'assets/img3D/treatment_medical/timmach.png'),
                      _buildDivider(),
                      _buildButtonForm(
                          'Não', 'assets/img3D/treatment_medical/nao.png'),
                      _buildDivider(),
                      _buildButtonForm(
                          'Gan', 'assets/img3D/treatment_medical/gan.png'),
                      _buildDivider(),
                      _buildButtonForm(
                          'Phổi', 'assets/img3D/treatment_medical/phoi.png'),
                      _buildDivider(),
                      _buildButtonForm(
                          'Thận', 'assets/img3D/treatment_medical/than.png'),
                      _buildDivider(),
                      _buildButtonForm(
                          'Xương khớp', 'assets/img3D/treatment_medical/xuong.png'),
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
          _selectedTreatment = value;
        });
        Navigator.pop(context, _selectedTreatment);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        decoration: BoxDecoration(
          color: _selectedTreatment == value
              ? AppColors.borderColor
              : AppColors.bgColor,
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
                  color: _selectedTreatment == value
                      ? AppColors.secondaryColor
                      : Colors.black,
                  fontSize: 25,
                  fontWeight: _selectedTreatment == value
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
