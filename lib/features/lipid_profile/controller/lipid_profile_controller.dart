import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/lipid_profile/repository/lipid_profile_repository.dart';

final lipidProfileControllerProvider = Provider<LipidProfileController>((ref) {
  return LipidProfileController(
    lipidProfileRepository: LipidProfileRepository(),
  );
});

class LipidProfileController {
  final LipidProfileRepository lipidProfileRepository;

  LipidProfileController({
    required this.lipidProfileRepository,
  });

  Future<String> getLipidProfileEvaluation(
    BuildContext context,
    double totalCholesterol,
    double ldlCholesterol,
    double hdlCholesterol,
    double triglycerides,
  ) async {
    try {
      final result = await lipidProfileRepository.getLipidProfileEvaluation(
        context,
        totalCholesterol,
        ldlCholesterol,
        hdlCholesterol,
        triglycerides,
      );

      return result;
    } catch (e) {
      debugPrint("Error fetching lipid profile evaluation: $e");

      return "Không thể lấy đánh giá";
    }
  }

  Future<bool> addLipidProfile({
    required BuildContext context,
    required int accountId,
    required int elderlyId,
    required double totalCholesterol,
    required double ldlCholesterol,
    required double hdlCholesterol,
    required double triglycerides,
    required String lipidProfileSource,
  }) async {
    try {
      final success = await lipidProfileRepository.addLipidProfile(
        context: context,
        accountId: accountId,
        elderlyId: elderlyId,
        totalCholesterol: totalCholesterol,
        ldlCholesterol: ldlCholesterol,
        hdlCholesterol: hdlCholesterol,
        triglycerides: triglycerides,
        lipidProfileSource: lipidProfileSource,
      );

      if (success) {}

      return success;
    } catch (e) {
      debugPrint("Error adding lipid profile :$e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể thêm mỡ máu",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getLipidProfileDetail({
    required BuildContext context,
    required int accountId,
  }) async {
    try {
      final lipidProfile = await lipidProfileRepository.getLipidProfileDetail(
        context,
        accountId,
      );

      return lipidProfile;
    } catch (e) {
      debugPrint("Error fetching lipid profile detail: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể lấy chi tiết mỡ máu",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return [];
    }
  }
}
