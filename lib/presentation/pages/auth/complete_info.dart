import 'package:flutter/material.dart';
import 'package:sep490/presentation/widgets/form/complete_info_form.dart';
import 'package:sep490/theme/color.dart';

class CompleteInfoScreen extends StatefulWidget {
  const CompleteInfoScreen({super.key});

  @override
  State<CompleteInfoScreen> createState() => _CompleteInfoScreenState();
}

class _CompleteInfoScreenState extends State<CompleteInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Đăng kí tài khoản",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hoàn tất việc đăng ký bằng cách thêm những chỉ số cần thiết",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppColors.textColor, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                CompleteInfoForm(),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
