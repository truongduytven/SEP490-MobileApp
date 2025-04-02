import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/steps/repository/steps_repository.dart';

final stepsControllerProvider = Provider<StepsController>((ref) {
  return StepsController(
    stepsRepository: StepsRepository(),
  );
});

class StepsController {
  final StepsRepository stepsRepository;

  StepsController({
    required this.stepsRepository,
  });

  Future<String> getHeartRateEvaluation(
      BuildContext context, int heartRate) async {
    try {
      final result =
          await stepsRepository.getHeartRateEvaluation(context, heartRate);

      return result;
    } catch (e) {
      debugPrint("Error fetching heart rate evaluation: $e");

      return "Không thể lấy đánh giá";
    }
  }

  Future<bool> addBloodOxygen({
    required BuildContext context,
    required int accountId,
    required int elderlyId,
    required int steps,
    required String stepsSource,
  }) async {
    try {
      final success = await stepsRepository.addSteps(
        context: context,
        accountId: accountId,
        elderlyId: elderlyId,
        steps: steps,
        stepsSource: stepsSource,
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

  // Future<bool> updateHeartRate({
  //   required BuildContext context,
  //   required int heartRateId,
  //   required String createdBy,
  //   required int heartRate,
  // }) async {
  //   try {
  //     final success = await heartRateRepository.updateHeartRate(
  //       context: context,
  //       heartRateId: heartRateId,
  //       createdBy: createdBy,
  //       heartRate: heartRate,
  //     );

  //     if (success) {}

  //     return success;
  //   } catch (e) {
  //     debugPrint("Error updating heart rate: $e");

  //     CherryToast.error(
  //       toastDuration: Duration(seconds: 2),
  //       title: Text(
  //         "Không thể cập nhật nhịp tim",
  //         style: TextStyle(color: Colors.black),
  //       ),
  //     ).show(context);

  //     return false;
  //   }
  // }

  Future<bool> deleteHeartRate({
    required BuildContext context,
    required int stepsId,
  }) async {
    try {
      final success = await stepsRepository.deleteSteps(
        context: context,
        stepsId: stepsId,
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
      final heartRateDetail = await stepsRepository.getHeartRateDetail(
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
