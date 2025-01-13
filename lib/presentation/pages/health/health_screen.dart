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
              Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      "assets/img/Logo.png",
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Sức khỏe của tôi",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                      onPressed: () {
                        _showAccountDialog(context);
                      },
                      icon: Icon(
                        color: AppColors.textPrimary,
                        Icons.autorenew_rounded,
                        size: 28,
                      ))
                ],
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

void _showAccountDialog(BuildContext context) {
  final List<Map<String, dynamic>> users = [
    {"id": 1, "name": "User 1"},
    {"id": 2, "name": "User 2"},
    {"id": 3, "name": "User 3"},
  ];

  const int currentUserId = 2;
  showDialog(
    barrierColor: AppColors.secondaryColor.withOpacity(0.95),
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(20),
        backgroundColor: AppColors.bgColor,
        title: const Text(
          "Hỗ trợ từ người thân",
          style:
              TextStyle(fontSize: 40, fontWeight: FontWeight.w600, height: 1.2),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Chọn một người để xem hoặc thêm mới",
                style: TextStyle(
                    color: AppColors.grayColor5, fontSize: 20, height: 1.2),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Flexible(
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length + 1,
                    itemBuilder: (context, index) {
                      if (index == users.length) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.borderColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.primaryColor,
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                            title: const Text(
                              "Thêm người mới",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      }

                      final user = users[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: user['id'] == currentUserId
                                ? AppColors.primaryColor
                                : AppColors.borderColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 5),
                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 22,
                            child: const Icon(Icons.person),
                          ),
                          title: Text(
                            user['name'],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          trailing: user['id'] == currentUserId
                              ? const Icon(Icons.check_circle_rounded,
                                  color: AppColors.primaryColor)
                              : null,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Đóng",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      );
    },
  );
}
