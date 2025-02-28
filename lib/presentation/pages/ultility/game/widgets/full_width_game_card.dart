import 'package:flutter/material.dart';

class FullWidthGameCard extends StatelessWidget {
  final String title;
  final Color color1;
  final Color color2;
  final String imagePath;
  final String subtitle;
  const FullWidthGameCard({
    super.key,
    required this.title,
    required this.color1,
    required this.color2,
    required this.imagePath,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Full width
      height: 180, // Taller than other cards
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color1, color2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(
                          height: 8), // Space between title and subtitle
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white70, // Lighter color for subtitle
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2, // Allow more space for subtitle
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -50,
            top: -50,
            child: Image.asset(
              imagePath,
              width: 240,
              height: 240,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
