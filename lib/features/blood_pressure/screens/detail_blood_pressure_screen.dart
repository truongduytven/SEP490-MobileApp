import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/blood_pressure/controller/blood_pressure_controller.dart';
import 'package:sep490/features/health/screens/health_monitoring_book.dart';
import 'package:sep490/main.dart';
import 'package:sep490/presentation/widgets/health/chart/group_bar_chart_widget.dart';
import 'package:sep490/presentation/widgets/health/chart/line_chart_blood_pressure_widget.dart';
import 'package:sep490/features/health/widgets/health_floating_action_button.dart';
import 'package:sep490/presentation/widgets/health/chart/line_chart_skeleton.dart';
import 'package:sep490/theme/color.dart';

class DetailBloodPressureScreen extends ConsumerStatefulWidget {
  const DetailBloodPressureScreen({super.key});

  @override
  ConsumerState<DetailBloodPressureScreen> createState() =>
      _DetailBloodPressureScreenState();
}

class _DetailBloodPressureScreenState
    extends ConsumerState<DetailBloodPressureScreen>
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
  Map<String, List<double>> chartByDate = {};
  Map<String, List<double>> chartByWeek = {};
  Map<String, List<double>> chartByMonth = {};
  Map<String, List<double>> chartByYear = {};
  bool isLoading = false;

  final List<String> tabs = ['Ngày', 'Tuần', 'Tháng', 'Năm'];
  final Map<String, List<double>> chartDataDate = {
    'T2': [102, 110],
    // 'T3': [110, 80],
    // 'T4': [89, 90.0],
    // 'T5': [140.0, 160.0],
    // 'T6': [90.0, 110.0],
    // 'T7': [90.0, 110.0],
  };
  final Map<String, List<double>> chartDataWeek = {
    'T-4': [112, 101],
    'T-3': [115, 80],
    'T-2': [85, 87.0],
    'T-1': [140.0, 130.0],
    'Tuần này': [79.0, 120.0],
  };
  final Map<String, List<double>> chartDataMonth = {
    '11/2024': [100, 113],
    '12/2024': [99, 89],
    '1/2025': [95, 130],
    'Tháng này': [140.0, 160.0],
  };
  final Map<String, List<double>> chartDataYear = {
    '2023': [96.0, 110.0],
    '2024': [90.0, 110.0],
    'Năm nay': [90.0, 110.0],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    fetchBloodPressureDetail();
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
    fetchBloodPressureDetail(); // Gọi lại API
  }

  Future<void> fetchBloodPressureDetail() async {
    setState(() {
      isLoading = true;
    });

    SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
    final currentUserAccountID = sharedPrefsHelper.getInt("accountId") ?? 0;
    final bloodPressureController = ref.read(bloodPressureControllerProvider);
    final currentSelectedElderlyId = sharedPrefsHelper.getInt("selectedElderlyUserId") ?? 0;

    try {
      final result = await bloodPressureController.getBloodPressureDetail(
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
        print("dữ liệu biểu đồ $chartByDate");
      });
    } catch (e) {
      CherryToast.error(
        toastDuration: Duration(seconds: 3),
        title: Text(
          "Error fetching blood pressure detail indicators: $e",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ).show(context);
      print("Error fetching blood pressure indicators: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Map<String, List<double>> formatChartData(List<dynamic>? chartData) {
    print("chat nè $chartData");
    if (chartData == null) return {};

    Map<String, List<double>> formattedData = {};

    for (var item in chartData) {
      String type = item["type"] ?? "Unknown";
      String? indicator = item["indicator"];

      if (indicator != null && indicator.contains("/")) {
        List<String> parts = indicator.split("/");
        double? first = double.tryParse(parts[0]);
        double? second = double.tryParse(parts[1]);

        if (first != null && second != null) {
          formattedData[type] = [first, second]; // Lưu cả hai giá trị
        }
      }
    }
    print("chatt sau forrmat $formattedData");
    return formattedData;
  }

  Color getResultColor(String? result) {
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
          "Huyết áp",
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
              height: 450,
              child: isLoading
                  ? LineChartSkeleton()
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        // Day View
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                          "${dataByDate?["average"] ?? "--"} mmHg",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: getResultColor(
                                                dataByDate?["evaluation"]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      " ${dataByDate?["evaluation"] ?? "--"} ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: getResultColor(
                                            dataByDate?["evaluation"]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 350,
                                child: Center(
                                  child: LineChartBloodPressureWidget(
                                    data: chartByDate,
                                    unit: "mmHg",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Week View
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                          "${dataByWeek?["average"] ?? "--"} mmHg",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: getResultColor(
                                                dataByDate?["evaluation"]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      " ${dataByWeek?["evaluation"] ?? "--"} ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: getResultColor(
                                            dataByDate?["evaluation"]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 350,
                                child: Center(
                                  child: LineChartBloodPressureWidget(
                                    data: chartByWeek,
                                    unit: "mmHg",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Month View (Placeholder)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                          "${dataByMonth?["average"] ?? "--"} mmHg",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: getResultColor(
                                                dataByDate?["evaluation"]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      " ${dataByMonth?["evaluation"] ?? "--"} ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: getResultColor(
                                            dataByDate?["evaluation"]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 350,
                                child: Center(
                                  child: LineChartBloodPressureWidget(
                                    data: chartByMonth,
                                    unit: "mmHg",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Year View (Placeholder)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                          "${dataByYear?["average"] ?? "--"} mmHg",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: getResultColor(
                                                dataByDate?["evaluation"]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      " ${dataByYear?["evaluation"] ?? "--"} ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: getResultColor(
                                            dataByDate?["evaluation"]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 350,
                                child: Center(
                                  child: LineChartBloodPressureWidget(
                                    data: chartByYear,
                                    unit: "mmHg",
                                  ),
                                ),
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
                              initialTopic: "blood_pressure",
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
