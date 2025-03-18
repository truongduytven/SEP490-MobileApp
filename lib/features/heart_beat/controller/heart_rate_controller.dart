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

      // Thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể lấy đánh giá nhịp tim'),
          backgroundColor: Colors.red,
        ),
      );

      return "Không thể lấy đánh giá";
    }
  }
}
