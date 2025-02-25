import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/models/user_contact.dart';
import 'package:sep490/theme/color.dart';

class UserInformationScreen extends StatelessWidget {
  final UserContact user;

  const UserInformationScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text(
          'Thông tin người dùng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Background with Avatar
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none, // Ensure avatar is not clipped
              children: [
                Container(
                  height: 180, // Adjusted height
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          user.avatar), // User's avatar as background
                      fit: BoxFit.cover, // Cover the entire container
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor
                              .withOpacity(0.6), // Darker gradient with opacity
                          AppColors.primaryColor
                              .withOpacity(0.4), // Darker gradient with opacity
                          // AppColors.primaryLowColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // Profile Image
                Positioned(
                  bottom: -50, // Adjusted to make avatar fully visible
                  child: CircleAvatar(
                    radius: 55, // Slightly increased size
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 52,
                      backgroundImage: NetworkImage(user.avatar),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
                height: 60), // Increased space to avoid avatar overlap

            // Name & Location
            Text(
              user.fullName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            // User Info
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.circular(12),
              //   boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildInfoRow("Email", user.email),
                  buildInfoRow("Giới tính",
                      user.gender.toLowerCase() == "female" ? "Nữ" : "Nam"),
                  buildInfoRow("Ngày sinh",
                      formatDate(user.dateOfBirth)), // Fix dob format
                  buildInfoRow("Số điện thoại", user.phoneNumber),
                  buildInfoRow(
                      "Thành viên từ ngày:", formatDate(user.createdDate)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime dob) {
    return DateFormat('dd/MM/yyyy').format(dob);
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: AppColors.primaryColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const Divider(thickness: 1),
        ],
      ),
    );
  }
}
