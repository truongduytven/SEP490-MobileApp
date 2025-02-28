import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/enums/message_enum.dart';
import 'package:sep490/common/provider/message_reply_provider.dart';
import 'package:sep490/models/chat_room_status.dart';
import 'package:sep490/models/message.dart';
import 'package:sep490/models/room_chat.dart';
import 'package:sep490/presentation/pages/auth/controller/auth_controller.dart';
import 'package:sep490/features/chat/repository/chat_repository.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<RoomChat>> getRoomChatStream(String userId) {
    return chatRepository.getRoomChatStream(userId);
  }

  Stream<List<Message>> getChatStream(String roomId) {
    print("getchat scree $roomId");
    return chatRepository.getChatStream(roomId);
  }

  Stream<ChatRoomStatus> getRoomChatStatus(String roomId, int currentUserId) {
    return chatRepository.getStatusRoomChatStream(roomId, currentUserId);
  }

  void sendTextMessage(
    BuildContext context,
    String roomId,
    dynamic message,
    int senderId,
    MessageEnum messageType,
  ) {
    final messageReply = ref.read(messsageReplyProvider);
    String? repliedMessageId;
    if (messageReply != null) {
      repliedMessageId = messageReply.messsageId;
      print("Reply message ID: $repliedMessageId");
    }
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            roomId: roomId,
            message: message,
            senderId: senderId,
            messageType: messageType,
            repliedMessageId: repliedMessageId,
          ),
        );
    ref.read(messsageReplyProvider.state).update((state) => null);
  }

  void setChatMessaageSeen(
    BuildContext context,
    String roomId,
    int curentUserId,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.setChatMessaageSeen(
            context: context,
            roomId: roomId,
            currentUserID: curentUserId,
          ),
        );
  }

  // void sendGIFMessage(
  //   BuildContext context,
  //   String gifUrl,
  //   String recieverUserId,
  //   bool isGroupChat,
  // ) {
  //   final messageReply = ref.read(messsageReplyProvider);

  //   // int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
  //   // String gifUrlPath = gifUrl.substring(gifUrlPartIndex);
  //   // String newgifUrl = 'https://i.giphy.com/media/$gifUrlPath/200.gif';
  //   ref.read(userDataAuthProvider).whenData(
  //         (value) => chatRepository.sendGIFMessage(
  //           context: context,
  //           gifUrl: gifUrl,
  //           recieverUserId: recieverUserId,
  //           senderUser: value!,
  //           messageReply: messageReply,
  //           isGroupChat: isGroupChat,
  //         ),
  //       );
  //   ref.read(messsageReplyProvider.state).update((state) => null);
  // }

  // void setChatMessaageSeen(
  //   BuildContext context,
  //   String recieverUserId,
  //   String messageId,
  // ) {
  //   chatRepository.setChatMessageSeen(
  //     context,
  //     recieverUserId,
  //     messageId,
  //   );
  // }
}
