import 'package:sep490/models/emergency.dart';
import 'package:sep490/presentation/pages/emergency_alert/repository/emergency_repository.dart';

class EmergencyController {
  final EmergencyRepository _emergencyRepository = EmergencyRepository();
  int? emergencyConfirmationId;
  bool isCreateSuccess = false;
  bool isConfirmed = false;
  bool isConfirmedSuccess = false;
  List<Emergency> emergencyList = [];
  EmergencyInformation? emergencyInformation;
  List<EmergencyInformation> emergencyInformationList = [];

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

  Future<void> getEmergencyList(int accountId) async {
    final response = await _emergencyRepository.getEmergencyList(accountId);
    if (response != null && response['isSuccess']) {
      emergencyList = response['data']['data']
          .map<Emergency>((emergency) => Emergency.fromJson(emergency))
          .toList();
    } else {
      emergencyList = [];
    }
  }

  Future<void> getEmergencyListDoctor(int accountId) async {
    final response = await _emergencyRepository.getEmergencyListDoctor(accountId);
    if (response != null && response['isSuccess']) {
      emergencyList = response['data']['data']
          .map<Emergency>((emergency) => Emergency.fromJson(emergency))
          .toList();
    } else {
      emergencyList = [];
    }
  }

  Future<void> getEmergencyDetail(int emergencyId) async {
    final response = await _emergencyRepository.getEmergencyDetail(emergencyId);
    if (response != null && response['isSuccess']) {
      emergencyInformation = EmergencyInformation.fromJson(response['data']['data']);
    } else {
      emergencyInformation = null;
    }
  }

  Future<void> getEmergencyListDetail(int emergencyId) async {
    final response = await _emergencyRepository.getEmergencyListDetail(emergencyId);
    if (response != null && response['isSuccess']) {
      emergencyInformationList = response['data']['data']
          .map<EmergencyInformation>((emergency) => EmergencyInformation.fromJson(emergency))
          .toList();
    } else {
      emergencyInformationList = [];
    }
  }

  Future<void> confirmEmergencyInformation(int emergencyId, int accountId) async {
    final response = await _emergencyRepository.confirmEmergency(emergencyId, accountId);
    if (response != null && response['isSuccess']) {
      isConfirmedSuccess = true;
    } else {
      isConfirmedSuccess = false;
    }
  }

}