import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
          toastDuration: Duration(seconds: 2), // Hiển thị trong 2 giây
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
        toastDuration: Duration(seconds: 2), // Hiển thị trong 2 giây
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

  Future<bool> addHeartRate({
    required BuildContext context,
    required int accountId,
    required int elderlyId,
    required int heartRate,
    required String heartRateSource,
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
          "accountId": accountId,
          "elderlyId": elderlyId,
          "heartRate1": heartRate,
          "heartRateSource": heartRateSource,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == 1) {
          CherryToast.success(
              toastDuration: Duration(seconds: 2),
              title: Text("Nhịp tim đã được thêm thành công!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ))).show(context);
          return true;
        } else {
          CherryToast.error(
            toastDuration: Duration(seconds: 2), // Hiển thị trong 2 giây
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
          toastDuration: Duration(seconds: 2), // Hiển thị trong 2 giây
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
        toastDuration: Duration(seconds: 2), // Hiển thị trong 2 giây
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

  Future<bool> updateHeartRate({
    required BuildContext context,
    required int heartRateId,
    required String createdBy,
    required int heartRate,
  }) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/update-heart-rate/$heartRateId?createdBy=$createdBy');

    try {
      final response = await http.put(
        url,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(heartRate),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["status"] == 1) {
          CherryToast.success(
              toastDuration: Duration(seconds: 2),
              title: Text("Nhịp tim đã cập nhật thành công!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ))).show(context);
          return true;
        } else {
          CherryToast.error(
            toastDuration: Duration(seconds: 3),
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
          toastDuration: Duration(seconds: 3),
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
        toastDuration: Duration(seconds: 3),
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

  Future<bool> deleteHeartRate({
    required BuildContext context,
    required int heartRateId,
  }) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/update-status/heart-rate/$heartRateId  ');

    try {
      final response = await http.put(
        url,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode("Inactive"),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["status"] == 1) {
          CherryToast.success(
              toastDuration: Duration(seconds: 2),
              title: Text("Đã xóa nhịp tim thành công!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ))).show(context);
          return true;
        } else {
          CherryToast.error(
            toastDuration: Duration(seconds: 3),
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
          toastDuration: Duration(seconds: 3),
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
        toastDuration: Duration(seconds: 3),
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

  Future<List<Map<String, dynamic>>> getHeartRateDetail(
    BuildContext context,
    int id,
  ) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/healthIndicator/heartRate/detail/$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 1) {
          final List<dynamic> heartRateData = data["data"];
          return heartRateData.map((item) {
            return {
              "tabs": item["tabs"],
              "average": item["average"],
              "evaluation": item["evaluation"],
              "chartDatabase": item["chartDatabase"],
            };
          }).toList();
        } else {
          CherryToast.error(
            toastDuration: Duration(seconds: 3),
            title: Text(
              "Lỗi: ${data["message"]}",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ).show(context);
          throw Exception("Lỗi: ${data["message"]}");
        }
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Lỗi HTTP ${response.statusCode}",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ).show(context);
        throw Exception("Lỗi HTTP ${response.statusCode}");
      }
    } catch (e) {
      CherryToast.error(
        toastDuration: Duration(seconds: 3),
        title: Text(
          "Lỗi kết nối API: $e",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ).show(context);
      throw Exception("Lỗi kết nối API: $e");
    }
  }
}
