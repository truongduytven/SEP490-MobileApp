import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sep490/theme/color.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.bgColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Shimmer.fromColors(
                  baseColor: Color.fromARGB(255, 243, 240, 248),
                  highlightColor: Colors.white,
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Shimmer.fromColors(
                  baseColor: Color.fromARGB(255, 243, 240, 248),
                  highlightColor: Colors.white,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors
                          .white, // Đặt màu ở đây thay vì thuộc tính `color`
                      borderRadius: BorderRadius.circular(8), // Bo tròn góc
                    ),
                  ),
                ),
                const SizedBox(width: 70),
                Shimmer.fromColors(
                  baseColor: Color.fromARGB(255, 243, 240, 248),
                  highlightColor: Colors.white,
                  child: Container(
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              child: Divider(
                thickness: 0.1,
                color: AppColors.secondaryColor,
                height: 16,
              ),
            ),
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 243, 240, 248),
                        highlightColor: Colors.white,
                        child: Container(
                          width: 120,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors
                                .white, // Đặt màu ở đây thay vì thuộc tính `color`
                            borderRadius:
                                BorderRadius.circular(8), // Bo tròn góc
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 243, 240, 248),
                        highlightColor: Colors.white,
                        child: Container(
                          width: 80,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white, // Đặt màu trong BoxDecoration
                            borderRadius:
                                BorderRadius.circular(8), // Bo tròn góc
                          ),
                        ),
                      ),
                    ],
                  ),
                  Shimmer.fromColors(
                    baseColor: Color.fromARGB(255, 243, 240, 248),
                    highlightColor: Colors.white,
                    child: Container(
                      width: 80,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white, // Đặt màu tại đây
                        borderRadius: BorderRadius.circular(8), // Bo tròn góc
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
