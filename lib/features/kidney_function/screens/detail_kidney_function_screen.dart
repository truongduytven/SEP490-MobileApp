import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/health/screens/health_monitoring_book.dart';
import 'package:sep490/features/kidney_function/controller/kidney_function_controller.dart';
import 'package:sep490/main.dart';
import 'package:sep490/presentation/widgets/health/chart/kidney_function_chart.dart';
import 'package:sep490/presentation/widgets/health/chart/line_chart_skeleton.dart';
import 'package:sep490/presentation/widgets/health/chart/line_chart_widget.dart';
import 'package:sep490/features/health/widgets/health_floating_action_button.dart';
import 'package:sep490/theme/color.dart';

class DetailKidneyFunctionScreen extends ConsumerStatefulWidget {
  const DetailKidneyFunctionScreen({super.key});

  @override
  ConsumerState<DetailKidneyFunctionScreen> createState() =>
      _DetailKidneyFunctionScreenState();
}

class _DetailKidneyFunctionScreenState
    extends ConsumerState<DetailKidneyFunctionScreen>
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
  final List<Map<String, dynamic>> kidneyDataDate = [
    {"date": "T2", "BUN": 18, "GFR": 90, "eGFR": 85.5},
    {"date": "T3", "BUN": 20, "GFR": 88, "eGFR": 83},
    {"date": "T5", "BUN": 22, "GFR": 85, "eGFR": 80},
    {"date": "Hôm nay", "BUN": 25, "GFR": 82, "eGFR": 78},
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
    final kidneyFunctionController = ref.read(kidneyFunctionControllerProvider);
    final currentSelectedElderlyId =
        sharedPrefsHelper.getInt("selectedElderlyUserId") ?? 0;

    try {
      final result = await kidneyFunctionController.getKidneyFunctionDetail(
        context: context,
        accountId: currentSelectedElderlyId == 0
            ? currentUserAccountID
            : currentSelectedElderlyId,
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
          "Error fetching kidney function detail indicators: $e",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ).show(context);
      print("Error fetching kidney function indicators: $e");
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
            entry["creatinine"] != null ||
            entry["bun"] != null ||
            entry["eGfr"] != null)
        .map((entry) {
      return {
        "date": entry["type"], // Giữ nguyên type làm date
        "BUN": entry["bun"] ?? 0,
        "GFR": entry["creatinine"] ?? 0,
        "eGFR": entry["eGfr"] ?? 0,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
    final currentUserRoleId = sharedPrefsHelper.getInt("roleId");
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const Text(
          "Chức năng thận",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryColor,
          ),
        ),
        centerTitle: true,
        actions: [
          if (currentUserRoleId != 4)
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
                                              "BUN tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByDate?["bunAverage"]) ??
                                              //     "--",
                                              (dataByDate?["bunAverage"]
                                                              ?.toDouble() ??
                                                          0.0)
                                                      .toStringAsFixed(2) ??
                                                  "--",
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
                                              "GFR tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByDate?[
                                              //         "creatinineAverage"]) ??
                                              //     "--",
                                              (dataByDate?["creatinineAverage"]
                                                              ?.toDouble() ??
                                                          0.0)
                                                      .toStringAsFixed(2) ??
                                                  "--",
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
                                              "eGFR",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByDate?["eGfrAverage"]) ??
                                              //     "--",
                                              (dataByDate?["eGfrAverage"]
                                                              ?.toDouble() ??
                                                          0.0)
                                                      .toStringAsFixed(2) ??
                                                  "--",
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
                              KidneyFunctionChart(
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
                                              "BUN tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByWeek?["bunAverage"]) ??
                                              //     "--",
                                              (dataByWeek?["bunAverage"]
                                                              ?.toDouble() ??
                                                          0.0)
                                                      .toStringAsFixed(2) ??
                                                  "--",
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
                                              "GFR tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByWeek?[
                                              //         "creatinineAverage"]) ??
                                              //     "--",
                                              (dataByWeek?["creatinineAverage"]
                                                              ?.toDouble() ??
                                                          0.0)
                                                      .toStringAsFixed(2) ??
                                                  "--",
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
                                              "eGFR",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByWeek?["eGfrAverage"]) ??
                                              //     "--",
                                              (dataByWeek?["eGfrAverage"]
                                                              ?.toDouble() ??
                                                          0.0)
                                                      .toStringAsFixed(2) ??
                                                  "--",
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
                              KidneyFunctionChart(
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
                                              "BUN tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByMonth?["bunAverage"]) ??
                                              //     "--",
                                              (dataByMonth?["bunAverage"]
                                                              ?.toDouble() ??
                                                          0.0)
                                                      .toStringAsFixed(2) ??
                                                  "--",
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
                                              "GFR tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByMonth?[
                                              //         "creatinineAverage"]) ??
                                              //     "--",
                                              (dataByMonth?["creatinineAverage"]
                                                              ?.toDouble() ??
                                                          0.0)
                                                      .toStringAsFixed(2) ??
                                                  "--",
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
                                              "eGFR",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByMonth?["eGfrAverage"]) ??
                                              //     "--",
                                              (dataByMonth?["eGfrAverage"]
                                                              ?.toDouble() ??
                                                          0.0)
                                                      .toStringAsFixed(2) ??
                                                  "--",
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
                              KidneyFunctionChart(
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
                                              "BUN tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByYear?["bunAverage"]) ??
                                              //     "--",
                                              (dataByYear?["bunAverage"]
                                                              ?.toDouble() ??
                                                          0.0)
                                                      .toStringAsFixed(2) ??
                                                  "--",
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
                                              "GFR tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByYear?[
                                              //         "creatinineAverage"]) ??
                                              //     "--",
                                              (dataByYear?["creatinineAverage"]
                                                              ?.toDouble() ??
                                                          0.0)
                                                      .toStringAsFixed(2) ??
                                                  "--",
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
                                              "eGFR",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByYear?["eGfrAverage"]) ??
                                              //     "--",
                                              (dataByYear?["eGfrAverage"]
                                                              ?.toDouble() ??
                                                          0.0)
                                                      .toStringAsFixed(2) ??
                                                  "--",
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
                              KidneyFunctionChart(
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
                              initialTopic: "kidney_function",
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
