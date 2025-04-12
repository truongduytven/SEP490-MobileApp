import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';


class ApiService {
  static const String _baseUrl = "https://api.diavan-valuation.asia";

  static Future<Map<String, dynamic>> getRequest(String endpoint, {Map<String, String>? headers}) async {
    final Uri url = Uri.parse("$_baseUrl/$endpoint");

    try {
      final response = await http.get(url, headers: headers ?? {"Content-Type": "application/json"});

      if (response.statusCode == 200 || jsonDecode(response.body)['status'] == 1) {
        return { 'success': true, 'data': jsonDecode(response.body) };
      } else {
        return { 'success': false, 'data': jsonDecode(response.body)['message'] };
      }
    } catch (e) {
      return { 'success': false, 'data': 'Có lỗi trong quá trình xử lý!' }; 
    }
  }

  static Future<Map<String, dynamic>> postRequest(
      String endpoint, Map<String, dynamic> data) async {
    final Uri url = Uri.parse("$_baseUrl/$endpoint");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      final decodedResponse = jsonDecode(response.body);
      print(decodedResponse);
      if (response.statusCode == 200 || response.statusCode == 201 || decodedResponse['status'] == 1) {
        return {'success': true, 'data': decodedResponse};
      } else {
        return {'success': false, 'data': decodedResponse};
      }
    } catch (e) {
      print(e);
      return {'success': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  static Future<Map<String, dynamic>> postRequestSignUp(
      String endpoint, String imageFile) async {
    final Uri url = Uri.parse("$_baseUrl/$endpoint");

    var request = http.MultipartRequest("POST", url);

    request.files.add(
      await http.MultipartFile.fromPath(
        "avatar",
        imageFile,
      ),
    );

    // request.files.add(await http.MultipartFile.fromPath('MedicationImage', imgPath));

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': decodedResponse};
      } else {
        return {'success': false, 'data': decodedResponse};
      }
    } catch (e) {
      return {'success': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }
}
