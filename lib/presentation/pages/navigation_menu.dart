import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sep490/presentation/pages/advise_doctor/home_doctor_advise.dart';
import 'package:sep490/presentation/pages/chat/chat_screen.dart';
import 'package:sep490/presentation/pages/health/health_screen.dart';
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
                icon: SvgPicture.asset('assets/icons/stethoscope.svg', height: 30, width: 30),
                selectedIcon: SvgPicture.asset('assets/icons/stethoscope_selected.svg', height: 30, width: 30),
                label: "Tư vấn",
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
