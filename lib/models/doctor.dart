class DoctorData {
  final int accountId;
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
    required this.accountId,
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
      accountId: json['accountId'] ?? 0,
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
      'accountId': accountId,
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
  final List<Account> people;

  AppoimentDoctor({
    required this.professorAppointmentId,
    required this.professorAvatar,
    required this.professorName,
    required this.dateTime,
    required this.status,
    required this.isOnline,
    required this.people,
  });

  factory AppoimentDoctor.fromJson(Map<String, dynamic> json) {
    return AppoimentDoctor(
      professorAppointmentId: json['professorAppointmentId'],
      professorAvatar: json['professorAvatar'],
      professorName: json['professorName'],
      dateTime: json['dateTime'],
      status: json['status'],
      isOnline: json['isOnline'],
      people: (json['people'] as List)
          .map((item) => Account.fromJson(item))
          .toList(),
    );
  }
}

class Account {
  final int id;
  final String name;

  Account({
    required this.id,
    required this.name,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
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

class TimeSlots {
  final int timeSlotId;
  final String startTime;
  final String endTime;

  TimeSlots({
    required this.timeSlotId,
    required this.startTime,
    required this.endTime,
  });

  factory TimeSlots.fromJson(Map<String, dynamic> json) {
    return TimeSlots(
      timeSlotId: json['timeSlotId'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}

class FilteredDoctor {
  final String professorName;
  final String professorAvatar;
  final int professorId;
  final String major;
  final String? dateTime;
  final String? date;
  final double rating;
  final int totalRating;

  FilteredDoctor({
    required this.professorName,
    required this.professorAvatar,
    required this.professorId,
    required this.major,
    this.dateTime,
    this.date,
    required this.rating,
    required this.totalRating,
  });

  factory FilteredDoctor.fromJson(Map<String, dynamic> json) {
    return FilteredDoctor(
      professorName: json['professorName'],
      professorAvatar: json['professorAvatar'],
      professorId: json['professorId'],
      major: json['major'] ?? 'Chưa có chuyên khoa',
      dateTime: json['dateTime'] ?? '',
      date: json['date'] ?? '',
      rating: json['rating'].toDouble(),
      totalRating: json['totalRating'] ?? 0,
    );
  }
}

class PackageData {
  final int bookingId;
  final int accountId;
  final int elderlyId;
  final int subscriptionId;
  final double price;
  final String bookingDate;
  final String paymentMethod;
  final String note;
  final String status;
  final int transactionId;
  final int professorId;

  PackageData({
    required this.bookingId,
    required this.accountId,
    required this.elderlyId,
    required this.subscriptionId,
    required this.price,
    required this.bookingDate,
    required this.paymentMethod,
    required this.note,
    required this.status,
    required this.transactionId,
    required this.professorId,
  });

  factory PackageData.fromJson(Map<String, dynamic> json) {
    return PackageData(
      bookingId: json['bookingId'],
      accountId: json['accountId'],
      elderlyId: json['elderlyId'],
      subscriptionId: json['subscriptionId'],
      price: json['price'].toDouble(),
      bookingDate: json['bookingDate'],
      paymentMethod: json['paymentMethod'],
      note: json['note'],
      status: json['status'],
      transactionId: json['transactionId'],
      professorId: json['professorId'] ?? 0,
    );
  }
}

class ComboData {
  final int subscriptionId;
  final String name;
  final String description;
  final double fee;
  final int validityPeriod;
  final String createdDate;
  final String createdTime;
  final String updatedTime;
  final String updatedDate;
  final String status;
  final int accountId;
  final int numberOfMeeting;

  ComboData({
    required this.subscriptionId,
    required this.name,
    required this.description,
    required this.fee,
    required this.validityPeriod,
    required this.createdTime,
    required this.updatedTime,
    required this.status,
    required this.accountId,
    required this.numberOfMeeting,
    required this.createdDate,
    required this.updatedDate,
  });

  factory ComboData.fromJson(Map<String, dynamic> json) {
    return ComboData(
      subscriptionId: json['subscriptionId'],
      name: json['name'],
      description: json['description'],
      fee: json['fee'],
      validityPeriod: json['validityPeriod'],
      createdTime: json['createdTime'],
      updatedTime: json['updatedTime'],
      status: json['status'],
      accountId: json['accountId'] ?? 0,
      numberOfMeeting: json['numberOfMeeting'] ?? 0,
      createdDate: json['createdDate'],
      updatedDate: json['updatedDate'],
    );
  }
}

class CheckoutResponse {
  final int returnCode;
  final String returnMessage;
  final int subReturnCode;
  final String subReturnMessage;
  final String orderUrl;
  final String zpTransToken;
  final String orderToken;
  final String qrCode;
  final String appTransId;

  CheckoutResponse({
    required this.returnCode,
    required this.returnMessage,
    required this.subReturnCode,
    required this.subReturnMessage,
    required this.orderUrl,
    required this.zpTransToken,
    required this.orderToken,
    required this.qrCode,
    required this.appTransId,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      returnCode: json['return_code'],
      returnMessage: json['return_message'],
      subReturnCode: json['sub_return_code'],
      subReturnMessage: json['sub_return_message'],
      orderUrl: json['order_url'],
      zpTransToken: json['zp_trans_token'],
      orderToken: json['order_token'],
      qrCode: json['qr_code'] ?? '', 
      appTransId: json['app_trans_id'],
    );
  }
}

