//prescription inside schedules
class Prescription {
  final int id;
  final String treatment;
  final String endDate;
  final String startDate;
  final List<Medicine> medicines;

  Prescription({
    required this.id,
    required this.treatment,
    required this.endDate,
    required this.startDate,
    required this.medicines,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'] ?? 0,
      treatment: json['treatment'] ?? '',
      endDate: json['endDate'] ?? '',
      startDate: json['startDate'] ?? '',
      medicines: (json['medicines'] as List)
          .map((medicine) => Medicine.fromJson(medicine))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'treatment': treatment,
      'startDate': startDate,
      'endDate': endDate,
      'medicines': medicines.map((medicine) => medicine.toJson()).toList(),
    };
  }
}

class Medicine {
  final int medicationId;
  final String medicationName;
  final String dosage;
  final String shape;
  final int remaining;
  final String frequencyType;
  final List<dynamic> frequencySelect;
  final bool isBeforeMeal;
  final List<Schedule> schedule;

  Medicine({
    required this.medicationId,
    required this.medicationName,
    required this.dosage,
    required this.shape,
    required this.remaining,
    required this.frequencyType,
    required this.frequencySelect,
    required this.isBeforeMeal,
    required this.schedule,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      medicationId: json['medicationId'],
      medicationName: json['medicationName'],
      dosage: json['dosage'],
      shape: json['shape'],
      remaining: json['remaining'],
      frequencyType: json['frequencyType'],
      frequencySelect: json['frequencySelect'] ?? [],
      isBeforeMeal: json['isBeforeMeal'],
      schedule: (json['schedule'] as List)
          .map((item) => Schedule.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicationId': medicationId,
      'medicationName': medicationName,
      'dosage': dosage,
      'shape': shape,
      'remaining': remaining,
      'frequencyType': frequencyType,
      'frequencySelect': frequencySelect,
      'isBeforeMeal': isBeforeMeal,
      'schedule': schedule.map((item) => item.toJson()).toList(),
    };
  }
}

class Schedule {
  final String time;
  final String status;

  Schedule({
    required this.time,
    required this.status,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      time: json['time'] ?? "",
      status: json['status'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'status': status,
    };
  }
}

class PrescriptionUpdate {
  final int id;
  final String treatment;
  final String medicationImage;
  final String createdBy;
  final String endDate;
  final String startDate;
  final List<MedicineUpdate> medicines;

  PrescriptionUpdate({
    required this.id,
    required this.treatment,
    required this.medicationImage,
    required this.createdBy,
    required this.endDate,
    required this.startDate,
    required this.medicines,
  });

  factory PrescriptionUpdate.fromJson(Map<String, dynamic> json) {
    return PrescriptionUpdate(
      id: json['id'] ?? 0,
      treatment: json['treatment'] ?? '',
      medicationImage: json['medicationImage'] ?? '',
      createdBy: json['createdBy'] ?? '',
      endDate: json['endDate'] ?? '',
      startDate: json['startDate'] ?? '',
      medicines: (json['medicines'] as List)
          .map((medicine) => MedicineUpdate.fromJson(medicine))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'treatment': treatment,
      'startDate': startDate,
      'medicationImage': medicationImage,
      'createdBy': createdBy,
      'endDate': endDate,
      'medicines': medicines.map((medicine) => medicine.toJson()).toList(),
    };
  }
}

class MedicineUpdate {
  final int medicationId;
  final String medicationName;
  final String dosage;
  final String shape;
  final int remaining;
  final String frequencyType;
  final List<dynamic> frequencySelect;
  final bool isBeforeMeal;
  final List<dynamic> schedule;

  MedicineUpdate({
    required this.medicationId,
    required this.medicationName,
    required this.dosage,
    required this.shape,
    required this.remaining,
    required this.frequencyType,
    required this.frequencySelect,
    required this.isBeforeMeal,
    required this.schedule,
  });

  factory MedicineUpdate.fromJson(Map<String, dynamic> json) {
    return MedicineUpdate(
      medicationId: json['medicationId'],
      medicationName: json['medicationName'],
      dosage: json['dosage'],
      shape: json['shape'],
      remaining: json['remaining'],
      frequencyType: json['frequencyType'],
      frequencySelect: json['frequencySelect'] ?? [],
      isBeforeMeal: json['isBeforeMeal'],
      schedule: json['schedule'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicationId': medicationId,
      'medicationName': medicationName,
      'dosage': dosage,
      'shape': shape,
      'remaining': remaining,
      'frequencyType': frequencyType,
      'frequencySelect': frequencySelect,
      'isBeforeMeal': isBeforeMeal,
      'schedule': schedule,
    };
  }
}
