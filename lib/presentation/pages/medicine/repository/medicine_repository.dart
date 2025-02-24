import 'dart:convert';

import 'package:http/http.dart' as http;

class MedicineRepository {
  final String baseUrl = 'https://api.diavan-valuation.asia';

  Future<dynamic> getMedicines(int userId, String day) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/medication-management/$userId/Date?day=$day'));
      if(response.statusCode == 200 || response.statusCode == 201) {
        return { 'isSuccess': true, 'data': jsonDecode(response.body) };
      } else {
        return { 'isSuccess': false, 'data': jsonDecode(response.body) };
      }
    } catch (e) {
      return { 'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!' };
    }
  }
}
