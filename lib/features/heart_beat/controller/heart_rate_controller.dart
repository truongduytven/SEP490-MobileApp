import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/heart_beat/repository/heart_rate_repository.dart';

final heartRateControllerProvider = Provider<HeartRateController>((ref) {
  return HeartRateController(
    heartRateRepository: HeartRateRepository(),
  );
});

class HeartRateController {
  final HeartRateRepository heartRateRepository;

  HeartRateController({
    required this.heartRateRepository,
  });

  Future<String> getHeartRateEvaluation(
      BuildContext context, int heartRate) async {
    try {
      final result =
          await heartRateRepository.getHeartRateEvaluation(context, heartRate);

      return result;
    } catch (e) {
      debugPrint("Error fetching heart rate evaluation: $e");

      return "Không thể lấy đánh giá";
    }
  }

  Future<bool> addHeartRate({
    required BuildContext context,
    required int accountId,
    required int elderlyId,
    required int heartRate,
    required String heartRateSource,
  }) async {
    try {
      final success = await heartRateRepository.addHeartRate(
        context: context,
        accountId: accountId,
        elderlyId: elderlyId,
        heartRate: heartRate,
        heartRateSource: heartRateSource,
      );

      if (success) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Nhịp tim đã được thêm thành công!'),
        //     backgroundColor: Colors.green,
        //   ),
        // );
      }

      return success;
    } catch (e) {
      debugPrint("Error adding heart rate: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2), // Hiển thị trong 2 giây
        title: Text(
          "Không thể thêm nhịp tim",
          style: TextStyle(color: Colors.black),
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
    try {
      final success = await heartRateRepository.updateHeartRate(
        context: context,
        heartRateId: heartRateId,
        createdBy: createdBy,
        heartRate: heartRate,
      );

      if (success) {}

      return success;
    } catch (e) {
      debugPrint("Error updating heart rate: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể cập nhật nhịp tim",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return false;
    }
  }

  Future<bool> deleteHeartRate({
    required BuildContext context,
    required int heartRateId,
  }) async {
    try {
      final success = await heartRateRepository.deleteHeartRate(
        context: context,
        heartRateId: heartRateId,
      );

      if (success) {}

      return success;
    } catch (e) {
      debugPrint("Error deleting  heart rate: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể xóa nhịp tim",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getHeartRatetDetail({
    required BuildContext context,
    required int accountId,
  }) async {
    try {
      final heartRateDetail = await heartRateRepository.getHeartRateDetail(
        context,
        accountId,
      );

      return heartRateDetail;
    } catch (e) {
      debugPrint("Error fetching heart rate detail: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể lấy chi tiết nhịp tim",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return [];
    }
  }
}
