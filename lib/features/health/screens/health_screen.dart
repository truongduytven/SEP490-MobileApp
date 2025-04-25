import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_view/gif_view.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/group_family/screens/group_family.dart';
import 'package:sep490/features/health/controller/health_controller.dart';
import 'package:sep490/main.dart';
import 'package:sep490/features/health/screens/health_monitoring_book.dart';
import 'package:sep490/models/home_model.dart';
import 'package:sep490/presentation/pages/home/controller/home_controller.dart';
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
    with RouteAware, WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> dataFromApi = [];
  bool isLoading = false;
  late int accountId = 0;
  late int roleId = 0;
  late int selectedElderlyUserId = 0;
  late String selectedElderlyUserName = "";
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  bool isLoadingDialog = false;
  bool isShowSelectUser = false;
  late List<ElderlyUser>? userList = null;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    accountId = sharedPrefsHelper.getInt("accountId") ?? 0;
    roleId = sharedPrefsHelper.getInt("roleId") ?? 0;
    selectedElderlyUserId =
        sharedPrefsHelper.getInt("selectedElderlyUserId") ?? 0;
    selectedElderlyUserName =
        sharedPrefsHelper.getString("selectedElderlyUserName") ?? "";
    fetchHealthIndicator();
    if (roleId == 3) {
      getElderlyUser();
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    WidgetsBinding.instance
        .removeObserver(this); // Xóa observer khi widget bị hủy
    routeObserver.unsubscribe(this); // Hủy đăng ký RouteAware khi widget bị hủy
    super.dispose();
  }

  // Thêm biến để lưu vị trí scroll
  double _savedScrollPosition = 0.0;

  // Sửa hàm navigate để lưu vị trí scroll
  void _navigateToHealthBook() {
    _savedScrollPosition = _scrollController.position.pixels;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HealthMonitoringBook(initialTopic: "all"),
      ),
    ).then((_) {
      // Khi quay lại, khôi phục vị trí scroll
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_savedScrollPosition);
        }
      });
    });
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
    if (roleId != 2 && selectedElderlyUserId == 0) {
      return;
    }
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
      "BloodOxygen": {
        "title": "Oxy trong máu",
        "imageUrl": "assets/img3D/oxy_mau.png",
        "unit": "%",
        "average": "So với lần đo trước",
      },
      "FootStep": {
        "title": "Số bước chân",
        "imageUrl": "assets/img3D/buoc_chan.png",
        "unit": "bước",
        "average": "So với lần đo trước",
      },
      "SleepTime": {
        "title": "Thời gian ngủ",
        "imageUrl": "assets/img3D/giac_ngu.png",
        "unit": "phút",
        "average": "So với lần đo trước",
      },
      "CaloriesConsumption": {
        "title": "Lượng calo tiêu thụ",
        "imageUrl": "assets/img3D/kcal.png",
        "unit": "kcal",
        "average": "So với lần đo trước",
      },
    };

    return apiData.map((item) {
      final String originalTitle = item["tabs"].toString();
      final Map<String, String> info = extraInfo[originalTitle] ??
          {
            "title": originalTitle,
            "imageUrl": "assets/img/default_avatar.png",
            "unit": "Không có",
            "average": "Không có",
          };

      return {
        "title": info["title"]!,
        "imageUrl": info["imageUrl"] ?? "assets/img/default_avatar.png",
        "unit": info["unit"]!,
        "average": info["average"]!,
        "result": item["evaluation"].toString() == "N/A"
            ? "Bình thường"
            : item["evaluation"].toString(),
        "dateTime": item["dateTime"].toString(),
        "data": item["indicator"].toString(),
        "dataAverage": item["averageIndicator"].toString(),
      };
    }).toList();
  }

  void getElderlyUser() async {
    setState(() {
      isLoadingDialog = true;
    });
    HomeController homeController = HomeController();
    await homeController.getElderlyUser(accountId);
    if (!mounted) return;
    setState(() {
      isLoadingDialog = false;
      userList = homeController.elderlyUsers;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userList == null) {
        return;
      }
      if (sharedPrefsHelper.getInt('selectedElderlyUserId') != null) {
        return;
      }
      if (userList!.isNotEmpty && selectedElderlyUserId == 0) {
        selectedElderlyUserId = userList![0].accountId;
        selectedElderlyUserName = userList![0].fullName;
        sharedPrefsHelper.setInt(
            'selectedElderlyUserId', userList![0].accountId);
        sharedPrefsHelper.setString(
            'selectedElderlyUserName', userList![0].fullName);
        sharedPrefsHelper.setInt('selectedElderlyId', userList![0].elderlyId);
      }
    });
  }

  void _showSelectDialog() {
    showDialog(
      barrierColor: AppColors.secondaryColor.withOpacity(0.95),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(20),
          backgroundColor: AppColors.bgColor,
          title: const Text(
            "Hỗ trợ từ người thân",
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w600, height: 1.2),
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
                      color: AppColors.grayColor5, fontSize: 16, height: 1.2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: SizedBox(
                    height: 300,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: userList!.length,
                      itemBuilder: (context, index) {
                        final user = userList![index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedElderlyUserId =
                                  userList![index].accountId;
                              selectedElderlyUserName =
                                  userList![index].fullName;
                            });
                            sharedPrefsHelper.setInt('selectedElderlyUserId',
                                userList![index].accountId);
                            sharedPrefsHelper.setString(
                                'selectedElderlyUserName',
                                userList![index].fullName);
                            sharedPrefsHelper.setInt('selectedElderlyId',
                                userList![index].elderlyId);
                            CherryToast.success(
                              toastDuration: Duration(seconds: 3),
                              title: Text(
                                'Bạn đang hỗ trợ ${userList![index].fullName}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ).show(context);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: user.accountId == selectedElderlyUserId
                                    ? AppColors.primaryColor
                                    : AppColors.borderColor,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  user.avatar,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: user.accountId ==
                                              selectedElderlyUserId
                                          ? AppColors.primaryColor
                                          : AppColors.textColor,
                                      fontWeight: user.accountId ==
                                              selectedElderlyUserId
                                          ? FontWeight.w600
                                          : null,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    user.phoneNumber,
                                    style: TextStyle(
                                      color: AppColors.grayColor3,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: user.accountId == selectedElderlyUserId
                                  ? const Icon(Icons.check_circle_rounded,
                                      size: 28, color: AppColors.primaryColor)
                                  : null,
                            ),
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
        appBar: roleId == 4
            ? AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: AppColors.bgColor,
                elevation: 0,
                scrolledUnderElevation: 0,
              )
            : null,
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
          child: roleId != 2 && selectedElderlyUserId == 0
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GifView.asset(
                          'assets/gif/family.gif',
                          width: 150,
                          height: 150,
                          frameRate: 60,
                        ),
                        Text(
                          "Hiện tại chưa có người thân trong nhóm gia đình, vui lòng thêm người thân để có thể theo dõi sức khỏe của họ.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 22,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const GroupFamily()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              )),
                          child: const Text(
                            "Nhóm gia đình",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (roleId != 4)
                        Header(
                          isChooseElderly: false,
                        ),
                      if (roleId != 4) const SizedBox(height: 20),
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
                          Expanded(
                            child: Text(
                              "Sức khỏe của ${selectedElderlyUserName != "" ? selectedElderlyUserName : "tôi"}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.w600),
                            ),
                          ),
                          if (userList != null &&
                              userList!.isNotEmpty &&
                              roleId == 3)
                            IconButton(
                                onPressed: () {
                                  _showSelectDialog();
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
                                      duration: Duration(
                                          milliseconds: 550 + (index * 300)),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      builder: (context, Offset offset, child) {
                                        return Transform.translate(
                                          offset: offset *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
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
                                key: const PageStorageKey<String>(
                                    'healthScrollPosition'),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                                itemCount: dataFromApi.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == dataFromApi.length) {
                                    return GestureDetector(
                                      // onTap: () {
                                      //   Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             HealthMonitoringBook(
                                      //               initialTopic: "all",
                                      //             )),
                                      //   );
                                      // },
                                      onTap: _navigateToHealthBook,
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 4),
                                        color: AppColors.bgColor,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          // side: const BorderSide(
                                          //     color: AppColors.secondaryColor, width: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [
                                                      Text(
                                                        'Sổ theo dõi',
                                                        style: TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                            (index *
                                                300)), // Add delay per item
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    builder: (context, Offset offset, child) {
                                      return Transform.translate(
                                        offset: offset *
                                            MediaQuery.of(context).size.height,
                                        child: Opacity(
                                          opacity:
                                              (1 - offset.dy), // Fade effect
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
