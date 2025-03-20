import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/blood_glucose/repository/blood_glucose_repository.dart';

final bloodGlucoseControllerProvider = Provider<BloodGlucoseController>((ref) {
  return BloodGlucoseController(
    bloodGlucoseRepository: BloodGlucoseRepository(),
  );
});

class BloodGlucoseController {
  final BloodGlucoseRepository bloodGlucoseRepository;

  BloodGlucoseController({
    required this.bloodGlucoseRepository,
  });

  Future<String> getBloodGlucoseEvaluation(
    BuildContext context,
    double bloodGlucose,
    String period,
  ) async {
    try {
      final result = await bloodGlucoseRepository.getBloodGlucoseEvaluation(
        context,
        bloodGlucose,
        period,
      );

      return result;
    } catch (e) {
      debugPrint("Error fetching blood glucose evaluation: $e");

      // // Thông báo lỗi
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Không thể lấy đánh giá đường huyết'),
      //     backgroundColor: Colors.red,
      // ),
      // );

      return "Không thể lấy đánh giá";
    }
  }

  Future<bool> addBloodGlucose({
    required BuildContext context,
    required int accountId,
    required int elderlyId,
    required double bloodGlucose,
    required String bloodGlucoseSource,
    required String period,
  }) async {
    try {
      final success = await bloodGlucoseRepository.addBloodGlucose(
        context: context,
        accountId: accountId,
        elderlyId: elderlyId,
        bloodGlucose: bloodGlucose,
        bloodGlucoseSource: bloodGlucoseSource,
        period: period,
      );

      if (success) {}

      return success;
    } catch (e) {
      debugPrint("Error adding blood glucose: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2), // Hiển thị trong 2 giây
        title: Text(
          "Không thể thêm đường huyết",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return false;
    }
  }
}
