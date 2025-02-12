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

      if (response.statusCode == 200) {
        return { 'success': true, 'data': jsonDecode(response.body) };
      } else {
        return { 'success': false, 'data': jsonDecode(response.body) };
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
      print(response.body);
      final decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': decodedResponse};
      } else {
        return {'success': false, 'data': decodedResponse};
      }
    } catch (e) {
      return {'success': false, 'data': 'Có lỗi trong quá trình xử lý!'};
    }
  }

  static Future<Map<String, dynamic>> postRequestSignUp(
      String endpoint, File imageFile) async {
    final Uri url = Uri.parse("$_baseUrl/$endpoint");

    var request = http.MultipartRequest("POST", url);

    request.files.add(
      await http.MultipartFile.fromPath(
        "avatar",
        imageFile.path,
        filename: basename(imageFile.path),
      ),
    );

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      print(responseData);
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
