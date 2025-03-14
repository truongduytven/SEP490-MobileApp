import 'package:sep490/presentation/pages/emergency_alert/repository/emergency_repository.dart';

class EmergencyController {
  final EmergencyRepository _emergencyRepository = EmergencyRepository();
  int? emergencyConfirmationId;
  bool isCreateSuccess = false;
  bool isConfirmed = false;

  Future<void> createEmergencyConfirmation(int accountID) async {
    final response = await _emergencyRepository.createConfirmation(accountID);
    if (response != null && response['isSuccess']) {
      emergencyConfirmationId = response['data']['data']['emergencyConfirmationId'];
    } else {
      emergencyConfirmationId = null;
    }
  }

  Future<void> createEmergencyInformation(
      int emergencyId,
      String imgFrontCamera,
      String imgRearCamera,
      String longitude,
      String latitude,
      bool isCallProfessor,
      bool isSendMessage) async {
    final response = await _emergencyRepository.createEmergencyInformation(
        emergencyId,
        imgFrontCamera,
        imgRearCamera,
        longitude,
        latitude,
        isCallProfessor,
        isSendMessage);
    if (response != null && response['isSuccess']) {
      isCreateSuccess = true;
    } else {
      isCreateSuccess = false;
    }
  }

  Future<void> confirmEmergency(int emergencyId) async {
    final response = await _emergencyRepository.getEmergencyConfirm(emergencyId);
    if (response != null && response['isSuccess']) {
      isConfirmed = response['data']['data']['isConfirmed'];
    } else {
      isConfirmed = false;
    }
  }

}