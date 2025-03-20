import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LipidProfileRepository {
  Future<String> getLipidProfileEvaluation(
    BuildContext context,
    double totalCholesterol,
    double ldlCholesterol,
    double hdlCholesterol,
    double triglycerides,
  ) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/healthIndicator/evaluation/lipid-profile?totalCholesterol=$totalCholesterol&ldlCholesterol=$ldlCholesterol&hdlCholesterol=$hdlCholesterol&triglycerides=$triglycerides');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 1) {
          return data["data"].toString();
        } else {
          CherryToast.error(
            toastDuration: Duration(seconds: 2),
            title: Text(
              "Lỗi: Status không hợp lệ (${data["message"]})",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ).show(context);
          throw Exception("Lỗi: Status không hợp lệ (${data["message"]})");
        }
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 2),
          title: Text(
            "Lỗi HTTP ${response.statusCode}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);

        throw Exception("Lỗi HTTP ${response.statusCode}");
      }
    } catch (e) {
      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Lỗi kết nối API: $e",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ).show(context);
      throw Exception("Lỗi kết nối API: $e");
    }
  }

  Future<bool> addLipidProfile({
    required BuildContext context,
    required int accountId,
    required int elderlyId,
    required double totalCholesterol,
    required double ldlCholesterol,
    required double hdlCholesterol,
    required double triglycerides,
    required String lipidProfileSource,
  }) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/lipid-profile');

    try {
      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "accountId": accountId,
          "elderlyId": elderlyId,
          "totalCholesterol": totalCholesterol.toString(),
          "ldlCholesterol": ldlCholesterol.toString(),
          "hdlCholesterol": hdlCholesterol.toString(),
          "triglycerides": triglycerides.toString(),
          "lipidProfileSource": lipidProfileSource,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == 1) {
          CherryToast.success(
              toastDuration: Duration(seconds: 2),
              title: Text("Mỡ máu đã được thêm thành công!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ))).show(context);
          return true;
        } else {
          CherryToast.error(
            toastDuration: Duration(seconds: 2),
            title: Text(
              "Lỗi: ${data["message"]}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ).show(context);

          return false;
        }
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 2),
          title: Text(
            "Lỗi HTTP ${response.statusCode}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);

        return false;
      }
    } catch (e) {
      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Lỗi kết nối API: $e",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ).show(context);

      return false;
    }
  }
}
