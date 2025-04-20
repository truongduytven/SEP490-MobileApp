import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ScheduleCarouselSkeleton extends StatelessWidget {
  const ScheduleCarouselSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: double.infinity, // Tăng chiều cao
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        viewportFraction: 0.85,
        enableInfiniteScroll: false,
      ),
      items: List.generate(3, (index) {
        return Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Material(
                elevation: 4,
                shadowColor: AppColors.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Shimmer.fromColors(
                    baseColor: Color.fromARGB(255, 243, 240, 248),
                    highlightColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header section - làm nổi bật hơn
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[350], // Màu đậm hơn
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Status indicator
                                Container(
                                  width: 100,
                                  height: 20,
                                  color: Colors.grey[400],
                                ),
                                // Date indicator
                                Container(
                                  width: 120,
                                  height: 20,
                                  color: Colors.grey[400],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Content section - làm rõ ràng hơn
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon với borderRadius
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(
                                      8), // Thêm borderRadius cho icon
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Schedule content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title với borderRadius
                                    Container(
                                      width: double.infinity,
                                      height: 20,
                                      margin: const EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),

                                    // Description với borderRadius
                                    Container(
                                      width: double.infinity,
                                      height: 16,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),

                                    // Time and duration với borderRadius
                                    Row(
                                      children: [
                                        // Clock icon
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Time text
                                        Container(
                                          width: 100,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // Duration icon
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
