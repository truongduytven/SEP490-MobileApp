import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/health/screens/health_monitoring_book.dart';
import 'package:sep490/features/heart_beat/controller/heart_rate_controller.dart';
import 'package:sep490/main.dart';
import 'package:sep490/presentation/widgets/health/chart/line_chart_skeleton.dart';
import 'package:sep490/presentation/widgets/health/chart/line_chart_widget.dart';
import 'package:sep490/features/health/widgets/health_floating_action_button.dart';
import 'package:sep490/theme/color.dart';

class DetailHeartBeatScreen extends ConsumerStatefulWidget {
  const DetailHeartBeatScreen({super.key});

  @override
  ConsumerState<DetailHeartBeatScreen> createState() =>
      _DetailHeartBeatScreenState();
}

class _DetailHeartBeatScreenState extends ConsumerState<DetailHeartBeatScreen>
    with SingleTickerProviderStateMixin, RouteAware, WidgetsBindingObserver {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  late TabController _tabController;

  List<Map<String, dynamic>> dataFromApi = [];
  // Lọc dữ liệu theo từng tab
  Map<String, dynamic>? dataByDate;
  Map<String, dynamic>? dataByWeek;
  Map<String, dynamic>? dataByMonth;
  Map<String, dynamic>? dataByYear;
  // Khai báo biến chartByDate đúng kiểu
  Map<String, double?> chartByDate = {};
  Map<String, double?> chartByWeek = {};
  Map<String, double?> chartByMonth = {};
  Map<String, double?> chartByYear = {};
  bool isLoading = false;
  final List<String> tabs = ['Ngày', 'Tuần', 'Tháng', 'Năm'];
  final Map<String, double?> chartDataDate = {
    "T2": 115,
    "T3": null,
    "T4": 116,
    "T5": 114,
    "T6": null,
    "T7": 125,
    "Hôm nay": 215,
  };
  final Map<String, double?> chartDataMonth = {
    "11/2024": 116,
    "12/2024": 112,
    "T1": null,
    "Tháng này": 118,
  };
  final Map<String, double?> chartDataYear = {
    "2023": 165,
    "2024": null,
    "Năm nay": 146,
  };
  final Map<String, double?> chartDataWeek = {
    "t-5": 120,
    "t-4": null,
    "t-3": 116,
    "t-2": 125,
    "t-1": null,
    "Tuần này": 115,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // This ensures the UI updates when the tab changes
    });
    fetchHeartTRateDetail();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();

    _tabController.dispose();

    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    fetchHeartTRateDetail(); // Gọi lại API
  }

  Future<void> fetchHeartTRateDetail() async {
    setState(() {
      isLoading = true;
    });

    SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
    final currentUserAccountID = sharedPrefsHelper.getInt("accountId") ?? 0;
    final heartRateController = ref.read(heartRateControllerProvider);

    try {
      final result = await heartRateController.getHeartRatetDetail(
        context: context,
        accountId: currentUserAccountID,
      );
      for (var item in result) {
        switch (item["tabs"]) {
          case "Ngày":
            dataByDate = item;
            break;
          case "Tuần":
            dataByWeek = item;
            break;
          case "Tháng":
            dataByMonth = item;
            break;
          case "Năm":
            dataByYear = item;
            break;
        }
      }

      setState(() {
        dataFromApi = result;
        // Gán dữ liệu đã lọc vào state
        dataByDate = dataByDate;
        dataByWeek = dataByWeek;
        dataByMonth = dataByMonth;
        dataByYear = dataByYear;

        chartByDate = formatChartData(dataByDate?["chartDatabase"]);
        chartByWeek = formatChartData(dataByWeek?["chartDatabase"]);
        chartByMonth = formatChartData(dataByMonth?["chartDatabase"]);
        chartByYear = formatChartData(dataByYear?["chartDatabase"]);
      });

      print("ở đây $dataByDate");
      // setState(() {
      //   dataFromApi = result;
      // });
    } catch (e) {
      CherryToast.error(
        toastDuration: Duration(seconds: 3),
        title: Text(
          "Error fetching heart rate detail indicators: $e",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ).show(context);
      print("Error fetching heart rate indicators: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Chuyển đổi dữ liệu sang Map<String, double?>
  Map<String, double?> formatChartData(List<dynamic>? chartData) {
    if (chartData == null) return {};

    Map<String, double?> formattedData = {};

    for (var item in chartData) {
      String type = item["type"] ?? "Unknown";
      double? indicator =
          item["indicator"] != null ? item["indicator"].toDouble() : null;

      formattedData[type] = indicator;
    }

    return formattedData;
  }

  Color getBMIColor(String? result) {
    if (result?.trim().toLowerCase() == "cao") {
      return Colors.red;
    } else if (result?.trim().toLowerCase() == "bình thường") {
      return Colors.green; // Bình thường
    } else if (result?.trim().toLowerCase() == "thấp") {
      return Colors.blue;
    } else {
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Nhịp tim",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryColor,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: HealthFloatingActionButton(isDialOpen: isDialOpen)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tab Bar
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: TabBar(
                dividerHeight: 0,
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColors.secondaryColor,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: Colors.black,
                labelColor: Colors.white,
                labelStyle: const TextStyle(fontSize: 18),
                tabs: tabs
                    .map((tab) => Tab(
                          text: tab,
                        ))
                    .toList(),
              ),
            ),
            // Use Expanded for TabBarView
            SizedBox(
              height: 400,
              child: isLoading
                  ? LineChartSkeleton()
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        // Content for 'Ngày' tab (Daily)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Trung bình ngày",
                                          style: TextStyle(
                                              color: AppColors.grayColor5),
                                        ),
                                        Text(
                                          "${(dataByDate?["average"] as double?)?.toStringAsFixed(2) ?? "--"} nhịp/phút",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      " ${dataByDate?["evaluation"] ?? "--"} ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: getBMIColor(
                                            dataByDate?["evaluation"]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 300,
                                child: LineChartWidget(
                                  data: chartByDate,
                                  unit: "BPM",
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Content for 'Tuần' tab (Weekly)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Trung bình tuần",
                                          style: TextStyle(
                                              color: AppColors.grayColor5),
                                        ),
                                        Text(
                                          "${(dataByWeek?["average"] as double?)?.toStringAsFixed(2) ?? "--"} nhịp/phút",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${dataByWeek?["evaluation"] ?? "--"} ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: getBMIColor(
                                            dataByDate?["evaluation"]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 300,
                                child: LineChartWidget(
                                  data: chartByWeek,
                                  unit: "BPM",
                                ),
                              ),
                            ],
                          ),
                        ),

                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Trung bình tháng",
                                          style: TextStyle(
                                              color: AppColors.grayColor5),
                                        ),
                                        Text(
                                          "${(dataByMonth?["average"] as double?)?.toStringAsFixed(2) ?? "--"} nhịp/phút",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${dataByMonth?["evaluation"] ?? "--"} ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: getBMIColor(
                                            dataByDate?["evaluation"]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 300,
                                child: LineChartWidget(
                                  data: chartByMonth,
                                  unit: "BPM",
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Trung bình năm",
                                          style: TextStyle(
                                              color: AppColors.grayColor5),
                                        ),
                                        Text(
                                          "${(dataByYear?["average"] as double?)?.toStringAsFixed(2) ?? "--"} nhịp/phút",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${dataByYear?["evaluation"] ?? "--"} ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: getBMIColor(
                                            dataByDate?["evaluation"]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 300,
                                child: LineChartWidget(
                                  data: chartByYear,
                                  unit: "BPM",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            // Marker Pointer Chart

            const SizedBox(height: 20),

            Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              color: AppColors.bgColor,
              elevation: 1,
              shape: RoundedRectangleBorder(
                // side: const BorderSide(
                //     color: AppColors.secondaryColor, width: 0.05),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HealthMonitoringBook(
                                    initialTopic: "heart_rate",
                                  )),
                        );
                      },
                      child: Row(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
            )
          ],
        ),
      ),
    );
  }
}
