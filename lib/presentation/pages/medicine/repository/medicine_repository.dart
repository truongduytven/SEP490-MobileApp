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

  Future<dynamic> getHistoryPrescription(int userId) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/medication-management/prescription/history/$userId'));
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

  Future<dynamic> creatPresciption(
      Map<String, dynamic> prescription, String imgPath) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseUrl/medication-management'));
      request.fields['AccountId'] = prescription['accountId'].toString();
      request.fields['Treatment'] = prescription['treatment'];
      request.fields['EndDate'] = prescription['endDate'];
      request.fields['CreatedBy'] = prescription['createdBy'];
      if (imgPath != '') {
        request.files
            .add(await http.MultipartFile.fromPath('MedicationImage', imgPath));
      } else {
        request.fields['MedicationImage'] = "";
      }
      prescription['medication'].forEach((medicine) {
        request.fields[
                'Medication[${prescription['medication'].indexOf(medicine)}][medicationName]'] =
            medicine['medicationName'];
        request.fields[
                'Medication[${prescription['medication'].indexOf(medicine)}][dosage]'] =
            medicine['dosage'];
        request.fields[
                'Medication[${prescription['medication'].indexOf(medicine)}][shape]'] =
            medicine['shape'];
        request.fields[
                'Medication[${prescription['medication'].indexOf(medicine)}][isBeforeMeal]'] =
            medicine['isBeforeMeal'].toString();
        request.fields[
                'Medication[${prescription['medication'].indexOf(medicine)}][note]'] =
            medicine['note'] ?? 'nothing';
        request.fields[
                'Medication[${prescription['medication'].indexOf(medicine)}][remaining]'] =
            medicine['remaining'].toString();
        request.fields[
                'Medication[${prescription['medication'].indexOf(medicine)}][frequencyType]'] =
            medicine['frequencyType'];
        request.fields[
                'Medication[${prescription['medication'].indexOf(medicine)}][treatment]'] =
            medicine['treatment'] ?? 'string';
        medicine['frequencySelect'].length != 0
            ? medicine['frequencySelect'].forEach((frequency) {
                request.fields[
                        'Medication[${prescription['medication'].indexOf(medicine)}][frequencySelect][${medicine['frequencySelect'].indexOf(frequency)}]'] =
                    frequency;
              })
            : request.fields[
                'Medication[${prescription['medication'].indexOf(medicine)}][frequencySelect]'] = '';
        medicine['schedule'].forEach((schedule) {
          request.fields[
                  'Medication[${prescription['medication'].indexOf(medicine)}][schedule][${medicine['schedule'].indexOf(schedule)}]'] =
              schedule;
        });
      });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

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

  Future<dynamic> updatedMedicine(
      Map<String, dynamic>? prescription, int presciptionId) async {
    try {
      final response = await http.put(
          Uri.parse(
              '$baseUrl/medication-management/prescription/$presciptionId'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(prescription));
      print('response.body');
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

  Future<dynamic> cancelMedicine(int presciptionId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/medication-management/cancel/$presciptionId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
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

  Future<dynamic> scanMedicine(String imgPath, int userID) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/medication-management/scan'),
      );
      request.files.add(await http.MultipartFile.fromPath('file', imgPath));
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true, 'data': jsonResponse};
      } else {
        return {'isSuccess': false, 'data': jsonResponse};
      }
    } catch (e) {
      return {'isSuccess': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }
}
