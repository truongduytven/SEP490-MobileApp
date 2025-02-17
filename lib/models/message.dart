// import 'package:sep490/common/enums/message_enum.dart';

// class Message {
//   final String senderId;
//   final String recieverid;
//   // roomId
//   final String text;
//   final MessageEnum type;
//   // khoi gui timeSent
//   final DateTime timeSent;
//   final String messageId;
//   final bool isSeen;
//   final String repliedMessage;
//   final String repliedTo;
//   final MessageEnum repliedMessageType;
//   Message({
//     required this.senderId,
//     required this.recieverid,
//     required this.text,
//     required this.type,
//     required this.timeSent,
//     required this.messageId,
//     required this.isSeen,
//     required this.repliedMessage,
//     required this.repliedTo,
//     required this.repliedMessageType,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'senderId': senderId,
//       'recieverid': recieverid,
//       'text': text,
//       'type': type.type,
//       'timeSent': timeSent.millisecondsSinceEpoch,
//       'messageId': messageId,
//       'isSeen': isSeen,
//       'repliedMessage': repliedMessage,
//       'repliedTo': repliedTo,
//       'repliedMessageType': repliedMessageType.type,
//     };
//   }

//   factory Message.fromMap(Map<String, dynamic> map) {
//     return Message(
//       senderId: map['senderId'] as String,
//       recieverid: map['recieverid'] as String,
//       text: map['text'] as String,
//       type: (map['type'] as String).toEnum(),
//       timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
//       messageId: map['messageId'] as String,
//       isSeen: map['isSeen'] as bool,
//       repliedMessage: map['repliedMessage'] as String,
//       repliedTo: map['repliedTo'] as String,
//       repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
//     );
//   }
// }
import 'package:sep490/common/enums/message_enum.dart';

class Message {
  final int senderId;
  final String senderName;
  final String senderAvatar;
  final String messageId;
  final String message;
  final MessageEnum messageType;
  final String sentDate;
  final String sentTime;
  final String sentDateTime;
  final bool isSeen;
  final String repliedMessage;
  final String replyTo;
  final MessageEnum repliedMessageType;

  Message({
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.messageId,
    required this.message,
    required this.messageType,
    required this.sentDate,
    required this.sentTime,
    required this.sentDateTime,
    required this.isSeen,
    required this.repliedMessage,
    required this.replyTo,
    required this.repliedMessageType,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'] ?? 0,
      senderName: json['senderName'] ?? '',
      senderAvatar: json['senderAvatar'] ?? '',
      messageId: json['messageId'] ?? '',
      message: json['message'] ?? '',
      messageType:
          MessageEnumExtension.fromString(json['messageType'] ?? 'Text'),
      sentDate: json['sentDate'] ?? '',
      sentTime: json['sentTime'] ?? '',
      sentDateTime: json['sentDateTime'] ?? '',
      isSeen: json['isSeen'] ?? false,
      repliedMessage: json['repliedMessage']?.toString() ?? "",
      replyTo: json['replyTo']?.toString() ?? "",
      repliedMessageType:
          MessageEnumExtension.fromString(json['repliedMessageType'] ?? 'Text'),
    );
  }
}
