import 'package:flutter/material.dart';
import 'package:sep490/features/health/screens/health_monitoring_book.dart';
import 'package:sep490/presentation/widgets/health/chart/kidney_function_chart.dart';
import 'package:sep490/presentation/widgets/health/chart/line_chart_widget.dart';
import 'package:sep490/presentation/widgets/health/chart/lipid_profile_chart.dart';
import 'package:sep490/presentation/widgets/health/chart/liver_function_chart.dart';
import 'package:sep490/features/health/widgets/health_floating_action_button.dart';
import 'package:sep490/theme/color.dart';

class DetailLiverEnzymesScreen extends StatefulWidget {
  const DetailLiverEnzymesScreen({super.key});

  @override
  State<DetailLiverEnzymesScreen> createState() =>
      _DetailLiverEnzymesScreenState();
}

class _DetailLiverEnzymesScreenState extends State<DetailLiverEnzymesScreen>
    with SingleTickerProviderStateMixin {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
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
    // Initialize TabController
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of TabController to avoid memory leaks
    _tabController.dispose();
    super.dispose();
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
              child: TabBarView(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        "50%",
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
                                        "30%",
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
                                        "20%",
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                        "198.6",
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
                                        "198.6",
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
                                        "AST",
                                        style: TextStyle(
                                            color: AppColors.grayColor5),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "187 ",
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
                                        "187 ",
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
                          data: liverDataDate,
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Trung bình tuần",
                                    style:
                                        TextStyle(color: AppColors.grayColor5),
                                  ),
                                  Text(
                                    "---",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Text(
                                "Cao",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 350,
                          child: Center(
                              // child: GroupBarChartWidget(data: chartDataWeek),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Trung bình tháng",
                                    style:
                                        TextStyle(color: AppColors.grayColor5),
                                  ),
                                  Text(
                                    "---",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Text(
                                "Bình Thường",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 350,
                          child: Center(
                              // child: GroupBarChartWidget(data: chartDataMonth),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Trung bình năm",
                                    style:
                                        TextStyle(color: AppColors.grayColor5),
                                  ),
                                  Text(
                                    "---",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Text(
                                "Thấp",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 350,
                          child: Center(
                              // child: GroupBarChartWidget(data: chartDataYear),
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
