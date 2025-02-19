import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/enums/message_enum.dart';

class MessageReply {

  final String messsageId;
  final String messsage;
  final bool isMe;
  final MessageEnum messageEnum;
  MessageReply(
    this.messsageId,
    this.messsage,
    this.isMe,
    this.messageEnum,
  );
}

final messsageReplyProvider = StateProvider<MessageReply?>((ref) => null);
