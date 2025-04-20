import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/exercies/screens/home_exercise_screen.dart';
import 'package:sep490/features/music/screens/home_music_screen.dart';
import 'package:sep490/features/reading_book/screens/home_reading_book_screen.dart';
import 'package:sep490/presentation/pages/advise_doctor/controllers/doctor_controller.dart';
import 'package:sep490/presentation/pages/ultility/game/screens/game_card_screen.dart';
import 'package:sep490/presentation/pages/ultility/game/widgets/full_width_game_card.dart';
import 'package:sep490/theme/color.dart';

class UltilityScreen extends StatefulWidget {
  const UltilityScreen({super.key});

  @override
  State<UltilityScreen> createState() => _UltilityScreenState();
}

class _UltilityScreenState extends State<UltilityScreen> {
  late List<Map<String, dynamic>> utilities;
  bool isPackage = false;
  bool isLoading = false;
  int accountID = 0;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();

  @override
  void initState() {
    super.initState();
    utilities = _createUtilitiesList();
    accountID = sharedPrefsHelper.getInt('accountId') ?? 0;
    getPackageUser();
  }

  void getPackageUser() async {
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.getPackageUser(accountID);
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        isPackage = doctorController.packageData != null;
        isLoading = false;
      });
    });
  }

  List<Map<String, dynamic>> _createUtilitiesList() {
    return [
      {
        "title": "Chơi trò chơi",
        "color1": Colors.orange,
        "color2": Colors.deepOrange,
        "image": "assets/img/game_3.webp",
        "subtitle": "Thử thách bản thân với những trò chơi hấp dẫn!",
      },
      {
        "title": "Đọc sách",
        "color1": Colors.purple,
        "color2": Colors.deepPurple,
        "image": "assets/img/docsach.png",
        "subtitle": "Khám phá những cuốn sách hay và bổ ích.",
      },
      {
        "title": "Tập luyện",
        "color1": Colors.blue,
        "color2": Colors.lightBlueAccent,
        "image": "assets/img/tapluyen.png",
        "subtitle": "Giữ gìn sức khỏe với các bài tập luyện hiệu quả.",
      },
      {
        "title": "Âm nhạc",
        "color1": Colors.pink,
        "color2": Colors.pinkAccent,
        "image": "assets/img/am_nhac.webp",
        "subtitle": "Thư giãn với những bản nhạc hay và tận hưởng cuộc sống.",
      },
    ];
  }

  final List<Map<String, dynamic>> premiumUtilities = [
    {
      "title": "Trò chơi giải trí",
      "color1": Colors.orange,
      "color2": Colors.deepOrange,
      "image": "assets/img/game_3.webp",
      "subtitle": "15+ trò chơi thú vị giúp giảm căng thẳng",
      "icon": Icons.videogame_asset_rounded,
      "features": [
        "Giải tỏa stress hiệu quả",
        "Rèn luyện trí não",
        "Tích điểm đổi quà"
      ]
    },
    {
      "title": "Thư viện sách",
      "color1": Colors.purple,
      "color2": Colors.deepPurple,
      "image": "assets/img/docsach.png",
      "subtitle": "1000+ đầu sách tâm lý, phát triển bản thân",
      "icon": Icons.menu_book_rounded,
      "features": [
        "Sách chuyên ngành tâm lý",
        "Sách self-help chất lượng",
        "Đọc mọi lúc, mọi nơi"
      ]
    },
    {
      "title": "Bài tập tại nhà",
      "color1": Colors.blue,
      "color2": Colors.lightBlueAccent,
      "image": "assets/img/tapluyen.png",
      "subtitle": "30+ bài tập thể chất và tinh thần",
      "icon": Icons.fitness_center_rounded,
      "features": [
        "Yoga, thiền, thể dục",
        "Lộ trình cá nhân hóa",
        "Theo dõi tiến độ"
      ]
    },
    {
      "title": "Âm nhạc trị liệu",
      "color1": Colors.pink,
      "color2": Colors.pinkAccent,
      "image": "assets/img/am_nhac.webp",
      "subtitle": "50+ playlist được thiết kế bởi chuyên gia",
      "icon": Icons.music_note_rounded,
      "features": [
        "Nhạc ngủ, nhạc thiền",
        "Giảm lo âu, trầm cảm",
        "Tạo tâm trạng tích cực"
      ]
    },
  ];

  void _navigateWithAnimation(int index, Widget nextScreen) {
    // Hiển thị ảnh phóng to trung tâm
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white,
      pageBuilder: (context, animation1, animation2) {
        return Center(
          child: Hero(
            tag: 'utility_image_${utilities[index]['title']}',
            child: Material(
              type: MaterialType.transparency,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation1,
                  curve: Curves.fastOutSlowIn,
                ),
                child: Image.asset(
                  utilities[index]['image'],
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
            ),
          ),
        );
      },
    );

    // Sau khi phóng to, chuyển sang màn hình mới
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pop(); // Đóng dialog
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
                child: child,
              ),
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: AppColors.bgColor,
          title: const Text('Tiện ích', style: TextStyle(fontSize: 30, color: AppColors.secondaryColor, fontWeight: FontWeight.w600)),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? Center(
                  child: GifView.asset(
                    'assets/gif/search_box.gif',
                    width: 100,
                    height: 100,
                    frameRate: 60,
                  ),
                )
              : isPackage
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          for (int i = 0; i < utilities.length; i++) ...[
                            GestureDetector(
                              onTap: () {
                                if (i == 0) {
                                  _navigateWithAnimation(
                                      i, const GameCardScreen());
                                } else if (i == 1) {
                                  // Index 2 là mục "Tập luyện"
                                  _navigateWithAnimation(
                                      i, HomeReadingBookScreen());
                                } else if (i == 2) {
                                  // Index 2 là mục "Tập luyện"
                                  _navigateWithAnimation(
                                      i, HomeExerciseScreen());
                                } else if (i == utilities.length - 1) {
                                  _navigateWithAnimation(i, HomeMusicScreen());
                                }
                              },
                              child: Hero(
                                tag: 'utility_image_${utilities[i]['title']}',
                                child: FullWidthGameCard(
                                  title: utilities[i]['title'],
                                  color1: utilities[i]['color1'],
                                  color2: utilities[i]['color2'],
                                  imagePath: utilities[i]['image'],
                                  subtitle: utilities[i]['subtitle'],
                                ),
                              ),
                            ),
                            const SizedBox(height: 36),
                          ],
                        ],
                      ),
                    )
                  : _buildPremiumUpsell(),
        ));
  }

  Widget _buildPremiumUpsell() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade500, Colors.greenAccent.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  'NÂNG CẤP GÓI',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Hãy liên hệ người thân nhờ hỗ trợ nâng cấp gói ngay để mở khóa toàn bộ tiện ích hỗ trợ sức khỏe tinh thần',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // Features Preview
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Bạn sẽ nhận được:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...premiumUtilities.map((utility) => _buildUtilityCard(
                      premiumUtilities.indexOf(utility),
                      false,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUtilityCard(int index, bool isUnlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                premiumUtilities[index]['color1'],
                premiumUtilities[index]['color2'],
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                premiumUtilities[index]['icon'],
                size:40,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    premiumUtilities[index]['title'],
                    style: const TextStyle(
                      fontSize:25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      premiumUtilities[index]['subtitle'],
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
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
