import 'package:flutter/material.dart';
import 'package:sep490/models/schedule.dart';
import 'package:sep490/theme/color.dart';

class Activitycard extends StatelessWidget {
  final Activity activity;
  const Activitycard({super.key, required this.activity});

  Widget _getActivityIcon(String activityName) {
    switch (activityName) {
      case "Medication":
        return Image.asset('assets/img/uongthuoc.jpg', width: 50, height: 50);
      case "Professor Apointment":
        return Image.asset('assets/img/role3.jpg', width: 50, height: 50);
      case "Tập luyện":
        return Image.asset('assets/img3D/cannang.png', width: 50, height: 50);
      default:
        return Icon(Icons.event, color: AppColors.secondaryColor, size: 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipPath(
            clipper: DiagonalClipper(),
            child: Image.asset(
              'assets/img/uongthuoc.jpg',
              width: 140,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Uống thuốc",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Penicilin v kali 500mg",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Dùng 1 vào 8:00 (sau ăn)",
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "30 viên dùng còn lại",
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "9.00 AM - 10.00 AM",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width * 0.8, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
