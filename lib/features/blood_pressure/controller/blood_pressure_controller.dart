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

      // Thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể lấy đánh giá huyết áp'),
          backgroundColor: Colors.red,
        ),
      );

      return "Không thể lấy đánh giá";
    }
  }

  Future<bool> addBloodPressure({
    required BuildContext context,
    required int elderlyId,
    required int systolic,
    required int diastolic,
    required String systolicSource,
    required String diastolicSource,
    required String createdBy,
  }) async {
    try {
      final success = await bloodPressureRepository.addBloodPressure(
        context: context,
        elderlyId: elderlyId,
        systolic: systolic,
        diastolic: diastolic,
        systolicSource: systolicSource,
        diastolicSource: diastolicSource,
        createdBy: createdBy,
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
      debugPrint("Error adding blood pressure: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2), // Hiển thị trong 2 giây
        title: Text(
          "Không thể thêm huyết áp",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return false;
    }
  }
}
