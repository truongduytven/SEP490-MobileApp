import 'dart:convert';

import 'package:http/http.dart' as http;

class ScheduleRepository {
  final String baseUrl = 'https://api.diavan-valuation.asia';

  Future<dynamic> getSchedule(int userId, String day) async {
    try {
      final response = await http.get(
          Uri.parse("$baseUrl/activity-management?day=$day&AccountId=$userId"));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> createActivity(Map<String, dynamic> activity) async {
    try {
      final response = await http.post(
          Uri.parse("$baseUrl/activity-management"),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(activity));   

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> updateActivity(Map<String, dynamic> activity) async {
    try {
      final response = await http.put(
          Uri.parse("$baseUrl/activity-management/update"),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(activity)); 
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> changeStatusActivity(int activityId, String date) async {
    try {
      final response = await http.put(
          Uri.parse("$baseUrl/activity-management/update/status?activityID=$activityId&date=$date"));
          
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'] == 1) {
          return {'isSuccess': true, 'data': jsonDecode(response.body)};
        } else {
          return {'isSuccess': false, 'data': jsonDecode(response.body)};
        }
      } else {
        return {'isSuccess': false, 'data': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }
}
