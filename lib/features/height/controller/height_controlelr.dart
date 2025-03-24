import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/height/repository/height_repository.dart';

final heightControllerProvider = Provider<HeightControlelr>((ref) {
  return HeightControlelr(
    heightRepository: HeightRepository(),
  );
});

class HeightControlelr {
  final HeightRepository heightRepository;

  HeightControlelr({
    required this.heightRepository,
  });

  Future<Map<String, String>> getHeightEvaluation(
    BuildContext context,
    int accountId,
    double height,
  ) async {
    try {
      final result = await heightRepository.getHeightEvaluation(
        context,
        accountId,
        height,
      );

      return result;
    } catch (e) {
      debugPrint("Error fetching height evaluation: $e");

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

  Future<bool> addHeight({
    required BuildContext context,
    required int accountId,
    required int elderlyId,
    required double height,
    required String heightSource,
  }) async {
    try {
      final success = await heightRepository.addHeight(
        context: context,
        accountId: accountId,
        elderlyId: elderlyId,
        height: height,
        heightSource: heightSource,
      );

      if (success) {}

      return success;
    } catch (e) {
      debugPrint("Error adding height: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể thêm chiều cao",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return false;
    }
  }

  Future<bool> updateHeight({
    required BuildContext context,
    required int heightId,
    required String createdBy,
    required double height,
  }) async {
    try {
      final success = await heightRepository.updateHeight(
        context: context,
        heightId: heightId,
        createdBy: createdBy,
        height: height,
      );

      if (success) {}

      return success;
    } catch (e) {
      debugPrint("Error updating height: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể cập nhật chiều cao",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return false;
    }
  }

  Future<bool> deleteHeight({
    required BuildContext context,
    required int heightId,
  }) async {
    try {
      final success = await heightRepository.deleteHeight(
        context: context,
        heightId: heightId,
      );

      if (success) {}

      return success;
    } catch (e) {
      debugPrint("Error deleting height: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể xóa chiều cao",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getHeightDetail({
    required BuildContext context,
    required int accountId,
  }) async {
    try {
      final heightDetail = await heightRepository.getHeightDetail(
        context,
        accountId,
      );

      return heightDetail;
    } catch (e) {
      debugPrint("Error fetching height detail: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể lấy chi tiết chiều cao",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return [];
    }
  }
}
