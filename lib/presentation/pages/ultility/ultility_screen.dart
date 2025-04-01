import 'package:flutter/material.dart';
import 'package:sep490/features/exercies/screens/home_exercise_screen.dart';
import 'package:sep490/features/music/screens/home_music_screen.dart';
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

  @override
  void initState() {
    super.initState();
    utilities = _createUtilitiesList();
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
        "title": "Tra cứu bệnh",
        "color1": Colors.green,
        "color2": Colors.teal,
        "image": "assets/img/tra_cuu.webp",
        "subtitle": "Tìm hiểu thông tin về các bệnh và cách phòng tránh.",
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
        title: const Text('Tiện ích'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              for (int i = 0; i < utilities.length; i++) ...[
                GestureDetector(
                  onTap: () {
                    if (i == 0) {
                      _navigateWithAnimation(i, const GameCardScreen());
                    } else if (i == 2) {
                      // Index 2 là mục "Tập luyện"
                      _navigateWithAnimation(i, HomeExerciseScreen());
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
        ),
      ),
    );
  }
}
