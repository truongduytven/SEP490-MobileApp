import 'dart:convert';

import 'package:http/http.dart' as http;

class MedicineRepository {
  final String baseUrl = 'https://api.diavan-valuation.asia';

  // get presciption by user id and day
  Future<dynamic> getMedicines(int userId, String day) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/medication-management/$userId/date?day=$day'));
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

  // get presciption by user id)
  Future<dynamic> getPresciption(int userId) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/medication-management/prescription/$userId'));
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
  
  Future<dynamic> creatPresciption(Map<String, dynamic> prescription) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/medication-management'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode(prescription));
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

  Future<dynamic> updatedMedicine(Map<String, dynamic>? prescription, int presciptionId) async {
    try {
      final response =
          await http.put(Uri.parse('$baseUrl/medication-management/prescription/$presciptionId'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode(prescription));
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

  Future<dynamic> cancelMedicine(int presciptionId) async {
    try {
      final response =
          await http.put(Uri.parse('$baseUrl/medication-management/cancel/$presciptionId'),
              headers: {
                'Content-Type': 'application/json',
              },);
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

  Future<dynamic> confirmMedicine(Map<String, dynamic> medicines) async {
    try {
      final response =
          await http.put(Uri.parse('$baseUrl/medication-management/confirm'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode(medicines));

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
}



