import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/health/screens/health_monitoring_book.dart';
import 'package:sep490/features/lipid_profile/controller/lipid_profile_controller.dart';
import 'package:sep490/main.dart';
import 'package:sep490/presentation/widgets/health/chart/line_chart_skeleton.dart';
import 'package:sep490/presentation/widgets/health/chart/lipid_profile_chart.dart';
import 'package:sep490/features/health/widgets/health_floating_action_button.dart';
import 'package:sep490/theme/color.dart';

class DetailLipidProfileScreen extends ConsumerStatefulWidget {
  const DetailLipidProfileScreen({super.key});

  @override
  ConsumerState<DetailLipidProfileScreen> createState() =>
      _DetailLipidProfileScreenState();
}

class _DetailLipidProfileScreenState
    extends ConsumerState<DetailLipidProfileScreen>
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
    final lipidProfileController = ref.read(lipidProfileControllerProvider);
    final currentSelectedElderlyId = sharedPrefsHelper.getInt("selectedElderlyUserId") ?? 0;

    try {
      final result = await lipidProfileController.getLipidProfileDetail(
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
          "Error fetching lipid profile detail indicators: $e",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ).show(context);
      print("Error fetching lipid profile indicators: $e");
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
            entry["triglycerides"] != null ||
            entry["ldlcholesterol"] != null ||
            entry["hdlcholesterol"] != null)
        .map((entry) {
      return {
        "date": entry["type"], // Giữ nguyên type làm date
        "Triglycerides": entry["triglycerides"] ?? 0,
        "LDL": entry["ldlcholesterol"] ?? 0,
        "HDL": entry["hdlcholesterol"] ?? 0,
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
          "Mỡ máu",
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
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
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
                                              "HDL tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByDate?[
                                              //         "hdlcholesterolAverage"]) ??
                                              //     "--",
                                              (dataByDate?["hdlcholesterolAverage"]
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
                                              "LDL tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByDate?[
                                              //         "ldlcholesterolAverage"]) ??
                                              //     "--",
                                              (dataByDate?["ldlcholesterolAverage"]
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
                                              "Trig tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByDate?[
                                              //         "triglyceridesAverage"]) ??
                                              //     "--",
                                              (dataByDate?["triglyceridesAverage"]
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
                              LipidProfileChart(
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
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
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
                                              "HDL tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByWeek?[
                                              //         "hdlcholesterolAverage"]) ??
                                              //     "--",
                                              (dataByWeek?["hdlcholesterolAverage"]
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
                                              "LDL tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByWeek?[
                                              //         "ldlcholesterolAverage"]) ??
                                              //     "--",
                                              (dataByWeek?["ldlcholesterolAverage"]
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
                                              "Trig tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByWeek?[
                                              //         "triglyceridesAverage"]) ??
                                              //     "--",
                                              (dataByWeek?["triglyceridesAverage"]
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
                              LipidProfileChart(
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
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
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
                                              "HDL tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByMonth?[
                                              //         "hdlcholesterolAverage"]) ??
                                              //     "--",
                                              (dataByMonth?["hdlcholesterolAverage"]
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
                                              "LDL tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByMonth?[
                                              //         "ldlcholesterolAverage"]) ??
                                              //     "--",
                                              (dataByMonth?["ldlcholesterolAverage"]
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
                                              "Trig tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByMonth?[
                                              //         "triglyceridesAverage"]) ??
                                              //     "--",
                                              (dataByMonth?["triglyceridesAverage"]
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
                              LipidProfileChart(
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
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
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
                                              "HDL tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByYear?[
                                              //         "hdlcholesterolAverage"]) ??
                                              //     "--",
                                              (dataByYear?["hdlcholesterolAverage"]
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
                                              "LDL tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByYear?[
                                              //         "ldlcholesterolAverage"]) ??
                                              //     "--",
                                              (dataByYear?["ldlcholesterolAverage"]
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
                                              "Trig tb",
                                              style: TextStyle(
                                                  color: AppColors.grayColor5),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              // (dataByYear?[
                                              //         "triglyceridesAverage"]) ??
                                              //     "--",
                                              (dataByYear?["triglyceridesAverage"]
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
                              LipidProfileChart(
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
                              initialTopic: "lipid_profile",
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
