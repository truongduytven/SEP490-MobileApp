import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HeightRepository {
  Future<Map<String, String>> getHeightEvaluation(
    BuildContext context,
    int accountId,
    double height,
  ) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/healthIndicator/evaluation/bmi?height=$height&accountId=$accountId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 1) {
          final evaluationData = data["data"];

          if (evaluationData is Map<String, dynamic>) {
            return {
              "evaluation": evaluationData["evaluation"].toString(),
              "bmi": evaluationData["bmi"].toString(),
            };
          } else {
            throw Exception("Lỗi: Dữ liệu không hợp lệ");
          }
        } else {
          CherryToast.error(
            toastDuration: Duration(seconds: 3),
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
          toastDuration: Duration(seconds: 3),
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
        toastDuration: Duration(seconds: 3),
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

  Future<bool> addHeight({
    required BuildContext context,
    required int accountId,
    required int elderlyId,
    required double height,
    required String heightSource,
  }) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/height');

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
          "height1": height,
          "heightSource": heightSource,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == 1) {
          CherryToast.success(
              toastDuration: Duration(seconds: 2),
              title: Text("Chiều cao đã được thêm thành công!",
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

  Future<List<Map<String, dynamic>>> getHeightDetail(
    BuildContext context,
    int id,
  ) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/healthIndicator/height/detail/$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 1) {
          final List<dynamic> heightData = data["data"];
          return heightData.map((item) {
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
