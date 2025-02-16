// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sep490/common/enums/message_enum.dart';
import 'package:sep490/common/provider/message_reply_provider.dart';
import 'package:sep490/common/widgets/loader.dart';
import 'package:sep490/models/message.dart';
import 'package:sep490/presentation/pages/auth/controller/auth_controller.dart';
import 'package:sep490/presentation/pages/chat/controller/chat_controller.dart';
import 'package:sep490/presentation/pages/chat/widgets/my_message_card.dart';
import 'package:sep490/presentation/pages/chat/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String roomId;
  final bool isGroupChat;
  const ChatList({
    Key? key,
    required this.roomId,
    required this.isGroupChat,
  }) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    ref.read(messsageReplyProvider.state).update(
          (state) => MessageReply(
            message,
            isMe,
            messageEnum,
          ),
        );
  }

//   @override
//   Widget build(BuildContext context) {
//     final accountId = ref.watch(accountIdProvider);
//     return StreamBuilder<List<Message>>(
//         stream: ref.read(chatControllerProvider).getChatStream(widget.roomId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Loader();
//           }

//           SchedulerBinding.instance.addPostFrameCallback((_) {
//             messageController
//                 .jumpTo(messageController.position.maxScrollExtent);
//           });
//           return ListView.builder(
//             controller: messageController,
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               final messageData = snapshot.data![index];
//               // var timeSent = DateFormat.Hm().format(messageData.timeSent);

//               // if (!messageData.isSeen &&
//               //     messageData.recieverid ==
//               //         FirebaseAuth.instance.currentUser!.uid) {
//               //   ref.read(chatControllerProvider).setChatMessaageSeen(
//               //         context,
//               //         widget.recieverUserId,
//               //         messageData.messageId,
//               //       );
//               // }
//               if (messageData.senderId == accountId) {
//                 return MyMessageCard(
//                   message: messageData.message,
//                   date: messageData.sentTime,
//                   type: messageData.messageType,
//                   repliedText: messageData.repliedMessage,
//                   username: messageData.replyTo,
//                   repliedMessageType: messageData.repliedMessageType,
//                   onLeftSwipe: (details) => onMessageSwipe(
//                     messageData.message,
//                     true,
//                     messageData.messageType,
//                   ),
//                   isSeen: messageData.isSeen,
//                 );
//               }
//               return SenderMessageCard(
//                 message: messageData.message,
//                 date: messageData.sentTime,
//                 type: messageData.messageType,
//                 username: messageData.replyTo,
//                 repliedMessageType: messageData.repliedMessageType,
//                 onRightSwipe: (details) => onMessageSwipe(
//                   messageData.message,
//                   false,
//                   messageData.messageType,
//                 ),
//                 repliedText: messageData.repliedMessage,
//               );
//             },
//           );
//         });
//   }
  @override
  Widget build(BuildContext context) {
    final accountIdAsync =
        ref.watch(accountIdProvider); // ✅ Get AsyncValue<int?>

    return accountIdAsync.when(
      data: (accountId) {
        return StreamBuilder<List<Message>>(
          stream: ref.read(chatControllerProvider).getChatStream(widget.roomId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }

            SchedulerBinding.instance.addPostFrameCallback((_) {
              messageController
                  .jumpTo(messageController.position.maxScrollExtent);
            });

            return ListView.builder(
              controller: messageController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final messageData = snapshot.data![index];
                // if (!messageData.isSeen &&
//               //     messageData.recieverid ==
//               //         FirebaseAuth.instance.currentUser!.uid) {
//               //   ref.read(chatControllerProvider).setChatMessaageSeen(
//               //         context,
//               //         widget.recieverUserId,
//               //         messageData.messageId,
//               //       );
//               // }
                if (accountId != null && messageData.senderId == accountId) {
                  // ✅ Compare safely
                  return MyMessageCard(
                    message: messageData.message,
                    date: messageData.sentTime,
                    type: messageData.messageType,
                    repliedText: messageData.repliedMessage,
                    username: messageData.replyTo,
                    repliedMessageType: messageData.repliedMessageType,
                    onLeftSwipe: (details) => onMessageSwipe(
                      messageData.message,
                      true,
                      messageData.messageType,
                    ),
                    isSeen: messageData.isSeen,
                  );
                }

                return SenderMessageCard(
                  avatar: messageData.senderAvatar,
                  message: messageData.message,
                  date: messageData.sentTime,
                  type: messageData.messageType,
                  username: messageData.replyTo,
                  repliedMessageType: messageData.repliedMessageType,
                  onRightSwipe: (details) => onMessageSwipe(
                    messageData.message,
                    false,
                    messageData.messageType,
                  ),
                  repliedText: messageData.repliedMessage,
                );
              },
            );
          },
        );
      },
      loading: () => const Loader(), // ✅ Show loader while fetching accountId
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
