import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sep490/common/utils/utils.dart';

class HeartRateRepository {
  Future<String> getHeartRateEvaluation(
      BuildContext context, int heartRate) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/healthIndicator/evaluation/heart-rate?heartRate=$heartRate');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Kiểm tra nếu status == 1
        if (data["status"] == 1) {
          return data["data"].toString(); // Trả về dữ liệu nếu status == 1
        } else {
          CherryToast.error(
            toastDuration: Duration(seconds: 2), // Hiển thị trong 2 giây
            title: Text(
              "Lỗi: Status không hợp lệ (${data["message"]})",
              style: TextStyle(color: Colors.black),
            ),
          ).show(context);
          throw Exception("Lỗi: Status không hợp lệ (${data["message"]})");
        }
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 2), // Hiển thị trong 2 giây
          title: Text(
            "Lỗi HTTP ${response.statusCode}",
            style: TextStyle(color: Colors.black),
          ),
        ).show(context);

        throw Exception("Lỗi HTTP ${response.statusCode}");
      }
    } catch (e) {
      CherryToast.error(
        toastDuration: Duration(seconds: 2), // Hiển thị trong 2 giây
        title: Text(
          "Lỗi kết nối API: $e",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);
      throw Exception("Lỗi kết nối API: $e");
    }
  }

  Future<bool> addHeartRate({
    required BuildContext context,
    required int elderlyId,
    required int heartRate,
    required String heartRateSource,
    required String createdBy,
  }) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/heart-rate');

    try {
      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "elderlyId": elderlyId,
          "heartRate": heartRate,
          "heartRateSource": heartRateSource,
          "createdBy": createdBy,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["status"] == 1) {
          CherryToast.success(
                  toastDuration: Duration(seconds: 2),
                  title: Text("Nhịp tim đã được thêm thành công!",
                      style: TextStyle(color: Colors.black)))
              .show(context);
          return true;
        } else {
          CherryToast.error(
            toastDuration: Duration(seconds: 2), // Hiển thị trong 2 giây
            title: Text(
              "Lỗi: ${data["message"]}",
              style: TextStyle(color: Colors.black),
            ),
          ).show(context);

          return false;
        }
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 2), // Hiển thị trong 2 giây
          title: Text(
            "Lỗi HTTP ${response.statusCode}",
            style: TextStyle(color: Colors.black),
          ),
        ).show(context);

        return false;
      }
    } catch (e) {
      CherryToast.error(
        toastDuration: Duration(seconds: 2), // Hiển thị trong 2 giây
        title: Text(
          "Lỗi kết nối API: $e",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return false;
    }
  }
}
