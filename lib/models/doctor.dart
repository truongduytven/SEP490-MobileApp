class DoctorData {
  final String fullName;
  final String avatar;
  final String dateTime;
  final int professorId;
  final List<dynamic> specialization;
  final String clinicAddress;
  final double consultationFee;
  final int experienceYears;
  final double rating;
  final List<dynamic> qualification;
  final List<dynamic> knowledge;
  final List<dynamic> career;
  final List<dynamic> achievement;

  DoctorData({
    required this.fullName,
    required this.avatar,
    required this.dateTime,
    required this.professorId,
    required this.specialization,
    required this.clinicAddress,
    required this.consultationFee,
    required this.experienceYears,
    required this.rating,
    required this.qualification,
    required this.knowledge,
    required this.career,
    required this.achievement,
  });

  factory DoctorData.fromJson(Map<String, dynamic> json) {
    return DoctorData(
      fullName: json['fullName'],
      avatar: json['avatar'],
      dateTime: json['dateTime'] ?? '',
      professorId: json['professorId'],
      specialization: json['specialization'],
      clinicAddress: json['clinicAddress'],
      consultationFee: json['consultationFee'],
      experienceYears: json['experienceYears'],
      rating: json['rating'],
      qualification: json['qualification'],
      knowledge: json['knowledge'],
      career: json['career'],
      achievement: json['achievement'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'avatar': avatar,
      'dateTime': dateTime,
      'professorId': professorId,
      'specialization': specialization,
      'clinicAddress': clinicAddress,
      'consultationFee': consultationFee,
      'experienceYears': experienceYears,
      'rating': rating,
      'qualification': qualification,
      'knowledge': knowledge,
      'career': career,
      'achievement': achievement,
    };
  }
}

class AppoimentDoctor {
  final int professorAppointmentId;
  final String professorAvatar;
  final String professorName;
  final String dateTime;
  final String status;
  final bool isOnline;
  final List<int> listAccountId;

  AppoimentDoctor({
    required this.professorAppointmentId,
    required this.professorAvatar,
    required this.professorName,
    required this.dateTime,
    required this.status,
    required this.isOnline,
    required this.listAccountId,
  });

  factory AppoimentDoctor.fromJson(Map<String, dynamic> json) {
    return AppoimentDoctor(
      professorAppointmentId: json['professorAppointmentId'],
      professorAvatar: json['professorAvatar'],
      professorName: json['professorName'],
      dateTime: json['dateTime'],
      status: json['status'],
      isOnline: json['isOnline'],
      listAccountId: json['accountId'].cast<int>(),
    );
  }
}

class Report {
  final String content;
  final String solution;

  Report({
    required this.content,
    required this.solution,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      content: json['content'],
      solution: json['solution'],
    );
  } 
}