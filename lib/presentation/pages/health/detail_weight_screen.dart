import 'package:flutter/material.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tab Bar
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
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
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: tabs.map((tab) {
                  return Center(
                    child: Text(
                      'Content for $tab',
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Marker Pointer Chart
            // Wrap with Flexible or SizedBox to avoid unconstrained rendering issues
            SizedBox(
              height: 150, // Ensure it has a fixed height
              child: MarkerPointerChart(value: 50),
            ),
          ],
        ),
      ),
    );
  }
}
