import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/calories_burned/repository/calories_burned_repository.dart';

final caloriesBurnedControllerProvider = Provider<CaloriesBurnedController>((ref) {
  return CaloriesBurnedController(
    caloriesBurnedRepository: CaloriesBurnedRepository(),
  );
});

class CaloriesBurnedController {
  final CaloriesBurnedRepository caloriesBurnedRepository;

  CaloriesBurnedController({
    required this.caloriesBurnedRepository,
  });

  Future<String> getHeartRateEvaluation(
      BuildContext context, int heartRate) async {
    try {
      final result =
          await caloriesBurnedRepository.getHeartRateEvaluation(context, heartRate);

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
    required int caloriesBurned,
    required String caloriesBurnedSource,
  }) async {
    try {
      final success = await caloriesBurnedRepository.addCaloriesBurned(
        context: context,
        accountId: accountId,
        elderlyId: elderlyId,
        caloriesBurned: caloriesBurned,
        caloriesBurnedSource: caloriesBurnedSource,
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
    required int caloriesBurnedId,
  }) async {
    try {
      final success = await caloriesBurnedRepository.deleteCaloriesBurned(
        context: context,
        caloriesBurnedId: caloriesBurnedId,
      );

      if (success) {}

      return success;
    } catch (e) {
      debugPrint("Error deleting  heart rate: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể xóa năng lượng tiêu thụ",
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
      final heartRateDetail = await caloriesBurnedRepository.getHeartRateDetail(
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
