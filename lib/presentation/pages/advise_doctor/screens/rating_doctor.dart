import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/controllers/doctor_controller.dart';
import 'package:sep490/theme/color.dart';

class RatingDoctor extends StatefulWidget {
  final AppoimentDoctor? appoimentDoctor;
  const RatingDoctor({super.key, this.appoimentDoctor});

  @override
  State<RatingDoctor> createState() => _RatingDoctorState();
}

class _RatingDoctorState extends State<RatingDoctor> {
  TextEditingController commentController = TextEditingController();
  double rating = 0.0;
  bool isLoading = false;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late String fullName = '';

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    fullName = sharedPrefsHelper.getString('fullName') ?? '';
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void handleRatingDoctor() async {
    if (rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn đánh giá')),
      );
      return;
    }
    if (commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập nhận xét')),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();

    await doctorController.ratingDoctor(
      widget.appoimentDoctor?.professorAppointmentId ?? 0,
      commentController.text,
      int.parse(rating.toStringAsFixed(0)),
      fullName,
    );

    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (doctorController.isRatingSuccess) {
        CherryToast.success(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Đánh giá thành công",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        Navigator.pop(context, true);
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Đánh giá thất bại, vui lòng thử lại",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Đánh giá bác sĩ',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 25)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        widget.appoimentDoctor?.professorAvatar ?? ''),
                    radius: 30,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.appoimentDoctor?.professorName ?? '',
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600)),
                      Text(widget.appoimentDoctor?.dateTime ?? '',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Đánh giá',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        rating = index + 1.0;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              const Text('Nhận xét',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              TextField(
                controller: commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusColor: AppColors.primaryColor,
                  hintText: 'Nhập nhận xét của bạn',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      handleRatingDoctor();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator()
                        : const Text('Gửi đánh giá',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
