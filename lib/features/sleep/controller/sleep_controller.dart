import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/sleep/repository/sleep_repository.dart';

final sleepControllerProvider = Provider<SleepController>((ref) {
  return SleepController(
    sleepRepository: SleepRepository(),
  );
});

class SleepController {
  final SleepRepository sleepRepository;

  SleepController({
    required this.sleepRepository,
  });

  Future<String> getHeartRateEvaluation(
      BuildContext context, int heartRate) async {
    try {
      final result =
          await sleepRepository.getHeartRateEvaluation(context, heartRate);

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
    required int sleep,
    required String sleepSource,
  }) async {
    try {
      final success = await sleepRepository.addSleep(
        context: context,
        accountId: accountId,
        elderlyId: elderlyId,
        sleep: sleep,
        sleepSource: sleepSource,
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
    required int heartRateId,
  }) async {
    try {
      final success = await sleepRepository.deleteSleep(
        context: context,
        sleepId: heartRateId,
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
      final heartRateDetail = await sleepRepository.getHeartRateDetail(
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
