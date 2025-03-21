import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 10, // 5 items + 2 labels
        itemBuilder: (context, index) {
          if (index == 0 || index == 4 || index == 8) {
            // Label giả ở đầu nhóm
            return TweenAnimationBuilder(
              tween: Tween<Offset>(
                begin: const Offset(0, 0.8), // Bắt đầu thấp hơn một chút
                end: const Offset(0, 0), // Dịch chuyển lên
              ),
              duration:
                  Duration(milliseconds: 500 + (index * 100)), // Delay dần
              curve: Curves.fastLinearToSlowEaseIn,
              builder: (context, Offset offset, child) {
                return Transform.translate(
                  offset: offset * MediaQuery.of(context).size.height,
                  child: Opacity(
                    opacity: (1 - offset.dy), // Hiệu ứng mờ dần
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Align(
                  alignment: Alignment.centerLeft, // Giữ label ngắn
                  child: Shimmer.fromColors(
                    baseColor: Color.fromARGB(255, 241, 236, 250),
                    highlightColor: Colors.white,
                    child: SizedBox(
                      width: 130, // Nhãn giả ngắn lại
                      child: Container(
                        height: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return TweenAnimationBuilder(
            tween: Tween<Offset>(
              begin: const Offset(0, 0.8), // Bắt đầu thấp hơn
              end: const Offset(0, 0), // Di chuyển về vị trí bình thường
            ),
            duration:
                Duration(milliseconds: 500 + (index * 100)), // Delay từng item
            curve: Curves.fastLinearToSlowEaseIn,
            builder: (context, Offset offset, child) {
              return Transform.translate(
                offset: offset * MediaQuery.of(context).size.height,
                child: Opacity(
                  opacity: (1 - offset.dy), // Làm mờ dần
                  child: child,
                ),
              );
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Shimmer.fromColors(
                baseColor: Color.fromARGB(255, 241, 236, 250),
                highlightColor: Colors.white,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        // Hình ảnh giả
                        Container(
                          width: 50,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tiêu đề giả
                              Container(
                                width: double.infinity,
                                height: 15,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              // Dữ liệu giả
                              Container(
                                width: 100,
                                height: 15,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Biểu tượng mũi tên giả
                        Container(
                          width: 20,
                          height: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
