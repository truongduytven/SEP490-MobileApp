import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/music/screens/home_music_screen.dart';

class NowPlayingBox extends ConsumerWidget {
  final Widget child;

  const NowPlayingBox({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider.notifier).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black54 : Colors.white60, // Màu nền mờ
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // Bóng tối đậm hơn trong dark mode
          BoxShadow(
            color: isDarkMode ? Colors.black87 : Colors.grey.shade400,
            blurRadius: 15,
            offset: Offset(4, 4),
          ),
          // Bóng sáng hơn trong light mode
          BoxShadow(
            color: isDarkMode ? Colors.grey.shade800 : Colors.white,
            blurRadius: 15,
            offset: Offset(-4, -4),
          ),
        ],
        // border: Border.all(
        //   color: isDarkMode ? Colors.white30 : Colors.black26,
        //   width: 1.5,
        // ),
      ),
      padding: EdgeInsets.all(12),
      child: child,
    );
  }
}
