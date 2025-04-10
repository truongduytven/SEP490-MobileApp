import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/blood_oxygen/repository/blood_oxygen_repository.dart';

final bloodOxygenControllerProvider = Provider<BloodOxygenController>((ref) {
  return BloodOxygenController(
    bloodOxygenRepository: BloodOxygenRepository(),
  );
});

class BloodOxygenController {
  final BloodOxygenRepository bloodOxygenRepository;

  BloodOxygenController({
    required this.bloodOxygenRepository,
  });

  Future<String> getHeartRateEvaluation(
      BuildContext context, int heartRate) async {
    try {
      final result =
          await bloodOxygenRepository.getHeartRateEvaluation(context, heartRate);

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
    required int bloodOxygen,
    required String heartRateSource,
  }) async {
    try {
      final success = await bloodOxygenRepository.addBloodOxygen(
        context: context,
        accountId: accountId,
        elderlyId: elderlyId,
        oxygen: bloodOxygen,
        oxygenSource: heartRateSource,
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

  Future<bool> deleteHeartRate({
    required BuildContext context,
    required int heartRateId,
  }) async {
    try {
      final success = await bloodOxygenRepository.deleteHeartRate(
        context: context,
        oxygenId: heartRateId,
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
      final heartRateDetail = await bloodOxygenRepository.getHeartRateDetail(
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
