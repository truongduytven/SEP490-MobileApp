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

class HistoryTransactionData {
  final int bookingId;
  final String bookingDate;
  final int price;
  final String note;
  final ElderlyData elderly;
  final PackageData package;

  HistoryTransactionData({
    required this.bookingId,
    required this.bookingDate,
    required this.price,
    required this.note,
    required this.elderly,
    required this.package,
  });

  factory HistoryTransactionData.fromJson(Map<String, dynamic> json) {
    return HistoryTransactionData(
      bookingId: json['bookingId'] ?? 0,
      bookingDate: json['bookingDate'] ?? '',
      price: json['price'] ?? 0,
      note: json['note'] ?? '',
      elderly: ElderlyData.fromJson(json['elderly']),
      package: PackageData.fromJson(json['subscription']),
    );
  }
}

class ElderlyData {
  final int accountId;
  final int roleId;
  final String email;
  final String password;
  final String fullName;
  final String avatar;
  final String gender;
  final String phoneNumber;
  final String dateOfBirth;
  final String createdDate;
  final String status;
  final String otp;
  final bool isVerified;
  final String deviceToken;
  final bool isSuperAdmin;

  ElderlyData({
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

  factory ElderlyData.fromJson(Map<String, dynamic> json) {
    return ElderlyData(
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
        isSuperAdmin: json['isSuperAdmin'] ?? false);
  }
}

class PackageData {
  final int subscriptionId;
  final String name;
  final String description;
  final double fee;
  final int validityPeriod;
  final String createdDate;
  final String updatedDate;
  final String status;
  final int accountId;
  final int numberOfMeeting;

  PackageData({
    required this.subscriptionId,
    required this.name,
    required this.description,
    required this.fee,
    required this.validityPeriod,
    required this.createdDate,
    required this.updatedDate,
    required this.status,
    required this.accountId,
    required this.numberOfMeeting,
  });

  factory PackageData.fromJson(Map<String, dynamic> json) {
    return PackageData(
      subscriptionId: json['subscriptionId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      fee: json['fee'] ?? 0,
      validityPeriod: json['validityPeriod'] ?? 0,
      createdDate: json['createdDate'] ?? '',
      updatedDate: json['updatedDate'] ?? '',
      status: json['status'] ?? '',
      accountId: json['accountId'] ?? 0,
      numberOfMeeting: json['numberOfMeeting'] ?? 0,
    );
  }
}
