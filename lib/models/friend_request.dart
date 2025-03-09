import 'dart:convert';

class FriendRequest {
  final int? requestUserId;
  final String? requestUserName;
  final String? requestUserAvatar;
  final int? responseUserId;
  final String? responseUserName;
  final String? responseUserAvatar;
  final DateTime? createdAt;
  final User? user;

  FriendRequest({
    this.requestUserId,
    this.requestUserName,
    this.requestUserAvatar,
    this.responseUserId,
    this.responseUserName,
    this.responseUserAvatar,
    this.createdAt,
    this.user,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      requestUserId: json["requestUserId"],
      requestUserName: json["requestUserName"],
      requestUserAvatar: json["requestUserAvatar"],
      responseUserId: json["responseUserId"],
      responseUserName: json["responseUserName"],
      responseUserAvatar: json["responseUserAvatar"],
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"])
          : null,
      user: json["user"] != null ? User.fromJson(json["user"]) : null,
    );
  }

  static List<FriendRequest> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => FriendRequest.fromJson(json)).toList();
  }
}

class User {
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

  User(
      {this.accountId,
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
      this.requestUserId});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accountId: json["accountId"],
      roleId: json["roleId"],
      email: json["email"],
      password: json["password"],
      fullName: json["fullName"],
      avatar: json["avatar"],
      gender: json["gender"],
      phoneNumber: json["phoneNumber"],
      dateOfBirth: json["dateOfBirth"] != null
          ? DateTime.tryParse(json["dateOfBirth"])
          : null,
      createdDate: json["createdDate"] != null
          ? DateTime.tryParse(json["createdDate"])
          : null,
      status: json["status"],
      otp: json["otp"],
      isVerified: json["isVerified"],
      deviceToken: json["deviceToken"],
      isOnline: json["isOnline"],
      requestUserId: json['requestUserId'] as int?,
    );
  }
}
