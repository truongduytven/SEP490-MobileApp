import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/health/health_monitoring_book.dart';
import 'package:sep490/presentation/widgets/health/chart/group_bar_chart_widget.dart';
import 'package:sep490/presentation/widgets/health/health_floating_action_button.dart';
import 'package:sep490/theme/color.dart';

class DetailBloodPressureScreen extends StatefulWidget {
  const DetailBloodPressureScreen({super.key});

  @override
  State<DetailBloodPressureScreen> createState() =>
      _DetailBloodPressureScreenState();
}

class _DetailBloodPressureScreenState extends State<DetailBloodPressureScreen>
    with SingleTickerProviderStateMixin {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  late TabController _tabController;
  final List<String> tabs = ['Ngày', 'Tuần', 'Tháng', 'Năm'];
  final Map<String, List<double>> chartDataDate = {
    'T2': [102, 110],
    'T3': [110, 80],
    'T4': [89, 90.0],
    'T5': [140.0, 160.0],
    'T6': [90.0, 110.0],
    'T7': [90.0, 110.0],
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
              height: 350,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Day View
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 350,
                          child: Center(
                            child: GroupBarChartWidget(data: chartDataDate),
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
                        SizedBox(
                          height: 350,
                          child: Center(
                            child: GroupBarChartWidget(data: chartDataWeek),
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
                        SizedBox(
                          height: 350,
                          child: Center(
                            child: GroupBarChartWidget(data: chartDataMonth),
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
                        SizedBox(
                          height: 350,
                          child: Center(
                            child: GroupBarChartWidget(data: chartDataYear),
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
                side: const BorderSide(
                    color: AppColors.secondaryColor, width: 0.05),
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
