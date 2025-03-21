import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/health/repository/health_repository.dart';

final healthControllerProvider = Provider<HealthController>((ref) {
  return HealthController(
    healthRepository: HealthRepository(),
  );
});

class HealthController {
  final HealthRepository healthRepository;

  HealthController({
    required this.healthRepository,
  });
  Future<List<Map<String, String>>> getHealthIndicators(
    BuildContext context,
    int accountId,
  ) async {
    try {
      final result = await healthRepository.getHealthIndicators(
        context,
        accountId,
      );

      return result;
    } catch (e) {
      debugPrint("Error fetching health indicators: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể lấy chỉ số sức khỏe: $e",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ).show(context);

      return [];
    }
  }

  Future<List<Map<String, String>>> getLogBookHealthIndicator(
    BuildContext context,
    int accountId,
  ) async {
    try {
      final result = await healthRepository.getLogBookHealthIndicator(
        context,
        accountId,
      );

      return result;
    } catch (e) {
      debugPrint("Error fetching health log book indicators: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể lấy sổ theo dõi sức khỏe: $e",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ).show(context);

      return [];
    }
  }
}
