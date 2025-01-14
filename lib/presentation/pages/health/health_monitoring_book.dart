import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class HealthMonitoringBook extends StatefulWidget {
  final String initialTopic;
  const HealthMonitoringBook({super.key, required this.initialTopic});

  @override
  State<HealthMonitoringBook> createState() => _HealthMonitoringBookState();
}

class _HealthMonitoringBookState extends State<HealthMonitoringBook> {
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
      "date": "01-02-2025",
      "time": "2:44",
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
    selectedTopic = widget.initialTopic;
    // Sort the listData by date and time from newest to oldest
    listData.sort((a, b) {
      // Convert DD-MM-YYYY to YYYY-MM-DD
      String convertDateFormat(String date) {
        List<String> parts = date.split("-");
        return "${parts[2]}-${parts[1]}-${parts[0]}"; // YYYY-MM-DD
      }

      // Ensure the time is in HH:mm format (adds leading zero if necessary)
      String formatTime(String time) {
        List<String> parts = time.split(":");
        String hour = parts[0].padLeft(2, '0'); // Add leading zero if needed
        return "$hour:${parts[1]}";
      }

      DateTime dateTimeA = DateTime.parse(
          '${convertDateFormat(a["date"]!)} ${formatTime(a["time"]!)}');
      DateTime dateTimeB = DateTime.parse(
          '${convertDateFormat(b["date"]!)} ${formatTime(b["time"]!)}');
      return dateTimeB.compareTo(dateTimeA); // Descending order
    });
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
  Map<String, List<Map<String, String>>> groupDataByDate() {
    Map<String, List<Map<String, String>>> groupedData = {};
    for (var item in listData) {
      final date = item["date"]!;
      if (!groupedData.containsKey(date)) {
        groupedData[date] = [];
      }
      groupedData[date]!.add(item);
    }
    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    final groupedData = groupDataByDate();

    return Scaffold(
      appBar: AppBar(
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
            child: ListView(
              children: groupedData.entries.map((entry) {
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
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...items.map((item) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: ListTile(
                          leading: Image.asset(
                            getImagePath(item["title"]!),
                            width: 40,
                            height: 40,
                          ),
                          title: Text(
                            item["title"]!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle:
                              Text("${item["result"]} - ${item["dateTime"]}"),
                          trailing: item["title"] == "Thuốc"
                              ? null
                              : const Icon(Icons.arrow_forward_ios),
                        ),
                      );
                    }).toList(),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
