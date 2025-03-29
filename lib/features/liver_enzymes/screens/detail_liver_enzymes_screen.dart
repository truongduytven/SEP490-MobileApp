import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/health/screens/health_monitoring_book.dart';
import 'package:sep490/features/liver_enzymes/controller/liver_enzymes_controller.dart';
import 'package:sep490/main.dart';
import 'package:sep490/presentation/widgets/health/chart/kidney_function_chart.dart';
import 'package:sep490/presentation/widgets/health/chart/line_chart_skeleton.dart';
import 'package:sep490/presentation/widgets/health/chart/line_chart_widget.dart';
import 'package:sep490/presentation/widgets/health/chart/lipid_profile_chart.dart';
import 'package:sep490/presentation/widgets/health/chart/liver_function_chart.dart';
import 'package:sep490/features/health/widgets/health_floating_action_button.dart';
import 'package:sep490/theme/color.dart';

class DetailLiverEnzymesScreen extends ConsumerStatefulWidget {
  const DetailLiverEnzymesScreen({super.key});

  @override
  ConsumerState<DetailLiverEnzymesScreen> createState() =>
      _DetailLiverEnzymesScreenState();
}

class _DetailLiverEnzymesScreenState
    extends ConsumerState<DetailLiverEnzymesScreen>
    with SingleTickerProviderStateMixin, RouteAware, WidgetsBindingObserver {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  List<Map<String, dynamic>> dataFromApi = [];
  // Lọc dữ liệu theo từng tab
  Map<String, dynamic>? dataByDate;
  Map<String, dynamic>? dataByWeek;
  Map<String, dynamic>? dataByMonth;
  Map<String, dynamic>? dataByYear;
  // Khai báo biến chartByDate đúng kiểu
  List<Map<String, dynamic>> chartByDate = [];
  List<Map<String, dynamic>> chartByWeek = [];
  List<Map<String, dynamic>> chartByMonth = [];
  List<Map<String, dynamic>> chartByYear = [];
  bool isLoading = false;

  late TabController _tabController;
  final List<String> tabs = ['Ngày', 'Tuần', 'Tháng', 'Năm'];
  List<Map<String, dynamic>> liverDataDate = [
    {"date": "01/07", "ALT": 30, "AST": 25, "ALP": 100, "GGT": 50},
    {"date": "02/07", "ALT": 32, "AST": 27, "ALP": 110, "GGT": 55},
    {"date": "03/07", "ALT": 28, "AST": 22, "ALP": 95, "GGT": 48},
    {"date": "04/07", "ALT": 35, "AST": 30, "ALP": 105, "GGT": 52},
    {"date": "05/07", "ALT": 29, "AST": 24, "ALP": 98, "GGT": 47},
  ];
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
    fetchBloodGlucoseDetail();
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
    fetchBloodGlucoseDetail(); // Gọi lại API
  }

  Future<void> fetchBloodGlucoseDetail() async {
    setState(() {
      isLoading = true;
    });

    SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
    final currentUserAccountID = sharedPrefsHelper.getInt("accountId") ?? 0;
    final liverEnzymesController = ref.read(liverEnzymesControllerProvider);

    try {
      final result = await liverEnzymesController.getLiverEnzymesDetail(
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
    } catch (e) {
      CherryToast.error(
        toastDuration: Duration(seconds: 3),
        title: Text(
          "Error fetching liver enzymes detail indicators: $e",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ).show(context);
      print("Error fetching liver enzymes indicators: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> formatChartData(List<dynamic>? chartDatabase) {
    if (chartDatabase == null) return [];

    return chartDatabase
        .where((entry) =>
            entry["alt"] != null ||
            entry["ast"] != null ||
            entry["ggt"] != null ||
            entry["alp"] != null)
        .map((entry) {
      return {
        "date": entry["type"], // Giữ nguyên type làm date
        "ALT": entry["alt"] ?? 0,
        "AST": entry["ast"] ?? 0,
        "ALP": entry["alp"] ?? 0,
        "GGT": entry["ggt"] ?? 0,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const Text(
          "Men gan",
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
            child: HealthFloatingActionButton(isDialOpen: isDialOpen),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Tab Bar
            Container(
              height: 55,
              margin: const EdgeInsets.all(16),
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
            // Tab Bar View
            SizedBox(
              height: 550,
              child: isLoading
                  ? LineChartSkeleton()
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        // Day View
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Cao:",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${dataByDate?["highestPercent"] ?? "--"} %",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Colors.orange),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Bình thường:",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${dataByDate?["normalPercent"] ?? "--"} %",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Thấp:",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${dataByDate?["lowestPercent"] ?? "--"} %",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "ALT tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (dataByDate?["altAverage"]) ??
                                                  "--",
                                              // (dataByDate?["altAverage"]
                                              //             as double?)
                                              //         ?.toStringAsFixed(2) ??
                                              //     "--",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "ALP tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (dataByDate?["alpAverage"]) ??
                                                  "--",
                                              // (dataByDate?["alpAverage"]
                                              //             as double?)
                                              //         ?.toStringAsFixed(2) ??
                                              //     "--",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "AST tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (dataByDate?["astAverage"]) ??
                                                  "--",
                                              // (dataByDate?["astAverage"]
                                              //             as double?)
                                              //         ?.toStringAsFixed(2) ??
                                              //     "--",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "GGT tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (dataByDate?["ggtAverage"]) ??
                                                  "--",
                                              // (dataByDate?["ggtAverage"]
                                              //             as double?)
                                              //         ?.toStringAsFixed(2) ??
                                              //     "--",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              LiverFunctionChart(
                                data: chartByDate,
                              ),
                            ],
                          ),
                        ),
                        // Week View
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Cao:",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${dataByWeek?["highestPercent"] ?? "--"} %",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Colors.orange),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Bình thường:",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${dataByWeek?["normalPercent"] ?? "--"} %",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Thấp:",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${dataByWeek?["lowestPercent"] ?? "--"} %",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "ALT tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (dataByWeek?["altAverage"]) ??
                                                  "--",
                                              // (dataByWeek?["altAverage"]
                                              //             as double?)
                                              //         ?.toStringAsFixed(2) ??
                                              //     "--",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "ALP tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (dataByWeek?["alpAverage"]) ??
                                                  "--",
                                              // (dataByWeek?["alpAverage"]
                                              //             as double?)
                                              //         ?.toStringAsFixed(2) ??
                                              //     "--",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "AST tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (dataByWeek?["astAverage"]) ??
                                                  "--",
                                              // (dataByWeek?["astAverage"]
                                              //             as double?)
                                              //         ?.toStringAsFixed(2) ??
                                              //     "--",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "GGT tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (dataByWeek?["ggtAverage"]) ??
                                                  "--",
                                              // (dataByWeek?["ggtAverage"]
                                              //             as double?)
                                              //         ?.toStringAsFixed(2) ??
                                              //     "--",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              LiverFunctionChart(
                                data: chartByWeek,
                              ),
                            ],
                          ),
                        ),
                        // Month View (Placeholder)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Cao:",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${dataByMonth?["highestPercent"] ?? "--"} %",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Colors.orange),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Bình thường:",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${dataByMonth?["normalPercent"] ?? "--"} %",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Thấp:",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${dataByMonth?["lowestPercent"] ?? "--"} %",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "ALT tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (dataByMonth?["altAverage"]) ??
                                                  "--",
                                              // (dataByMonth?["altAverage"]
                                              //             as double?)
                                              //         ?.toStringAsFixed(2) ??
                                              //     "--",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "ALP tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (dataByMonth?["alpAverage"]) ??
                                                  "--",
                                              // (dataByMonth?["alpAverage"]
                                              //             as double?)
                                              //         ?.toStringAsFixed(2) ??
                                              //     "--",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "AST tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (dataByMonth?["astAverage"]) ??
                                                  "--",
                                              // (dataByMonth?["astAverage"]
                                              //             as double?)
                                              //         ?.toStringAsFixed(2) ??
                                              //     "--",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "GGT tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (dataByMonth?["ggtAverage"]) ??
                                                  "--",
                                              // (dataByMonth?["ggtAverage"]
                                              //             as double?)
                                              //         ?.toStringAsFixed(2) ??
                                              //     "--",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              LiverFunctionChart(
                                data: chartByMonth,
                              ),
                            ],
                          ),
                        ),
                        // Year View (Placeholder)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Cao:",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${dataByYear?["highestPercent"] ?? "--"} %",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Colors.orange),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Bình thường:",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${dataByYear?["normalPercent"] ?? "--"} %",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Thấp:",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${dataByYear?["lowestPercent"] ?? "--"} %",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "ALT tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (dataByYear?["altAverage"]) ??
                                                  "--",
                                              // (dataByYear?["altAverage"]
                                              //             as double?)
                                              //         ?.toStringAsFixed(2) ??
                                              //     "--",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "ALP tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (dataByYear?["alpAverage"]) ??
                                                  "--",
                                              // (dataByYear?["alpAverage"]
                                              //             as double?)
                                              //         ?.toStringAsFixed(2) ??
                                              //     "--",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "AST tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (dataByYear?["astAverage"]) ??
                                                  "--",
                                              // (dataByYear?["astAverage"]
                                              //             as double?)
                                              //         ?.toStringAsFixed(2) ??
                                              //     "--",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "GGT tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (dataByYear?["ggtAverage"]) ??
                                                  "--",
                                              // (dataByYear?["ggtAverage"]
                                              //             as double?)
                                              //         ?.toStringAsFixed(2) ??
                                              //     "--",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              LiverFunctionChart(
                                data: chartByYear,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                              initialTopic: "liver_enzym",
                            ),
                          ),
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
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
