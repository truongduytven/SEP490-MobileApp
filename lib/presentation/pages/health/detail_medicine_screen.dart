import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/health/health_monitoring_book.dart';
import 'package:sep490/presentation/widgets/health/chart/column_chart_medicine.dart';
import 'package:sep490/presentation/widgets/health/health_floating_action_button.dart';
import 'package:sep490/theme/color.dart';

class DetailMedicineScreen extends StatefulWidget {
  const DetailMedicineScreen({super.key});

  @override
  State<DetailMedicineScreen> createState() => _DetailMedicineScreenState();
}

class _DetailMedicineScreenState extends State<DetailMedicineScreen>
    with SingleTickerProviderStateMixin {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  late TabController _tabController;
  final List<String> tabs = ['Ngày', 'Tuần', 'Tháng'];
  final Map<String, double?> chartDataDate = {
    "T2": 76,
    "T3": null,
    "T4": 56.8,
    "T5": 100,
    "T6": null,
    "T7": 25,
    "Hôm nay": 15,
  };
  final Map<String, double?> chartDataMonth = {
    "11/2024": 76,
    "12/2014": null,
    "1/2025": 76.8,
    "Tháng này": 35,
  };
  final Map<String, double?> chartDataWeek = {
    "T-3": 70,
    "T-2": null,
    "T-1": 26.8,
    "Tuần này": 100,
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
          "Thuốc",
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
              height: 350, // Adjust the height for better scrolling experience
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Content for 'Ngày' tab (Daily)
                  // Content for 'Tháng' tab (Monthly)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: ColumnChartMedicine(
                            data: chartDataDate,
                          ))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: ColumnChartMedicine(
                            data: chartDataWeek,
                          ))
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: ColumnChartMedicine(
                            data: chartDataMonth,
                          ))
                        ],
                      ),
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
                                    initialTopic: "medicine",
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
