import 'dart:convert';

class Activity {
  final int activityId;
  final String title;
  final String description;
  final int duration;
  final String startTime;
  final String endTime;
  final String createdBy;
  final String type;

  Activity({
    required this.activityId,
    required this.title,
    required this.description,
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.createdBy,
    required this.type,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      activityId: json['activityId'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? 0,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      createdBy: json['createdBy'] ?? '',
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "activityId": activityId,
      "title": title,
      "description": description,
      "duration": duration,
      "startTime": startTime,
      "endTime": endTime,
      "createdBy": createdBy,
      "type": type,
    };
  }
}

List<Activity> parseScheduleList(String jsonString) {
  final List<dynamic> decodedList = json.decode(jsonString);
  return decodedList.map((item) => Activity.fromJson(item)).toList();
}