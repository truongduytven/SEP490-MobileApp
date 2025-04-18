class HomeHealthIndicator {
  String tabs;
  String evaluation;
  String dateTime;
  String indicator;
  String averageIndicator;

  HomeHealthIndicator({
    required this.tabs,
    required this.evaluation,
    required this.dateTime,
    required this.indicator,
    required this.averageIndicator,
  });

  factory HomeHealthIndicator.fromJson(Map<String, dynamic> json) {
    return HomeHealthIndicator(
      tabs: json['tabs'],
      evaluation: json['evaluation'],
      dateTime: json['dateTime'],
      indicator: json['indicator'],
      averageIndicator: json['averageIndicator'],
    );
  }
}

class ElderlyUser {
  int elderlyId;
  int accountId;
  int roleId;
  String email;
  String password;
  String fullName;
  String avatar;
  String gender;
  String phoneNumber;
  String dateOfBirth;
  String createdDate;
  String status;
  String otp;
  bool isVerified;
  String deviceToken;
  bool isSuperAdmin;

  ElderlyUser({
    required this.elderlyId,
    required this.accountId,
    required this.roleId,
    required this.email,
    required this.password,
    required this.fullName,
    required this.avatar,
    required this.gender,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.createdDate,
    required this.status,
    required this.otp,
    required this.isVerified,
    required this.deviceToken,
    required this.isSuperAdmin,
  });

  factory ElderlyUser.fromJson(Map<String, dynamic> json) {
    return ElderlyUser(
      elderlyId: json['elderlyId'] ?? 0,
      accountId: json['accountId'] ?? 0,
      roleId: json['roleId'] ?? 0,
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      fullName: json['fullName'] ?? '',
      avatar: json['avatar'] ?? '',
      gender: json['gender'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      createdDate: json['createdDate'] ?? '',
      status: json['status'] ?? '',
      otp: json['otp'] ?? '',
      isVerified: json['isVerified'] ?? false,
      deviceToken: json['deviceToken'] ?? '',
      isSuperAdmin: json['isSuperAdmin'] ?? false,
    );
  }
}

class ElderlyProfile {
  final int accountId;
  final int roleId;
  final String email;
  final String fullName;
  final String avatar;
  final String gender;
  final String phoneNumber;
  final String dateOfBirth;
  final String createdDate;
  final String status;

  ElderlyProfile({
    required this.accountId,
    required this.roleId,
    required this.email,
    required this.fullName,
    required this.avatar,
    required this.gender,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.createdDate,
    required this.status,
  });

  factory ElderlyProfile.fromJson(Map<String, dynamic> json) {
    return ElderlyProfile(
      accountId: json['accountId'] ?? 0,
      roleId: json['roleId'] ?? 0,
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      gender: json['gender'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      createdDate: json['createdDate'] ?? '',
      status: json['status'] ?? '',
      avatar: json['avatar'] ?? '', 
    );
  }
}