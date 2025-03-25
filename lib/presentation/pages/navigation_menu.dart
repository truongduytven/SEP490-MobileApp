import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sep490/presentation/layout/mobile_layout_screen.dart';
import 'package:sep490/presentation/pages/advise_doctor/home_doctor_advise.dart';
import 'package:sep490/features/health/screens/health_screen.dart';
import 'package:sep490/presentation/pages/home/home_screen.dart';
import 'package:sep490/presentation/pages/ultility/ultility_screen.dart';
import 'package:sep490/theme/color.dart';
import 'package:flutter/services.dart';

class NavigationMenu extends StatefulWidget {
  final int keyIndex;
  const NavigationMenu({super.key, required this.keyIndex});

  @override
  // ignore: library_private_types_in_public_api
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.keyIndex;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false; // Prevent default back navigation
        } else {
          await _showOutDialog(); // Show logout dialog
          return false; // Prevent default back navigation
        }
        // await _showOutDialog();
        // return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.transparent,
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  );
                }
                return const TextStyle(
                  fontSize: 0,
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
            destinations: [
              NavigationDestination(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedHome02,
                  color: AppColors.iconColor,
                  size: 30,
                ),
                selectedIcon: HugeIcon(
                  icon: HugeIcons.strokeRoundedHome02,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                label: "Trang chủ",
              ),
              NavigationDestination(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedHealth,
                  color: AppColors.iconColor,
                  size: 30,
                ),
                selectedIcon: HugeIcon(
                  icon: HugeIcons.strokeRoundedHealth,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                label: "Sức khỏe",
              ),
              NavigationDestination(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedBubbleChatUser,
                  color: AppColors.iconColor,
                  size: 30,
                ),
                selectedIcon: HugeIcon(
                  icon: HugeIcons.strokeRoundedBubbleChatUser,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                label: "Trò chuyện",
              ),
              NavigationDestination(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedDoctor01,
                  color: AppColors.iconColor,
                  size: 30,
                ),
                selectedIcon: HugeIcon(
                  icon: HugeIcons.strokeRoundedDoctor01,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                label: "Tư vấn",
              ),
              NavigationDestination(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedDashboardSquare03,
                  color: AppColors.iconColor,
                  size: 30,
                ),
                selectedIcon: HugeIcon(
                  icon: HugeIcons.strokeRoundedDashboardSquare03,
                  
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
        return MobileLayoutScreen();
      case 3:
        return HomeDoctorAdviseScreen();
      case 4:
        return UltilityScreen();
      default:
        return HomeScreen();
    }
  }

  Future<void> _showOutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thoát ứng dụng'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Bạn có chắc chắn muốn thoát ứng dụng không?'),
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
              child: Text('Thoát ngay'),
              onPressed: () async {
                SystemNavigator
                    .pop(); // Navigate to login page and remove all previous routes
              },
            ),
          ],
        );
      },
    );
  }
}
