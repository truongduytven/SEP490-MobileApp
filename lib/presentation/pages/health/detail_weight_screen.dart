import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:sep490/presentation/pages/health/health_monitoring_book.dart';
import 'package:sep490/presentation/widgets/health/chart/line_chart_widget.dart';
import 'package:sep490/presentation/widgets/health/chart/marker_pointer_chart.dart';
import 'package:sep490/presentation/widgets/health/health_floating_action_button.dart';
import 'package:sep490/theme/color.dart';

class DetailWeightScreen extends StatefulWidget {
  const DetailWeightScreen({Key? key}) : super(key: key);

  @override
  State<DetailWeightScreen> createState() => _DetailWeightScreenState();
}

class _DetailWeightScreenState extends State<DetailWeightScreen>
    with SingleTickerProviderStateMixin {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  late TabController _tabController;
  final List<String> tabs = ['Ngày', 'Tuần', 'Tháng', 'Năm'];
  final Map<String, double?> chartData = {
    "Monday": 150,
    "Tuesday": null, // null value for demonstration
    "Wednesday": 180,
    "Thursday": 160,
    "Friday": null, // another null value
    "Saturday": 140,
    "Sunday": 170,
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
            const SizedBox(height: 16),
            // Use Expanded for TabBarView
            SizedBox(
              height: 500, // Adjust the height for better scrolling experience
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Content for 'Ngày' tab (Daily)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Daily content goes here!',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 200,
                          child: Chart(
                            layers: [
                              ChartAxisLayer(
                                settings: ChartAxisSettings(
                                  x: ChartAxisSettingsAxis(
                                    frequency: 1.0,
                                    max: 13.0,
                                    min: 7.0,
                                    textStyle: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 10.0,
                                    ),
                                  ),
                                  y: ChartAxisSettingsAxis(
                                    frequency: 100.0,
                                    max: 300.0,
                                    min: 0.0,
                                    textStyle: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                                labelX: (value) => value.toInt().toString(),
                                labelY: (value) => value.toInt().toString(),
                              ),
                              ChartBarLayer(
                                items: List.generate(
                                  13 - 7 + 1,
                                  (index) => ChartBarDataItem(
                                    color: const Color(0xFF8043F9),
                                    value: Random().nextInt(280) + 20,
                                    x: index.toDouble() + 7,
                                  ),
                                ),
                                settings: const ChartBarSettings(
                                  thickness: 8.0,
                                  radius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // Content for 'Tuần' tab (Weekly)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Weekly content goes here!',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          child: LineChartWidget(data: chartData),
                        ),
                      ],
                    ),
                  ),
                  // Content for 'Tháng' tab (Monthly)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Monthly content goes here!',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        MarkerPointerChart(
                          value: 18.9,
                          result: "Bình Thường",
                        ),
                      ],
                    ),
                  ),
                  // Content for 'Năm' tab (Yearly)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Yearly content goes here!',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        MarkerPointerChart(
                          value: 18.9,
                          result: "Bình Thường",
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
                children: const [
                  Text(
                    "Tỉ số khối cơ thể(BMI)",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text(
                      "11 tháng 2 năm 2025",
                      style: TextStyle(
                          fontSize: 18,
                          color: AppColors.grayColor5,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 150, // Ensure it has a fixed height
                    child: MarkerPointerChart(
                      value: 18.9,
                      result: "Bình Thường",
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

class ChartData {
  final int x;
  final double y;

  ChartData(this.x, this.y);
}
