import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Background Image
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade700, Colors.purple.shade300],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              image: DecorationImage(
                image: AssetImage('assets/profile_bg.jpg'), // Change this
                fit: BoxFit.cover,
                opacity: 0.3, // Light effect
              ),
            ),
          ),

          // Profile & Details
          Column(
            children: [
              const SizedBox(height: 60),

              // Top Bar (Menu + Title + Settings)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.menu, color: Colors.white, size: 28),
                    Text(
                      "PROFILE",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.settings, color: Colors.white, size: 28),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Avatar
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/women/44.jpg"), // Change this
                ),
              ),

              const SizedBox(height: 10),

              // Name & Location
              Text(
                "AVLIN THOMUS",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "NEW YORK",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),

              const SizedBox(height: 20),

              // User Info
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInfoRow("Name", "Avlin Thomus"),
                      buildInfoRow("Email", "Avlin_tms@gmail.com"),
                      buildInfoRow("Password", "********"),
                      buildInfoRow("User ID", "22200"),
                      buildInfoRow("Zip Code", "08817"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Divider(thickness: 1),
        ],
      ),
    );
  }
}
