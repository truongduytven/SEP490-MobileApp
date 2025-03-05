class RoomChatDetail {
  final String roomId;
  final String roomName;
  final String roomAvatar;
  final String createdAt;
  final bool isOnline;
  final bool isGroupChat;
  final int numberOfMems;
  final List<User> users;

  RoomChatDetail({
    required this.roomId,
    required this.roomName,
    required this.roomAvatar,
    required this.createdAt,
    required this.isOnline,
    required this.isGroupChat,
    required this.numberOfMems,
    required this.users,
  });

  factory RoomChatDetail.fromJson(Map<String, dynamic> json) {
    return RoomChatDetail(
      roomId: json['roomId'],
      roomName: json['roomName'],
      roomAvatar: json['roomAvatar'],
      createdAt: json['createdAt'],
      isOnline: json['isOnline'],
      isGroupChat: json['isGroupChat'],
      numberOfMems: json['numberOfMems'],
      users:
          (json['users'] as List).map((user) => User.fromJson(user)).toList(),
    );
  }
}

class User {
  final int accountId;
  final String email;
  final String fullName;
  final String avatar;
  final String gender;
  final String phoneNumber;
  final String dateOfBirth;
  final String status;
  final bool? isVerified;
  final bool isCreator;

  User({
    required this.accountId,
    required this.email,
    required this.fullName,
    required this.avatar,
    required this.gender,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.status,
    required this.isCreator,
    this.isVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accountId: json['accountId'],
      email: json['email'],
      fullName: json['fullName'],
      avatar: json['avatar'],
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth: json['dateOfBirth'],
      status: json['status'],
      isVerified: json['isVerified'],
      isCreator: json['isCreator'],
    );
  }
}
