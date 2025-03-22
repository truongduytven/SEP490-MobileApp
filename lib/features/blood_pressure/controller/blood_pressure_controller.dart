import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/blood_pressure/repository/blood_pressure_repository.dart';

final bloodPressureControllerProvider =
    Provider<BloodPressureController>((ref) {
  return BloodPressureController(
    bloodPressureRepository: BloodPressureRepository(),
  );
});

class BloodPressureController {
  final BloodPressureRepository bloodPressureRepository;

  BloodPressureController({
    required this.bloodPressureRepository,
  });

  Future<String> getBloodPressureEvaluation(
    BuildContext context,
    int systolic,
    int diastolic,
  ) async {
    try {
      final result = await bloodPressureRepository.getBloodPressureEvaluation(
        context,
        systolic,
        diastolic,
      );

      return result;
    } catch (e) {
      debugPrint("Error fetching blood pressure evaluation: $e");

      return "Không thể lấy đánh giá";
    }
  }

  Future<bool> addBloodPressure({
    required BuildContext context,
    required int accountId,
    required int elderlyId,
    required int systolic,
    required int diastolic,
    required String systolicSource,
    required String diastolicSource,
  }) async {
    try {
      final success = await bloodPressureRepository.addBloodPressure(
        context: context,
        accountId: accountId,
        elderlyId: elderlyId,
        systolic: systolic,
        diastolic: diastolic,
        systolicSource: systolicSource,
        diastolicSource: diastolicSource,
      );

      if (success) {}

      return success;
    } catch (e) {
      debugPrint("Error adding blood pressure: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể thêm huyết áp",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getBloodPressureDetail({
    required BuildContext context,
    required int accountId,
  }) async {
    try {
      final bloodPressure =
          await bloodPressureRepository.getBloodPressureDetail(
        context,
        accountId,
      );

      return bloodPressure;
    } catch (e) {
      debugPrint("Error fetching blood pressure detail: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể lấy chi tiết huyết áp",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return [];
    }
  }
}
