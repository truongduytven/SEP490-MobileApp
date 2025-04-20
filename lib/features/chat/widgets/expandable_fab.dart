import 'package:flutter/material.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/group/screens/create_group_screen.dart';
import 'package:sep490/features/select_contacts_friend/screens/select_contacts_screen.dart';
import 'package:sep490/theme/color.dart';

class ExpandableFab extends StatefulWidget {
  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  bool _isExpanded = false;

  void _toggleFab() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
    final currentUserRoleId = sharedPrefsHelper.getInt("roleId");
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Background overlay when expanded
        if (_isExpanded)
          GestureDetector(
            onTap: _toggleFab,
            child: Container(
              color: Colors.black.withOpacity(0),
              width: double.infinity,
              height: double.infinity,
            ),
          ),

        // Floating buttons
        AnimatedPositioned(
          duration: Duration(milliseconds: 200),
          bottom: _isExpanded ? 90 : 20,
          right: 20,
          child: Visibility(
            visible: _isExpanded,
            child: FloatingActionButton.extended(
              heroTag: "btn1",
              onPressed: () {
                // Handle Add People action
                print("Add People Clicked");

                Navigator.pushNamed(context, SelectContactsScreen.routeName);

                _toggleFab();
              },
              backgroundColor: AppColors.primaryColor,
              icon: Icon(Icons.person_add, color: Colors.white),
              label: Text(
                "Thêm bạn",
                style: TextStyle(color: AppColors.bgColor),
              ),
            ),
          ),
        ),
        if (currentUserRoleId == 3)
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            bottom: _isExpanded ? 150 : 20,
            right: 20,
            child: Visibility(
              visible: _isExpanded,
              child: FloatingActionButton.extended(
                heroTag: "btn2",
                // onPressed: () {
                //   // Handle Add Group action
                //   print("Add Group Clicked");
                //   _toggleFab();
                // },
                onPressed: () {
                  // Navigate to CreateGroupScreen
                  Navigator.pushNamed(
                    context,
                    CreateGroupScreen.routeName,
                  ).then((_) {
                    _toggleFab(); // Close FAB after returning from the screen
                  });
                },
                backgroundColor: AppColors.primaryColor,
                icon: Icon(Icons.group_add, color: Colors.white),
                label: Text(
                  "Thêm nhóm",
                  style: TextStyle(color: AppColors.bgColor),
                ),
              ),
            ),
          ),

        // Main Floating Action Button
        FloatingActionButton(
          heroTag: "mainFab",
          onPressed: _toggleFab,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // More circular
          ),
          elevation: 10,
          mini: false,
          backgroundColor: AppColors.primaryColor,
          child: Icon(
            _isExpanded ? Icons.close : Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
