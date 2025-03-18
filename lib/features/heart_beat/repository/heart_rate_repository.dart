import 'dart:convert';
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
          showSnackBar(
              context: context,
              content: "Lỗi: Status không hợp lệ (${data["message"]})");
          throw Exception("Lỗi: Status không hợp lệ (${data["message"]})");
        }
      } else {
        showSnackBar(
            context: context, content: "Lỗi HTTP ${response.statusCode}");
        throw Exception("Lỗi HTTP ${response.statusCode}");
      }
    } catch (e) {
      showSnackBar(context: context, content: "Lỗi kết nối API: $e");
      throw Exception("Lỗi kết nối API: $e");
    }
  }
}
