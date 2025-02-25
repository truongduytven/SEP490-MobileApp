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
        scrolledUnderElevation: 0,
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
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 200, // Adjusted height
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // image: DecorationImage(
                    //   image: NetworkImage(
                    //       user.avatar), // User's avatar as background
                    //   fit: BoxFit.cover, // Cover the entire container
                    // ),
                    // border: Border.all(
                    //   color: Colors.white, // Border color
                    //   width: 4, // Border width
                    // ),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image:
                          AssetImage('assets/img/happy_4.jpg'), // Change this
                      fit: BoxFit.cover,
                      opacity: 1, // Light effect
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
            const SizedBox(height: 10),
            // Add Friend Button
            ElevatedButton.icon(
              onPressed: () {
                // Add friend action
                print("Friend request sent to ${user.fullName}");
              },
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text("Thêm bạn",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
                  buildInfoRow("Số điện thoại", user.phoneNumber),
                  buildInfoRow("Giới tính",
                      user.gender.toLowerCase() == "female" ? "Nữ" : "Nam"),
                  buildInfoRow("Ngày sinh",
                      formatDate(user.dateOfBirth)), // Fix dob format
                  buildInfoRow("Email", user.email),
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
