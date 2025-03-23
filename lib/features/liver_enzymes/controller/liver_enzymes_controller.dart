import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/lipid_profile/repository/lipid_profile_repository.dart';
import 'package:sep490/features/liver_enzymes/repository/liver_enzymes_repository.dart';

final liverEnzymesControllerProvider = Provider<LiverEnzymesController>((ref) {
  return LiverEnzymesController(
    liverEnzymesRepository: LiverEnzymesRepository(),
  );
});

class LiverEnzymesController {
  final LiverEnzymesRepository liverEnzymesRepository;

  LiverEnzymesController({
    required this.liverEnzymesRepository,
  });

  Future<String> getLiverEnzymesEvaluation(
    BuildContext context,
    double alt,
    double ast,
    double alp,
    double ggt,
  ) async {
    try {
      final result = await liverEnzymesRepository.getLiverEnzymesEvaluation(
        context,
        alt,
        ast,
        alt,
        ggt,
      );

      return result;
    } catch (e) {
      debugPrint("Error fetching liver enzymes evaluation: $e");

      return "Không thể lấy đánh giá";
    }
  }

  Future<bool> addLiverEnzymes({
    required BuildContext context,
    required int accountId,
    required int elderlyId,
    required double alt,
    required double ast,
    required double alp,
    required double ggt,
    required String liverEnzymesSource,
  }) async {
    try {
      final success = await liverEnzymesRepository.addLiverEnzymes(
        context: context,
        accountId: accountId,
        elderlyId: elderlyId,
        alt: alt,
        ast: ast,
        alp: alp,
        ggt: ggt,
        liverEnzymesSource: liverEnzymesSource,
      );

      if (success) {}

      return success;
    } catch (e) {
      debugPrint("Error adding liver enzymes :$e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể thêm men gan",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getLiverEnzymesDetail({
    required BuildContext context,
    required int accountId,
  }) async {
    try {
      final liverEnzymes = await liverEnzymesRepository.getLiverEnzymesDetail(
        context,
        accountId,
      );

      return liverEnzymes;
    } catch (e) {
      debugPrint("Error fetching liver enzymes detail: $e");

      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: Text(
          "Không thể lấy chi tiết men gan",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);

      return [];
    }
  }
}
