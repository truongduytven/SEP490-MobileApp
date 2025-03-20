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

      // // Thông báo lỗi
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Không thể lấy đánh giá nhịp tim'),
      //     backgroundColor: Colors.red,
      //   ),
      // );

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
}
