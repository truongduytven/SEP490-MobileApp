import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/auth/signin_screen.dart';
import 'package:sep490/presentation/pages/chat/chat_screen.dart';
import 'package:sep490/presentation/pages/health/health_screen.dart';
import 'package:sep490/presentation/pages/home/home_screen.dart';
import 'package:sep490/presentation/pages/schedule/schedule_screen.dart';
import 'package:sep490/presentation/pages/ultility/ultility_screen.dart';
import 'package:sep490/theme/color.dart';

import 'package:shared_preferences/shared_preferences.dart'; // Ensure you import the LoginPage

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0; // Currently selected index, starts with Home

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false; // Prevent default back navigation
        } else {
          await _showLogoutDialog(); // Show logout dialog
          return false; // Prevent default back navigation
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.transparent, // No background indicator
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    fontSize: 14, // Larger font for selected labels
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  );
                }
                return const TextStyle(
                  fontSize: 0, // Hide label when not selected
                );
              },
            ),
          ),
          child: NavigationBar(
            backgroundColor: AppColors.bgColor,
            indicatorColor: Colors.transparent,
            height: 80,
            elevation: 0,
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home, size: 30),
                selectedIcon: Icon(
                  Icons.home,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                label: "Trang chủ",
              ),
              NavigationDestination(
                icon: Icon(Icons.monitor_heart_outlined, size: 30),
                selectedIcon: Icon(
                  Icons.monitor_heart_outlined,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                label: "Sức khỏe",
              ),
              NavigationDestination(
                icon: Icon(Icons.chat_outlined, size: 30),
                selectedIcon: Icon(
                  Icons.chat_outlined,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                label: "Trò chuyện",
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined, size: 30),
                selectedIcon: Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                label: "Lịch trình",
              ),
              NavigationDestination(
                icon: Icon(Icons.grid_view_outlined, size: 30),
                selectedIcon: Icon(
                  Icons.grid_view_outlined,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                label: "Tiện ích",
              ),
            ],
          ),
        ),
        body: Center(
          child: _getSelectedPage(_selectedIndex), // Display selected page
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return HealthScreen();
      case 2:
        return ChatScreen();
      case 3:
        return ScheduleScreen();
      case 4:
        return UltilityScreen();
      default:
        return HomeScreen();
    }
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đăng xuất'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc muốn đăng xuất?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Đăng xuất'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Clear all stored data

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                  (Route<dynamic> route) => false,
                ); // Navigate to login page and remove all previous routes
              },
            ),
          ],
        );
      },
    );
  }
}
