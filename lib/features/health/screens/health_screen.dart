import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/health/controller/health_controller.dart';
import 'package:sep490/main.dart';
import 'package:sep490/features/health/screens/health_monitoring_book.dart';
import 'package:sep490/presentation/widgets/header.dart';
import 'package:sep490/features/health/widgets/card.dart';
import 'package:sep490/features/health/widgets/skeleton_card.dart';
import 'package:sep490/theme/color.dart';

class HealthScreen extends ConsumerStatefulWidget {
  const HealthScreen({super.key});

  @override
  ConsumerState<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends ConsumerState<HealthScreen>
    with RouteAware, WidgetsBindingObserver {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> dataFromApi = [];
  bool isLoading = false;
  late int accountId = 0;
  late int roleId = 0;
  late int selectedElderlyUserId = 0;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();

  @override
  void initState() {
    super.initState();
    accountId = sharedPrefsHelper.getInt("accountId") ?? 0;
    roleId = sharedPrefsHelper.getInt("roleId") ?? 0;
    selectedElderlyUserId =
        sharedPrefsHelper.getInt("selectedElderlyUserId") ?? 0;
    fetchHealthIndicator();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // Xóa observer khi widget bị hủy
    routeObserver.unsubscribe(this); // Hủy đăng ký RouteAware khi widget bị hủy
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Đăng ký RouteAware để theo dõi sự kiện navigation
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      // Kiểm tra xem route có phải là PageRoute không
      routeObserver.subscribe(this,
          route as PageRoute<dynamic>); // Ép kiểu thành PageRoute<dynamic>
    }
  }

  @override
  void didPopNext() {
    // Khi màn hình này được hiển thị lại sau khi pop từ màn hình khác
    fetchHealthIndicator(); // Gọi lại API
  }

  Future<void> fetchHealthIndicator() async {
    setState(() {
      isLoading = true;
    });

    final int currentUserAccountID;
    if (roleId == 2) {
      currentUserAccountID = accountId;
    } else {
      currentUserAccountID = selectedElderlyUserId;
    } 

    final healthController = ref.read(healthControllerProvider);

    try {
      final result = await healthController.getHealthIndicators(
        context,
        currentUserAccountID,
      );

      final formattedData = formatApiData(result);
      setState(() {
        dataFromApi = formattedData;
      });
    } catch (e) {
      print("Error fetching health indicators: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, String>> formatApiData(List<Map<String, dynamic>> apiData) {
    final Map<String, Map<String, String>> extraInfo = {
      "Height": {
        "title": "Chiều cao",
        "imageUrl": "assets/img3D/chieucao.png",
        "unit": "cm",
        "average": "So với lần đo trước",
      },
      "Weight": {
        "title": "Cân nặng",
        "imageUrl": "assets/img3D/cannang.png",
        "unit": "kg",
        "average": "So với lần đo trước",
      },
      "HeartRate": {
        "title": "Nhịp tim",
        "imageUrl": "assets/img3D/nhiptim.png",
        "unit": "BMP",
        "average": "Trung bình trong 30 ngày",
      },
      "BloodPressure": {
        "title": "Huyết áp",
        "imageUrl": "assets/img3D/huyetap.png",
        "unit": "mmHg",
        "average": "Trung bình trong 30 ngày",
      },
      "LipidProfile": {
        "title": "Mỡ máu",
        "imageUrl": "assets/img3D/treatment_medical/momau.webp",
        "unit": "mmol/L",
        "average": "So với lần đo trước",
      },
      "LiverEnzyme": {
        "title": "Men gan",
        "imageUrl": "assets/img3D/treatment_medical/gan.png",
        "unit": "UI/L",
        "average": "So với lần đo trước",
      },
      "BloodGlucose": {
        "title": "Đường huyết",
        "imageUrl": "assets/img3D/treatment_medical/tieuduong.png",
        "unit": "mmol/L",
        "average": "So với lần đo trước",
      },
      "KidneyFunction": {
        "title": "Chức năng thận",
        "imageUrl": "assets/img3D/treatment_medical/than.png",
        "unit": "mL/phút/1.73m2",
        "average": "So với lần đo trước",
      },
    };

    return apiData.map((item) {
      final String originalTitle = item["tabs"].toString();
      final Map<String, String> info = extraInfo[originalTitle] ??
          {
            "title": originalTitle,
            "imageUrl": "assets/img3D/default.png",
            "unit": "Không có",
            "average": "Không có",
          };

      return {
        "title": info["title"]!,
        "imageUrl": info["imageUrl"] ?? "assets/img3D/default.png",
        "unit": info["unit"]!,
        "average": info["average"]!,
        "result": item["evaluation"].toString(),
        "dateTime": item["dateTime"].toString(),
        "data": item["indicator"].toString(),
        "dataAverage": item["averageIndicator"].toString(),
      };
    }).toList();
  }

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
        body: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/background_app.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(),
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
                    Text(
                      "Sức khỏe của tôi",
                      style:
                          const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
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
                  child: isLoading
                      ? SingleChildScrollView(
                          child: Column(
                            children: List.generate(5, (index) {
                              return TweenAnimationBuilder(
                                tween: Tween<Offset>(
                                  begin: const Offset(0, 0.8),
                                  end: const Offset(0, 0),
                                ),
                                duration:
                                    Duration(milliseconds: 550 + (index * 300)),
                                curve: Curves.fastLinearToSlowEaseIn,
                                builder: (context, Offset offset, child) {
                                  return Transform.translate(
                                    offset: offset *
                                        MediaQuery.of(context).size.height,
                                    child: Opacity(
                                      opacity: (1 - offset.dy),
                                      child: child,
                                    ),
                                  );
                                },
                                child: SkeletonCard(),
                              );
                            }),
                          ),
                        )
                      : ListView.separated(
                          controller: _scrollController,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemCount: dataFromApi.length + 1,
                          itemBuilder: (context, index) {
                            if (index == dataFromApi.length) {
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 4),
                                color: AppColors.bgColor,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  // side: const BorderSide(
                                  //     color: AppColors.secondaryColor, width: 0.1),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HealthMonitoringBook(
                                                      initialTopic: "all",
                                                    )),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(18),
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
                            final item = dataFromApi[index];

                            return TweenAnimationBuilder(
                              tween: Tween<Offset>(
                                begin: const Offset(
                                    0, 0.8), // Start slightly below
                                end: const Offset(
                                    0, 0), // Move to normal position
                              ),
                              duration: Duration(
                                  milliseconds: 550 +
                                      (index * 300)), // Add delay per item
                              curve: Curves.fastLinearToSlowEaseIn,
                              builder: (context, Offset offset, child) {
                                return Transform.translate(
                                  offset: offset *
                                      MediaQuery.of(context).size.height,
                                  child: Opacity(
                                    opacity: (1 - offset.dy), // Fade effect
                                    child: child,
                                  ),
                                );
                              },
                              child: InfoCard(
                                title: item['title']!,
                                imageUrl: item['imageUrl']!,
                                result: item['result']!,
                                dateTime: item['dateTime']!,
                                data: item['data']!,
                                unit: item['unit']!,
                                average: item['average']!,
                                dataAverage: item['dataAverage']!,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
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
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.transparent,
                              child: const Icon(Icons.person_add_alt_1_outlined,
                                  color: AppColors.primaryColor),
                            ),
                            title: const Text(
                              "Thêm người mới",
                              style: TextStyle(fontSize: 20),
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
                              color: user['id'] == currentUserId
                                  ? AppColors.primaryColor
                                  : AppColors.textColor,
                              fontWeight: user['id'] == currentUserId
                                  ? FontWeight.w600
                                  : null,
                              fontSize: 20,
                            ),
                          ),
                          trailing: user['id'] == currentUserId
                              ? const Icon(Icons.check_circle_rounded,
                                  size: 28, color: AppColors.primaryColor)
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
