import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LiverEnzymesRepository {
  Future<String> getLiverEnzymesEvaluation(
    BuildContext context,
    double alt,
    double ast,
    double alp,
    double ggt,
  ) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/healthIndicator/evaluation/liver-enzymes?alt=$alt&ast=$ast&alp=$alp&ggt=$ggt');

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

  Future<bool> addLiverEnzymes({
    required BuildContext context,
    required int accountId,
    required int elderlyId,
    required double alt,
    required double ast,
    required double alp,
    required double ggt,
    required String liverEnzymesSource,
  }) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/liver-enzymes');

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
          "alt": alt.toString(),
          "ast": ast.toString(),
          "alp": alp.toString(),
          "ggt": ggt.toString(),
          "liverEnzymesSource": liverEnzymesSource,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == 1) {
          CherryToast.success(
              toastDuration: Duration(seconds: 2),
              title: Text("Men gan đã được thêm thành công!",
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

  Future<bool> updateLiverEnzymes({
    required BuildContext context,
    required int liverEnzymesId,
    required String createdBy,
    required double alt,
    required double ast,
    required double alp,
    required double ggt,
  }) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/update-liver-enzymes/$liverEnzymesId?createdBy=$createdBy');

    try {
      final response = await http.put(
        url,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "alt": alt,
          "ast": ast,
          "alp": alp,
          "ggt": ggt,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["status"] == 1) {
          CherryToast.success(
              toastDuration: Duration(seconds: 2),
              title: Text("Men gan đã cập nhật thành công!",
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

  Future<bool> deleteLiverEnzymes({
    required BuildContext context,
    required int liverEnzymesId,
  }) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/update-status/liver-enzymes/$liverEnzymesId');

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
              title: Text("Đã xóa men gan thành công!",
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

  Future<List<Map<String, dynamic>>> getLiverEnzymesDetail(
    BuildContext context,
    int id,
  ) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/healthIndicator/liver-enzymes/detail/$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 1) {
          final List<dynamic> liverEnzymesData = data["data"];
          return liverEnzymesData.map((item) {
            return {
              "tabs": item["tabs"],
              "altAverage": item["altAverage"],
              "astAverage": item["astAverage"],
              "alpAverage": item["alpAverage"],
              "ggtAverage": item["ggtAverage"],
              "highestPercent": item["highestPercent"],
              "lowestPercent": item["lowestPercent"],
              "normalPercent": item["normalPercent"],
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
