import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/enums/message_enum.dart';
import 'package:sep490/common/provider/message_reply_provider.dart';
import 'package:sep490/models/chat_contact.dart';
import 'package:sep490/models/group.dart';
import 'package:sep490/models/message.dart';
import 'package:sep490/presentation/pages/auth/controller/auth_controller.dart';
import 'package:sep490/presentation/pages/chat/repository/chat_repository.dart';

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

  Stream<List<ChatContact>> chatContacts(String userId) {
    return chatRepository.getContactsStream(userId);
  }

  Stream<List<Group>> chatGroups(String userId) {
    return chatRepository.getGroupsStream(userId);
  }

  Stream<List<Message>> chatStream(String senderId, String recieverUserId) {
    return chatRepository.getChatStream(senderId, recieverUserId);
  }

  Stream<List<Message>> groupGhatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messsageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUserId: recieverUserId,
            senderUser: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    ref.read(messsageReplyProvider.state).update((state) => null);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String recieverUserId,
    MessageEnum messageEnum,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messsageReplyProvider);

    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            receiverUserId: recieverUserId,
            senderUserData: value!,
            messageEnum: messageEnum,
            ref: ref,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    ref.read(messsageReplyProvider.state).update((state) => null);
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
