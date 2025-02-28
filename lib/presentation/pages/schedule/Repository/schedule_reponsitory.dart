import 'dart:convert';

import 'package:http/http.dart' as http;

class ScheduleRepository {
  final String baseUrl = 'https://api.diavan-valuation.asia';

  Future<dynamic> getSchedule(int userId, String day) async {
    try {
      final response = await http.get(
          Uri.parse("$baseUrl/activity-management?day=$day&elderlyID=$userId"));
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
