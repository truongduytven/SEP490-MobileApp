import 'package:flutter/material.dart';
import 'package:sep490/features/health/screens/health_monitoring_book.dart';
import 'package:sep490/presentation/widgets/health/chart/line_chart_widget.dart';
import 'package:sep490/presentation/widgets/health/chart/marker_pointer_chart.dart';
import 'package:sep490/features/health/widgets/health_floating_action_button.dart';
import 'package:sep490/theme/color.dart';

class DetailHeightScreen extends StatefulWidget {
  const DetailHeightScreen({super.key});

  @override
  State<DetailHeightScreen> createState() => _DetailHeightScreenState();
}

class _DetailHeightScreenState extends State<DetailHeightScreen>
    with SingleTickerProviderStateMixin {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  late TabController _tabController;
  final List<String> tabs = ['Ngày', 'Tuần', 'Tháng', 'Năm'];
  final Map<String, double?> chartDataDate = {
    "T2": 175,
    "T3": null,
    "T4": 176,
    "T5": 174.5,
    "T6": null,
    "T7": 175,
    "Hôm nay": 175,
  };
  final Map<String, double?> chartDataMonth = {
    "11/2024": 174.5,
    "12/2024": 172,
    "T1": null,
    "Tháng này": 178,
  };
  final Map<String, double?> chartDataYear = {
    "2023": 165,
    "2024": null,
    "Năm nay": 146,
  };
  final Map<String, double?> chartDataWeek = {
    "t-5": 170,
    "t-4": null,
    "t-3": 166,
    "t-2": 164.5,
    "t-1": null,
    "Tuần này": 165,
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
          "Chiều cao",
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
              height: 400, // Adjust the height for better scrolling experience
              child: TabBarView(
                controller: _tabController,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Trung bình ngày",
                                    style:
                                        TextStyle(color: AppColors.grayColor5),
                                  ),
                                  Text(
                                    "163cm",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Text(
                                "BMI: 18.1",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: LineChartWidget(
                            data: chartDataDate,
                            unit: "cm",
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
                                    "164.5cm",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Text(
                                "BMI: 17.1",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: LineChartWidget(
                            data: chartDataWeek,
                            unit: "cm",
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
                                    "166.6cm",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Text(
                                "BMI: 19.1",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: LineChartWidget(
                            data: chartDataMonth,
                            unit: "cm",
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
                                    "161cm",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Text(
                                "BMI: 16.1",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: LineChartWidget(
                            data: chartDataYear,
                            unit: "cm",
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
                                    initialTopic: "height",
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
