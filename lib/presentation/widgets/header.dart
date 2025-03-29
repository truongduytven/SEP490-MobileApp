import 'package:flutter/material.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/presentation/pages/home/group_member_screen.dart';
import 'package:sep490/presentation/pages/home/profile_screen.dart';
import 'package:sep490/presentation/pages/notification/notification_screen.dart';
import 'package:sep490/features/health/widgets/health_floating_action_button.dart';
import 'package:sep490/theme/color.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  late String fullName = SharedPrefsHelper().getString('fullName') ?? '';
  late String avatar = SharedPrefsHelper().getString('avatar') ??
      'https://i.pinimg.com/736x/8f/1c/a2/8f1ca2029e2efceebd22fa05cca423d7.jpg';

  // @override
  // void initState() {
  //   super.initState();
  //   _getDataUser();
  // }

  // void _getDataUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     fullName = prefs.getString('fullName') ?? '';
  //     avatar = prefs.getString('avatar') ?? '';
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        }
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: Row(
                children: [
                  Stack(children: [
                    ClipOval(
                      child: Image.network(
                        avatar,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors
                              .white, // Background color for better visibility
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.format_list_bulleted,
                          size: 12,
                          color: AppColors
                              .textColor, // Adjust color based on theme
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Xin chào",
                        style:
                            TextStyle(color: AppColors.textColor, fontSize: 18),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          fullName,
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.grayColor2,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GroupMemberScreen()),
                          );
                        },
                        icon: Icon(
                          Icons.group,
                          color: AppColors.textColor,
                          size: 20,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.grayColor2,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationScreen()),
                        );
                      },
                      icon: Image.asset(
                        "assets/img/notification_active.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
                HealthFloatingActionButton(isDialOpen: isDialOpen),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
