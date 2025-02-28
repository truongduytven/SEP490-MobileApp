import 'dart:convert';

class Activity {
  final String title;
  final String description;
  final String startTime;
  final String endTime;
  final int elderlyId;
  final String type;

  Activity({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.elderlyId,
    required this.type,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      title: json['title'],
      description: json['description'],
      startTime: json['startTime'],
      endTime: json['endTime'] ?? '',
      elderlyId: json['elderlyId'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "startTime": startTime,
      "endTime": endTime,
      "elderlyId": elderlyId,
      "type": type,
    };
  }
}

List<Activity> parseScheduleList(String jsonString) {
  final List<dynamic> decodedList = json.decode(jsonString);
  return decodedList.map((item) => Activity.fromJson(item)).toList();
}