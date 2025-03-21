import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/heart_beat/repository/heart_rate_repository.dart';
import 'package:sep490/features/height/repository/height_repository.dart';
import 'package:sep490/features/weight/repository/weight_repository.dart';

final weightControllerProvider = Provider<WeightControlelr>((ref) {
  return WeightControlelr(
    weightRepository: WeightRepository(),
  );
});

class WeightControlelr {
  final WeightRepository weightRepository;

  WeightControlelr({
    required this.weightRepository,
  });

  Future<Map<String, String>> getWeightEvaluation(
    BuildContext context,
    int accountId,
    double weight,
  ) async {
    try {
      final result = await weightRepository.getWeightEvaluation(
        context,
        accountId,
        weight,
      );

      return result;
    } catch (e) {
      debugPrint("Error fetching weight evaluation: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể lấy đánh giá: $e",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ).show(context);

      return {
        "evaluation": "Lỗi",
        "bmi": "N/A",
      };
    }
  }

  Future<bool> addWeight({
    required BuildContext context,
    required int accountId,
    required int elderlyId,
    required double weight,
    required String weightSource,
  }) async {
    try {
      final success = await weightRepository.addWeight(
        context: context,
        accountId: accountId,
        elderlyId: elderlyId,
        weight: weight,
        weightSource: weightSource,
      );

      if (success) {}

      return success;
    } catch (e) {
      debugPrint("Error adding weight: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể thêm cân nặng",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getWeightDetail({
    required BuildContext context,
    required int accountId,
  }) async {
    try {
      final heightDetail = await weightRepository.getWeightDetail(
        context,
        accountId,
      );

      return heightDetail;
    } catch (e) {
      debugPrint("Error fetching weight detail: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể lấy chi tiết cân nặng",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return [];
    }
  }
}
