class Emergency {
  final int elderlyId;
  final String elderlyName;
  final String phoneNumber;
  final List<HistoryEmergency> historyEmergency;

  Emergency({
    required this.elderlyId,
    required this.elderlyName,
    required this.phoneNumber,
    required this.historyEmergency,
  });

  factory Emergency.fromJson(Map<String, dynamic> json) {
    return Emergency(
      elderlyId: json['elderlyId'],
      elderlyName: json['elderlyName'],
      phoneNumber: json['phoneNumber'],
      historyEmergency: (json['getEmergencyConfirmationDTOs'] as List)
          .map((history) => HistoryEmergency.fromJson(history))
          .toList(),
    );
  }
}

class HistoryEmergency {
  final int emergencyConfirmationId;
  final int elderlyId;
  final String confirmationAccountName;
  final String emergencyDate;
  final String emergencyTime;
  final String confirmationDate;
  final bool isConfirmed;

  HistoryEmergency({
    required this.emergencyConfirmationId,
    required this.elderlyId,
    required this.confirmationAccountName,
    required this.emergencyDate,
    required this.emergencyTime,
    required this.confirmationDate,
    required this.isConfirmed,
  });

  factory HistoryEmergency.fromJson(Map<String, dynamic> json) {
    return HistoryEmergency(
      emergencyConfirmationId: json['emergencyConfirmationId'],
      elderlyId: json['elderlyId'],
      confirmationAccountName: json['confirmationAccountName'],
      emergencyDate: json['emergencyDate'],
      emergencyTime: json['emergencyTime'],
      confirmationDate: json['confirmationDate'] ?? '',
      isConfirmed: json['isConfirmed'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'emergencyConfirmationId': emergencyConfirmationId,
      'elderlyId': elderlyId,
      'confirmationAccountName': confirmationAccountName,
      'emergencyDate': emergencyDate,
      'emergencyTime': emergencyTime,
      'confirmationDate': confirmationDate,
      'isConfirmed': isConfirmed,
    };
  }
}

class EmergencyInformation {
  final int emergencyInformationId;
  final int emergencyConfirmationId;
  final String confirmationAccountName;
  final String confirmationDate;
  final String confirmationTime;
  final bool isConfirmed;
  final String frontCameraImage;
  final String rearCameraImage;
  final String longitude;
  final String latitude;
  final String informationDate;
  final String informationTime;
  final String status;

  EmergencyInformation({
    required this.emergencyInformationId,
    required this.emergencyConfirmationId,
    required this.confirmationAccountName,
    required this.confirmationDate,
    required this.confirmationTime,
    required this.isConfirmed,
    required this.frontCameraImage,
    required this.rearCameraImage,
    required this.longitude,
    required this.latitude,
    required this.informationDate,
    required this.informationTime,
    required this.status,
  });

  factory EmergencyInformation.fromJson(Map<String, dynamic> json) {
    return EmergencyInformation(
      emergencyInformationId: json['emergencyInformationId'],
      emergencyConfirmationId: json['emergencyConfirmationId'],
      confirmationAccountName: json['confirmationAccountName'],
      confirmationDate: json['confirmationDate'] ?? "",
      confirmationTime: json['confirmationTime'] ?? "",
      isConfirmed: json['isConfirmed'],
      frontCameraImage: json['frontCameraImage'],
      rearCameraImage: json['rearCameraImage'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      informationDate: json['informationDate'],
      informationTime: json['informationTime'],
      status: json['status'],
    );
  }
}
