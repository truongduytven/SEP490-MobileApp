import 'dart:convert';

import 'package:http/http.dart' as http;

class EmergencyRepository {
  final String baseUrl = 'https://api.diavan-valuation.asia';

  Future<dynamic> createConfirmation(int accountID) async {
    try {
      final response = await http.post(Uri.parse(
          '$baseUrl/emergency-contacts/emergency-confirmation?elderlyId=$accountID'));

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

  Future<dynamic> createEmergencyInformation(
      int emergencyId,
      String imgFrontCamera,
      String imgRearCamera,
      String longitude,
      String latitude,
      bool isCallProfessor,
      bool isSendMessage) async {
    try {
      final request = http.MultipartRequest('POST',
          Uri.parse('$baseUrl/emergency-contacts/emergency-information'));
      request.fields['EmergencyConfirmationId'] = emergencyId.toString();
      request.fields['Longitude'] = longitude;
      request.fields['Latitude'] = latitude;
      request.fields['CallProfessor'] = isCallProfessor.toString();
      request.fields['IsSendMessage'] = isSendMessage.toString();
      if (imgFrontCamera != '') {
        request.files.add(await http.MultipartFile.fromPath(
            'FrontCameraImage', imgFrontCamera));
      } else {
        request.fields['FrontCameraImage'] = "";
      }
      if (imgRearCamera != '') {
        request.files.add(await http.MultipartFile.fromPath(
            'RearCameraImage', imgRearCamera));
      } else {
        request.fields['RearCameraImage'] = "";
      }
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

  Future<dynamic> getEmergencyConfirm(int emergencyId) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/emergency-contacts/emergency-confirmation/$emergencyId'));

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

  Future<dynamic> getEmergencyList(int accountId) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/emergency-contacts/list-emergency-confirmation-of-family-member/$accountId'));

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

  Future<dynamic> getEmergencyDetail(int emergencyId) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/emergency-contacts/newest-emergency-information/$emergencyId'));

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

  Future<dynamic> getEmergencyListDetail(int emergencyId) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/emergency-contacts/list-emergency-information/$emergencyId'));

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
