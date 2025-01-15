import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/health/add_heart_beat_screen.dart';
import 'package:sep490/presentation/pages/health/add_height_screen.dart';
import 'package:sep490/presentation/pages/health/add_weight_screen.dart';
import 'package:sep490/theme/color.dart';

class HealthMonitoringBook extends StatefulWidget {
  final String initialTopic;
  const HealthMonitoringBook({super.key, required this.initialTopic});

  @override
  State<HealthMonitoringBook> createState() => _HealthMonitoringBookState();
}

class _HealthMonitoringBookState extends State<HealthMonitoringBook> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> topics = [
    {"label": "Tất cả", "value": "all"},
    {"label": "Huyết áp", "value": "blood_pressure"},
    {"label": "Nhịp tim", "value": "heart_rate"},
    {"label": "Thuốc", "value": "medicine"},
    {"label": "Cân nặng", "value": "weight"},
    {"label": "Chiều cao", "value": "height"},
  ];

  static List<Map<String, String>> listData = [
    {
      "title": "Thuốc",
      "date": "11-01-2025",
      "time": "12:34",
      "result": "Đã bỏ qua X 1",
      "dateTime": "11 th01  12:34",
      "data": "Penicilin v kali 500mg",
      "unit": "",
      "dataType": "Thủ công"
    },
    {
      "title": "Huyết Áp",
      "result": "Cao",
      "dateTime": "11 th02  1:34",
      "date": "11-02-2025",
      "time": "01:34",
      "data": "110/90",
      "unit": "BPM",
      "dataType": "Thủ công"
    },
    {
      "title": "Nhịp tim",
      "result": "Rất Cao",
      "dateTime": "11 th04  12:34",
      "date": "11-04-2025",
      "time": "12:34",
      "data": "129",
      "unit": "BMP",
      "dataType": "Thủ công"
    },
    {
      "title": "Nhịp tim",
      "result": "Bình Thường",
      "dateTime": "19 th08  11:54",
      "date": "19-08-2025",
      "time": "11:54",
      "data": "110",
      "unit": "BMP",
      "dataType": "Thủ công"
    },
    {
      "title": "Cân nặng",
      "result": "Thấp",
      "dateTime": "1 th02  2:44",
      "date": "01-02-2024",
      "time": "2:44",
      "data": "45",
      "unit": "kg",
      "dataType": "Thủ công"
    },
    {
      "title": "Cân nặng",
      "result": "Bình Thường",
      "dateTime": "15 th01  12:44",
      "date": "15-01-2025",
      "time": "12:44",
      "data": "45",
      "unit": "kg",
      "dataType": "Thủ công"
    },
    {
      "title": "Chiều cao",
      "result": "Bình Thường",
      "dateTime": "19 th08  4:04",
      "date": "19-08-2025",
      "time": "04:04",
      "data": "170",
      "unit": "cm",
      "dataType": "Thiết bị IOT"
    },
  ];

  late String selectedTopic;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedTopic();
    });
    selectedTopic = widget.initialTopic;
    // Sort the listData by date and time from newest to oldest
    listData.sort((a, b) {
      String convertDateFormat(String date) {
        List<String> parts = date.split("-");
        return "${parts[2]}-${parts[1]}-${parts[0]}"; // YYYY-MM-DD
      }

      String formatTime(String time) {
        List<String> parts = time.split(":");
        String hour = parts[0].padLeft(2, '0');
        return "$hour:${parts[1]}";
      }

      DateTime dateTimeA = DateTime.parse(
          '${convertDateFormat(a["date"]!)} ${formatTime(a["time"]!)}');
      DateTime dateTimeB = DateTime.parse(
          '${convertDateFormat(b["date"]!)} ${formatTime(b["time"]!)}');
      return dateTimeB.compareTo(dateTimeA); // Descending order
    });
  }

  void _scrollToSelectedTopic() {
    int selectedIndex =
        topics.indexWhere((topic) => topic["value"] == selectedTopic);

    if (selectedIndex != -1) {
      // Calculate the scroll position dynamically
      double scrollPosition =
          selectedIndex * 80.0; // Adjust 80.0 to match item width
      _scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Function to get the image path based on the title
  String getImagePath(String title) {
    switch (title) {
      case "Huyết Áp":
        return "assets/img3D/huyetap.png";
      case "Nhịp tim":
        return "assets/img3D/nhiptim.png";
      case "Thuốc":
        return "assets/img3D/thuoc.png";
      case "Cân nặng":
        return "assets/img3D/cannang.png";
      case "Chiều cao":
        return "assets/img3D/chieucao.png";
      default:
        return "assets/img/Logo.png";
    }
  }

  // Group data by date
  Map<String, List<Map<String, String>>> groupDataByDate(
      List<Map<String, String>> filteredData) {
    Map<String, List<Map<String, String>>> groupedData = {};
    for (var item in filteredData) {
      final date = item["date"]!;
      if (!groupedData.containsKey(date)) {
        groupedData[date] = [];
      }
      groupedData[date]!.add(item);
    }
    return groupedData;
  }

  void navigateToCardDetail(Map<String, String> item) {
    print("Vo dya");

    // Switch case for different titles
    switch (item["title"]) {
      case "Nhịp tim":
        // Navigate to NhịpTimCard
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddHeartBeatScreen(
                  date: item['date'],

                  currentValue: num.tryParse(item["data"] ?? "") ?? 0,
                  showHeartBeatWidget: true,
                  isDraft: false)),
        );
        break;

      case "Huyết Áp":
        // Navigate to HuyetApCard
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: Text("Huyết Áp")),
              body: Text("Huyết Áp details: ${item['title']}"),
            ),
          ),
        );
        break;

      case "Cân nặng":
        // Navigate to CanNangCard
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddWeight(
                  date: item['date'],
                  currentValue: num.tryParse(item["data"] ?? "") ?? 0,
                  showWeightWidget: true,
                  isDraft: false)),
        );
        break;

      case "Chiều cao":
        // Navigate to ChieuCaoCard
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddHeightScreen(
                  date: item['date'],
                  currentValue: num.tryParse(item['data'] ?? "") ?? 0,
                  showHeightWidget: true,
                  isDraft: false)),
        );
        break;

      default:
        // Handle case where the title doesn't match any of the above
        print("No card detail screen for ${item['title']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter listData based on the selectedTopic (compare using value from topics)
    List<Map<String, String>> filteredData = listData.where((item) {
      if (selectedTopic == "all") {
        return true; // Show all topics
      }
      String normalizeString(String str) {
        return str.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
      }

      // Get the label corresponding to the selected topic value
      String? selectedLabel = topics.firstWhere(
          (topic) => topic["value"] == selectedTopic,
          orElse: () => {"label": ""})["label"];
      return normalizeString(item["title"]!) ==
          normalizeString(
              selectedLabel!); // Compare title with the selected label
    }).toList();

    // Group filtered data by date
    Map<String, List<Map<String, String>>> filteredGroupedData =
        groupDataByDate(filteredData);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Sổ theo dõi",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Row(
              children: topics
                  .map(
                    (topic) => Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 15, right: 5),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTopic =
                                topic["value"]!; // Update the selected topic
                          });
                        },
                        child: Chip(
                          labelStyle: TextStyle(
                              fontSize: 18,
                              color: selectedTopic == topic["value"]
                                  ? AppColors.bgColor
                                  : AppColors.secondaryColor),
                          label: Text(topic["label"]!),
                          backgroundColor: selectedTopic == topic["value"]
                              ? AppColors.secondaryColor
                              : AppColors.borderColor,
                          side: selectedTopic == topic["value"]
                              ? null
                              : BorderSide(
                                  color: AppColors.borderColor,
                                ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // Wrap the ListView inside Expanded to avoid layout issues
          Expanded(
            child: filteredGroupedData.isNotEmpty
                ? ListView(
                    children: filteredGroupedData.entries.map((entry) {
                      final date = entry.key;
                      final items = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              date,
                              style: const TextStyle(
                                  color: AppColors.grayColor5,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          ...items.map((item) {
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: AppColors.secondaryColor,
                                    width: 0.1),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              color: AppColors.bgColor,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: ListTile(
                                  leading: Image.asset(
                                    getImagePath(item["title"]!),
                                    width: 50,
                                    height: 50,
                                  ),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${item["result"]}",
                                        style: const TextStyle(
                                          color: AppColors.grayColor5,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                      item["title"] == "Thuốc"
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left:
                                                      8.0), // Add space between result and time
                                              child: Text(
                                                "${item["time"]}",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      AppColors.secondaryColor,
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                  subtitle: Text(
                                    "${item["data"]} ${item['unit']}",
                                    style: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onTap: () {
                                    // Navigate to the card detail screen when tapped
                                    navigateToCardDetail(item);
                                  },
                                  trailing: item["title"] == "Thuốc"
                                      ? null
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              " ${item["time"]}",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      AppColors.secondaryColor),
                                            ),
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/img3D/nodata.webp",
                        width: 250,
                        height: 250,
                      ),
                      Text(
                        "Chưa có dữ liệu",
                        style: TextStyle(
                            fontSize: 20,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
