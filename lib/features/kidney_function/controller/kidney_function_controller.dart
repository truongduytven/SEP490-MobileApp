import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/heart_beat/repository/heart_rate_repository.dart';
import 'package:sep490/features/kidney_function/repository/kidney_function_repository.dart';

final kidneyFunctionControllerProvider =
    Provider<KidneyFunctionController>((ref) {
  return KidneyFunctionController(
    kidneyFunctionRepository: KidneyFunctionRepository(),
  );
});

class KidneyFunctionController {
  final KidneyFunctionRepository kidneyFunctionRepository;

  KidneyFunctionController({
    required this.kidneyFunctionRepository,
  });

  Future<String> getKidneyFunctionEvaluation(
    BuildContext context,
    double creatinine,
    double bun,
    double eGFR,
  ) async {
    try {
      final result = await kidneyFunctionRepository.getKidneyFunctionEvaluation(
        context,
        creatinine,
        bun,
        eGFR,
      );

      return result;
    } catch (e) {
      debugPrint("Error fetching kidney function evaluation: $e");

      return "Không thể lấy đánh giá";
    }
  }

  Future<bool> addKidneyFunction({
    required BuildContext context,
    required int accountId,
    required int elderlyId,
    required double creatinine,
    required double bun,
    required double egfr,
    required String kidneyFunctionSource,
  }) async {
    try {
      final success = await kidneyFunctionRepository.addKidneyFunction(
        context: context,
        accountId: accountId,
        elderlyId: elderlyId,
        creatinine: creatinine,
        bun: bun,
        egfr: egfr,
        kidneyFunctionSource: kidneyFunctionSource,
      );

      if (success) {}

      return success;
    } catch (e) {
      debugPrint("Error adding kidney function: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể thêm chức năng thận",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return false;
    }
  }

  Future<bool> updateKidneyFunction({
    required BuildContext context,
    required int kidneyFunctionId,
    required String createdBy,
    required double creatinine,
    required double bun,
    required double eGfr,
  }) async {
    try {
      final success = await kidneyFunctionRepository.updateKidneyFunction(
        context: context,
        kidneyFunctionId: kidneyFunctionId,
        createdBy: createdBy,
        creatinine: creatinine,
        bun: bun,
        eGfr: eGfr,
      );

      if (success) {}

      return success;
    } catch (e) {
      debugPrint("Error updating kidney function: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể cập nhật chức năng thận",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return false;
    }
  }

  Future<bool> deleteKidneyFunction({
    required BuildContext context,
    required int kidneyFunctionId,
  }) async {
    try {
      final success = await kidneyFunctionRepository.deleteKidneyFunction(
        context: context,
        kidneyFunctionId: kidneyFunctionId,
      );

      if (success) {}

      return success;
    } catch (e) {
      debugPrint("Error deleting kidney function: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể xóa chức năng thận",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getKidneyFunctionDetail({
    required BuildContext context,
    required int accountId,
  }) async {
    try {
      final kidneyFunction =
          await kidneyFunctionRepository.getKidneyFunctionDetail(
        context,
        accountId,
      );

      return kidneyFunction;
    } catch (e) {
      debugPrint("Error fetching kidney function detail: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể lấy chi tiết chức năng thận",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return [];
    }
  }
}
