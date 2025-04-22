import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeRepository {
  final String baseUrl = 'https://api.diavan-valuation.asia';

  Future<dynamic> getHealthIndicator(int account) async {
    try {
      final response = await http.get(
          Uri.parse("$baseUrl/api/HealthIndicator/healthIndicator/$account"));
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

  Future<dynamic> getElderlyUser(int account) async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/groups/elderly/$account"));
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

  Future<dynamic> getElderlyUserProfessor(int account) async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/api/Professor/elderly/$account"));
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

  Future<dynamic> getElderlyProfile(int account) async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/profile-management/$account"));
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

  Future<dynamic> getMedicalRecord(int account) async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/profile-management/elderly/$account"));
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

  Future<dynamic> updateMedicalRecord(
      int account, List<String> medicalRecord) async {
    try {
      final response =
          await http.put(Uri.parse("$baseUrl/profile-management/elderly"),
              body: jsonEncode({
                'elderlyId': account,
                'allergy': "string",
                'livingSituation': "string",
                'medicalRecord': medicalRecord,
              }),
              headers: {
            'Content-Type': 'application/json',
          });
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

  Future<dynamic> updateElderlyProfile(int account, String fullName,
      String imagePath, String gender, String dateOfBirth) async {
    try {
      final uri = Uri.parse("$baseUrl/profile-management");
      final request = http.MultipartRequest('PUT', uri);
      request.fields['FullName'] = fullName;
      request.fields['Gender'] = gender;
      request.fields['Dob'] = dateOfBirth;
      if (imagePath != "") {
        request.files
            .add(await http.MultipartFile.fromPath('Avatar', imagePath));
      }
      request.fields['AccountId'] = account.toString();
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final result = jsonDecode(respStr);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 1) {
          return {'isSuccess': true, 'data': result};
        } else {
          return {'isSuccess': false, 'data': result};
        }
      } else {
        return {'isSuccess': false, 'data': result};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  Future<dynamic> getHistoryTransaction(int account) async {
    try {
      final response = await http.get(Uri.parse(
          "$baseUrl/booking-management/bookings/family-member/$account"));
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
