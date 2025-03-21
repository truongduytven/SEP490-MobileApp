import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/health/screens/health_monitoring_book.dart';
import 'package:sep490/features/weight/controller/weight_controller.dart';
import 'package:sep490/main.dart';
import 'package:sep490/presentation/widgets/health/chart/line_chart_skeleton.dart';
import 'package:sep490/presentation/widgets/health/chart/line_chart_widget.dart';
import 'package:sep490/presentation/widgets/health/chart/marker_pointer_chart.dart';
import 'package:sep490/features/health/widgets/health_floating_action_button.dart';
import 'package:sep490/theme/color.dart';
import 'package:shimmer/shimmer.dart';

class DetailWeightScreen extends ConsumerStatefulWidget {
  const DetailWeightScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DetailWeightScreen> createState() => _DetailWeightScreenState();
}

class _DetailWeightScreenState extends ConsumerState<DetailWeightScreen>
    with SingleTickerProviderStateMixin, RouteAware, WidgetsBindingObserver {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  late TabController _tabController;

  List<Map<String, dynamic>> dataFromApi = [];

  Map<String, dynamic>? dataByDate;
  Map<String, dynamic>? dataByWeek;
  Map<String, dynamic>? dataByMonth;
  Map<String, dynamic>? dataByYear;

  Map<String, double?> chartByDate = {};
  Map<String, double?> chartByWeek = {};
  Map<String, double?> chartByMonth = {};
  Map<String, double?> chartByYear = {};

  bool isLoading = false;

  final List<String> tabs = ['Ngày', 'Tuần', 'Tháng', 'Năm'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // This ensures the UI updates when the tab changes
    });
    fetchHeightDetail();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();

    _tabController.dispose();

    WidgetsBinding.instance
        .removeObserver(this); // Xóa observer khi widget bị hủy
    routeObserver.unsubscribe(this); // Hủy đăng ký RouteAware khi widget bị hủy
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
    fetchHeightDetail(); // Gọi lại API
  }

  Future<void> fetchHeightDetail() async {
    setState(() {
      isLoading = true;
    });

    SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
    final currentUserAccountID = sharedPrefsHelper.getInt("accountId") ?? 0;
    final weightController = ref.read(weightControllerProvider);

    try {
      final result = await weightController.getWeightDetail(
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
          "Error fetching weight detail indicators: $e",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ).show(context);
      print("Error fetching weight detail indicators: $e");
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

  double _getCurrentBMIValue() {
    String evaluation;
    switch (_tabController.index) {
      case 0:
        evaluation = dataByDate?["evaluation"] ?? "0.0";
        break;
      case 1:
        evaluation = dataByWeek?["evaluation"] ?? "0.0";
        break;
      case 2:
        evaluation = dataByMonth?["evaluation"] ?? "0.0";
        break;
      case 3:
        evaluation = dataByYear?["evaluation"] ?? "0.0";
        break;
      default:
        evaluation = "0.0";
    }
    // Chuyển đổi từ String sang double
    double value = double.tryParse(evaluation) ?? 0.0;
    // Làm tròn đến 2 chữ số thập phân
    return double.parse(value.toStringAsFixed(2));
  }

  String _getCurrentBMIResult() {
    double bmiValue;
    switch (_tabController.index) {
      case 0:
        bmiValue = double.tryParse(dataByDate?["evaluation"] ?? "0.0") ?? 0.0;
        break;
      case 1:
        bmiValue = double.tryParse(dataByWeek?["evaluation"] ?? "0.0") ?? 0.0;
        break;
      case 2:
        bmiValue = double.tryParse(dataByMonth?["evaluation"] ?? "0.0") ?? 0.0;
        break;
      case 3:
        bmiValue = double.tryParse(dataByYear?["evaluation"] ?? "0.0") ?? 0.0;
        break;
      default:
        bmiValue = 0.0;
    }

    // Đánh giá BMI
    if (bmiValue < 18.5) {
      return "Thiếu cân";
    } else if (bmiValue >= 18.5 && bmiValue <= 24.9) {
      return "Bình thường";
    } else if (bmiValue >= 25 && bmiValue <= 29.9) {
      return "Thừa cân";
    } else if (bmiValue >= 30) {
      return "Béo phì";
    } else {
      return "--";
    }
  }

  Color getBMIColor(String? bmiValue) {
    double? bmi = double.tryParse(bmiValue ?? "");
    if (bmi == null) return Colors.grey; // Trả về màu xám nếu BMI không hợp lệ

    if (bmi < 18.5) {
      return Colors.blue; // Gầy
    } else if (bmi < 25) {
      return Colors.green; // Bình thường
    } else if (bmi < 30) {
      return Colors.orange; // Thừa cân
    } else {
      return Colors.red; // Béo phì
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
          "Cân nặng",
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
        // Wrap the body with SingleChildScrollView
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
              height: 400, // Adjust the height for better scrolling experience
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
                                          "${(dataByDate?["average"] as double?)?.toStringAsFixed(2) ?? "--"} kg",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "BMI: ${dataByDate?["evaluation"] ?? "--"} ",
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
                                  unit: "kg",
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
                                          "${(dataByWeek?["average"] as double?)?.toStringAsFixed(2) ?? "--"} kg",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "BMI: ${dataByWeek?["evaluation"] ?? "--"} ",
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
                                  unit: "kg",
                                ),
                              ),
                            ],
                          ),
                        ),
                        // // Content for 'Tháng' tab (Monthly)
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       vertical: 30, horizontal: 10),
                        //   child: Center(
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: const [
                        //         Expanded(child: ColumnChartMedicine())
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Content for 'Năm' tab (Yearly)
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
                                          "${(dataByMonth?["average"] as double?)?.toStringAsFixed(2) ?? "--"} kg",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "BMI: ${dataByMonth?["evaluation"] ?? "--"} ",
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
                                  unit: "kg",
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
                                          "${(dataByYear?["average"] as double?)?.toStringAsFixed(2) ?? "--"} kg",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "BMI: ${dataByYear?["evaluation"] ?? "--"} ",
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
                                  unit: "kg",
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
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey
                        .withOpacity(0.5), // Shadow color (light pink)
                    blurRadius: 0.05, // Blur radius for the shadow
                    offset: Offset(
                        1, 1), // Offset for the shadow (horizontal, vertical)
                  ),
                ],
                color: AppColors.bgColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.secondaryColor, // Pink border color
                  width: 0.05, // Adjust the border width as needed
                ),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tỉ số khối cơ thể(BMI)",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 150, // Ensure it has a fixed height
                    child: isLoading
                        ? Shimmer.fromColors(
                            baseColor: const Color.fromARGB(255, 241, 236, 250),
                            highlightColor: Colors.white,
                            child: Container(
                              height: 300,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )
                        : MarkerPointerChart(
                            value: _getCurrentBMIValue(),
                            result: _getCurrentBMIResult(),
                          ),
                  ),
                ],
              ),
            ),

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
                                    initialTopic: "weight",
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
