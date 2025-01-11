import 'package:flutter/material.dart';
import 'package:sep490/presentation/widgets/header.dart';
import 'package:sep490/presentation/widgets/health/card.dart';
import 'package:sep490/presentation/widgets/health/health_floating_action_button.dart';
import 'package:sep490/theme/color.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  final ScrollController _scrollController = ScrollController();
  static List<Map<String, String>> listData = [
    {
      "title": "Tuân thủ uống thuốc",
      "imageUrl": "assets/img3D/thuoc.png",
      "result": "Bình Thường",
      "dateTime": "11 th01  12:34",
      "data": "123",
      "unit": "%",
      "average": "Trung bình trong 30 ngày",
      "dataAverage": "120",
    },
    {
      "title": "Huyết Áp",
      "imageUrl": "assets/img3D/huyetap.png",
      "result": "Cao",
      "dateTime": "11 th02  1:34",
      "data": "110/90",
      "unit": "BPM",
      "average": "Trung bình trong 30 ngày",
      "dataAverage": "112/87",
    },
    {
      "title": "Nhịp tim",
      "imageUrl": "assets/img3D/nhiptim.png",
      "result": "Rất Cao",
      "dateTime": "11 th04  12:34",
      "data": "129",
      "unit": "BMP",
      "average": "Trung bình trong 30 ngày",
      "dataAverage": "119",
    },
    {
      "title": "Cân nặng",
      "imageUrl": "assets/img3D/cannang.png",
      "result": "Thấp",
      "dateTime": "1 th02  2:44",
      "data": "45",
      "unit": "kg",
      "average": "So với lần đo trước",
      "dataAverage": "+2",
    },
    {
      "title": "Chiều cao",
      "imageUrl": "assets/img3D/chieucao.png",
      "result": "Bình Thường",
      "dateTime": "19 th08  4:04",
      "data": "170",
      "unit": "cm",
      "average": "So với lần đo trước",
      "dataAverage": "-4",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
              const SizedBox(height: 20),
              const Text(
                "Sức khỏe của tôi",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: listData.length + 1,
                  itemBuilder: (context, index) {
                    if (index == listData.length) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 4),
                        color: AppColors.bgColor,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: AppColors.secondaryColor, width: 0.1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.asset(
                                      'assets/img3D/sotheodoi.png',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Sổ theo dõi',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Xem tất cả số lần đo của bạn.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    final item = listData[index];

                    return InfoCard(
                      title: item['title']!,
                      imageUrl: item['imageUrl']!,
                      result: item['result']!,
                      dateTime: item['dateTime']!,
                      data: item['data']!,
                      unit: item['unit']!,
                      average: item['average']!,
                      dataAverage: item['dataAverage']!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton:
            HealthFloatingActionButton(isDialOpen: isDialOpen),
      ),
    );
  }
}
