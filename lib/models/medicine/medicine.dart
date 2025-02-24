class Prescription {
  final int id;
  final String treatment;
  final String startDate;
  final List<Medicine> medicines;

  Prescription({
    required this.id,
    required this.treatment,
    required this.startDate,
    required this.medicines,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'],
      treatment: json['treatment'],
      startDate: json['startDate'],
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
      'medicines': medicines.map((medicine) => medicine.toJson()).toList(),
    };
  }
}

class Medicine {
  final int id;
  final String name;
  final String dosage;
  final String form;
  final String remaining;
  final String typeFrequency;
  final String frequencyEvery;
  final List<dynamic> frequencySelect;
  final String mealTime;
  final List<Schedule> schedule;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.form,
    required this.remaining,
    required this.typeFrequency,
    required this.frequencyEvery,
    required this.frequencySelect,
    required this.mealTime,
    required this.schedule,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      dosage: json['dosage'],
      form: json['form'],
      remaining: json['remaining'],
      typeFrequency: json['typeFrequency'],
      frequencyEvery: json['frequencyEvery'],
      frequencySelect: json['frequencySelect'],
      mealTime: json['mealTime'],
      schedule: (json['schedule'] as List)
          .map((item) => Schedule.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'form': form,
      'remaining': remaining,
      'typeFrequency': typeFrequency,
      'frequencyEvery': frequencyEvery,
      'frequencySelect': frequencySelect,
      'mealTime': mealTime,
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
      time: json['time'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'status': status,
    };
  }
}