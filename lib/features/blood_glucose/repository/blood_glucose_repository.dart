import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BloodGlucoseRepository {
  Future<String> getBloodGlucoseEvaluation(
    BuildContext context,
    double bloodGlucose,
    String period,
  ) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/healthIndicator/evaluation/blood-glucose?bloodGlucose=${bloodGlucose}&time=$period');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Kiểm tra nếu status == 1
        if (data["status"] == 1) {
          return data["data"].toString();
        } else {
          CherryToast.error(
            toastDuration: Duration(seconds: 3),
            title: Text(
              "Lỗi: Status không hợp lệ (${data["message"]})",
              style: TextStyle(color: Colors.black),
            ),
          ).show(context);
          throw Exception("Lỗi: Status không hợp lệ (${data["message"]})");
        }
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Lỗi HTTP ${response.statusCode}",
            style: TextStyle(color: Colors.black),
          ),
        ).show(context);

        throw Exception("Lỗi HTTP ${response.statusCode}");
      }
    } catch (e) {
      CherryToast.error(
        toastDuration: Duration(seconds: 3),
        title: Text(
          "Lỗi kết nối API: $e",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);
      throw Exception("Lỗi kết nối API: $e");
    }
  }

  Future<bool> addBloodGlucose({
    required BuildContext context,
    required int elderlyId,
    required double bloodGlucose,
    required String bloodGlucoseSource,
    required String period,
    required String createdBy,
  }) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/blood-glucose');

    try {
      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "accountId": elderlyId,
          "bloodGlucose1": bloodGlucose.toString(),
          "bloodGlucoseSource": bloodGlucoseSource,
          "time": period,
          "createdBy": createdBy,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["status"] == 1) {
          CherryToast.success(
                  toastDuration: Duration(seconds: 2),
                  title: Text("Đường huyết đã được thêm thành công!",
                      style: TextStyle(color: Colors.black)))
              .show(context);
          return true;
        } else {
          CherryToast.error(
            toastDuration: Duration(seconds: 3),
            title: Text(
              "Lỗi: ${data["message"]}",
              style: TextStyle(color: Colors.black),
            ),
          ).show(context);

          return false;
        }
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Lỗi HTTP ${response.statusCode}",
            style: TextStyle(color: Colors.black),
          ),
        ).show(context);

        return false;
      }
    } catch (e) {
      CherryToast.error(
        toastDuration: Duration(seconds: 3),
        title: Text(
          "Lỗi kết nối API: $e",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return false;
    }
  }
}
