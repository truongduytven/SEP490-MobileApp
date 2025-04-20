import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HealthCardSkeleton extends StatelessWidget {
  const HealthCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Color.fromARGB(255, 243, 240, 248),
            highlightColor: Colors.white,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
            ),
          ),
          const SizedBox(height: 8),
          Shimmer.fromColors(
            baseColor: Color.fromARGB(255, 243, 240, 248),
            highlightColor: Colors.white,
            child: Container(
              width: 60,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Shimmer.fromColors(
            baseColor: Color.fromARGB(255, 243, 240, 248),
            highlightColor: Colors.white,
            child: Container(
              width: 80,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
