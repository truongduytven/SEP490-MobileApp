import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cherry_toast/cherry_toast.dart';

class HealthRepository {
  Future<List<Map<String, String>>> getHealthIndicators(
    BuildContext context,
    int accountId,
  ) async {
    final url = Uri.parse(
        'https://api.diavan-valuation.asia/api/HealthIndicator/healthIndicator/$accountId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 1) {
          final List<dynamic> indicators = data["data"];

          return indicators.map((indicator) {
            return {
              "tabs": indicator["tabs"].toString(),
              "evaluation": indicator["evaluation"].toString(),
              "dateTime": indicator["dateTime"].toString(),
              "indicator": indicator["indicator"].toString(),
              "averageIndicator": indicator["averageIndicator"].toString(),
            };
          }).toList();
        } else {
          _showErrorToast(context, "Lỗi: ${data["message"]}");
          throw Exception("Lỗi: ${data["message"]}");
        }
      } else {
        _showErrorToast(context, "Lỗi HTTP ${response.statusCode}");
        throw Exception("Lỗi HTTP ${response.statusCode}");
      }
    } catch (e) {
      _showErrorToast(context, "Lỗi kết nối API: $e");
      throw Exception("Lỗi kết nối API: $e");
    }
  }

  void _showErrorToast(BuildContext context, String message) {
    CherryToast.error(
      toastDuration: Duration(seconds: 3),
      title: Text(
        message,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    ).show(context);
  }
}
