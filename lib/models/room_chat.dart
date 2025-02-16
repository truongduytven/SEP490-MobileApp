import 'dart:convert';

class RoomChat {
  final String roomId;
  final String roomName;
  final String roomAvatar;
  final String createdAt;
  final bool isOnline;
  final bool isGroupChat;
  final int numberOfMems;
  final int senderId;
  final String lastMessage;
  final String? sentDate;
  final String? sentTime;
  final String? sentDateTime;

  RoomChat({
    required this.roomId,
    required this.roomName,
    required this.roomAvatar,
    required this.createdAt,
    required this.isOnline,
    required this.isGroupChat,
    required this.numberOfMems,
    required this.senderId,
    required this.lastMessage,
    this.sentDate,
    this.sentTime,
    this.sentDateTime,
  });

  factory RoomChat.fromJson(Map<String, dynamic> json) {
    return RoomChat(
      roomId: json['roomId'],
      roomName: json['roomName'],
      roomAvatar: json['roomAvatar'] ?? '',
      createdAt: json['createdAt'],
      isOnline: json['isOnline'],
      isGroupChat: json['isGroupChat'],
      numberOfMems: json['numberOfMems'],
      senderId: json['senderId'],
      lastMessage: json['lastMessage'] ?? '',
      sentDate: json['sentDate'],
      sentTime: json['sentTime'],
      sentDateTime: json['sentDateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'roomName': roomName,
      'roomAvatar': roomAvatar,
      'createdAt': createdAt,
      'isOnline': isOnline,
      'isGroupChat': isGroupChat,
      'numberOfMems': numberOfMems,
      'senderId': senderId,
      'lastMessage': lastMessage,
      'sentDate': sentDate,
      'sentTime': sentTime,
      'sentDateTime': sentDateTime,
    };
  }

  static List<RoomChat> fromJsonList(String jsonString) {
    final decoded = jsonDecode(jsonString);
    final List<dynamic> dataList = decoded['data'];
    return dataList.map((data) => RoomChat.fromJson(data)).toList();
  }
}
