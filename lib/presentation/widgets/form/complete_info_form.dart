import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/navigation_menu.dart';
import 'package:sep490/presentation/widgets/auth_field.dart';
import 'package:sep490/theme/color.dart';

class CompleteInfoForm extends StatefulWidget {
  const CompleteInfoForm({super.key});

  @override
  State<CompleteInfoForm> createState() => _CompleteInfoFormState();
}

class _CompleteInfoFormState extends State<CompleteInfoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    weightController.addListener(_valuechanged);
    heightController.addListener(_valuechanged);
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  void _valuechanged() {
    if (weightController.text.isNotEmpty && heightController.text.isNotEmpty) {
      setState(() {
        isButtonEnabled = true;
      });
    } else {
      setState(() {
        isButtonEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            AuthField(
              labelText: "Cân nặng",
              hintText: "Nhập cân nặng",
              controller: weightController,
              keyboardType: TextInputType.number,
              isRequired: true,
              suffixText: "(kg)",
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            AuthField(
              labelText: "Chiều cao",
              hintText: "Nhập chiều cao",
              controller: heightController,
              keyboardType: TextInputType.number,
              isRequired: true,
              suffixText: "(cm)",
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ElevatedButton(
              onPressed: isButtonEnabled
                  ? () {
                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavigationMenu(keyIndex: 0,),
                          ),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.secondaryColor,
                foregroundColor: AppColors.bgColor,
                minimumSize: const Size(double.infinity, 55),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: const Text(
                "Tiếp tục",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ));
  }
}
