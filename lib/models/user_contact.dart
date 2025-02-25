class UserContact {
  final int accountId;
  final int roleId;
  final String email;
  final String password;
  final String fullName;
  final String avatar;
  final String gender;
  final String phoneNumber;
  final DateTime dateOfBirth;
  final DateTime createdDate;
  final String status;
  final String otp;
  final bool isVerified;
  final String deviceToken;
  final bool? isOnline;

  UserContact({
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
    this.isOnline,
  });

  factory UserContact.fromJson(Map<String, dynamic> json) {
    return UserContact(
      accountId: json['accountId'],
      roleId: json['roleId'],
      email: json['email'],
      password: json['password'],
      fullName: json['fullName'],
      avatar: json['avatar'],
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      createdDate: DateTime.parse(json['createdDate']),
      status: json['status'],
      otp: json['otp'],
      isVerified: json['isVerified'],
      deviceToken: json['deviceToken'],
      isOnline: json['isOnline'], // Can be null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'roleId': roleId,
      'email': email,
      'password': password,
      'fullName': fullName,
      'avatar': avatar,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'status': status,
      'otp': otp,
      'isVerified': isVerified,
      'deviceToken': deviceToken,
      'isOnline': isOnline,
    };
  }
}
