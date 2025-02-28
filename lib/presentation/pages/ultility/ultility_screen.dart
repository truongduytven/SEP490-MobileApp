import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/ultility/screens/game_card_screen.dart';
import 'package:sep490/presentation/pages/ultility/widgets/full_width_game_card.dart';

class UltilityScreen extends StatefulWidget {
  const UltilityScreen({super.key});

  @override
  State<UltilityScreen> createState() => _UltilityScreenState();
}

class _UltilityScreenState extends State<UltilityScreen> {
  void _navigateToGameCardScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameCardScreen()),
    );
  }

  final List<Map<String, dynamic>> utilities = [
    {
      "title": "Chơi trò chơi",
      "color1": Colors.orange,
      "color2": Colors.deepOrange,
      "image": "assets/img/game_3.webp",
      "subtitle": "Thử thách bản thân với những trò chơi hấp dẫn!",
      "onTap": () => {}, // Placeholder for other games
    },
    {
      "title": "Đọc sách",
      "color1": Colors.purple,
      "color2": Colors.deepPurple,
      "image": "assets/img/reading_book_2.webp",
      "subtitle": "Khám phá những cuốn sách hay và bổ ích.",
      "onTap": () => {},
    },
    {
      "title": "Tập luyện",
      "color1": Colors.blue,
      "color2": Colors.lightBlueAccent,
      "image": "assets/img/tapluyen.webp",
      "subtitle": "Giữ gìn sức khỏe với các bài tập luyện hiệu quả.",
      "onTap": () => {},
    },
    {
      "title": "Tra cứu bệnh",
      "color1": Colors.green,
      "color2": Colors.teal,
      "image": "assets/img/tra_cuu.webp",
      "subtitle": "Tìm hiểu thông tin về các bệnh và cách phòng tránh.",
      "onTap": () => {},
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiện ích'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              for (int i = 0; i < utilities.length; i++) ...[
                GestureDetector(
                  onTap: i == 0
                      ? _navigateToGameCardScreen
                      : utilities[i]['onTap'],
                  child: FullWidthGameCard(
                    title: utilities[i]['title'],
                    color1: utilities[i]['color1'],
                    color2: utilities[i]['color2'],
                    imagePath: utilities[i]['image'],
                    subtitle: utilities[i]['subtitle'],
                  ),
                ),
                const SizedBox(height: 26), // Space between cards
              ],
            ],
          ),
        ),
      ),
    );
  }
}

//   Widget _buildCard(String title, IconData icon, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 50, color: Colors.blue),
//             const SizedBox(height: 10),
//             Text(title,
//                 style:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }
// }
