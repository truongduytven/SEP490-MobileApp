class UserContact {
  final int? accountId;
  final int? roleId;
  final String? email;
  final String? password;
  final String? fullName;
  final String? avatar;
  final String? gender;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final DateTime? createdDate;
  final String? status;
  final String? otp;
  final bool? isVerified;
  final String? deviceToken;
  final bool? isOnline;
  final int? requestUserId;

  UserContact({
    this.accountId,
    this.roleId,
    this.email,
    this.password,
    this.fullName,
    this.avatar,
    this.gender,
    this.phoneNumber,
    this.dateOfBirth,
    this.createdDate,
    this.status,
    this.otp,
    this.isVerified,
    this.deviceToken,
    this.isOnline,
    this.requestUserId,
  });

  factory UserContact.fromJson(Map<String, dynamic> json) {
    return UserContact(
      accountId: json['accountId'] as int?,
      roleId: json['roleId'] as int?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      fullName: json['fullName'] as String?,
      avatar: json['avatar'] as String?,
      gender: json['gender'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
      status: json['status'] as String?,
      otp: json['otp'] as String?,
      isVerified: json['isVerified'] as bool?,
      deviceToken: json['deviceToken'] as String?,
      isOnline: json['isOnline'] as bool?,
      requestUserId: json['requestUserId'] as int?,
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
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'createdDate': createdDate?.toIso8601String(),
      'status': status,
      'otp': otp,
      'isVerified': isVerified,
      'deviceToken': deviceToken,
      'isOnline': isOnline,
      'requestUserId': requestUserId,
    };
  }
}
