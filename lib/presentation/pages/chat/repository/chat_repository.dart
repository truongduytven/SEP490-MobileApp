// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sep490/common/enums/message_enum.dart';
// import 'package:sep490/common/provider/message_reply_provider.dart';
// import 'package:sep490/common/utils/utils.dart';
// import 'package:sep490/models/chat_contact.dart';
// import 'package:sep490/models/group.dart';
// import 'package:sep490/models/message.dart';
// import 'package:sep490/models/user_model.dart';
// import 'package:uuid/uuid.dart';

// final chatRepositoryProvider = Provider((ref) => ChatRepository(
//     fireStore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

// class ChatRepository {
//   final FirebaseFirestore fireStore;
//   final FirebaseAuth auth;

//   ChatRepository({
//     required this.fireStore,
//     required this.auth,
//   });

//   Stream<List<ChatContact>> getChatContacts() {
//     return fireStore
//         .collection('users')
//         .doc(auth.currentUser!.uid)
//         .collection('chats')
//         .snapshots()
//         .asyncMap((event) async {
//       List<ChatContact> contacts = [];
//       for (var document in event.docs) {
//         var chatContact = ChatContact.fromMap(document.data());
//         var userData = await fireStore
//             .collection('users')
//             .doc(chatContact.contactId)
//             .get();
//         var user = UserModel.fromMap(userData.data()!);
//         contacts.add(
//           ChatContact(
//             name: user.name,
//             profilePic: user.profilePic,
//             contactId: chatContact.contactId,
//             timeSent: chatContact.timeSent,
//             lastMessage: chatContact.lastMessage,
//           ),
//         );
//       }
//       return contacts;
//     });
//   }

//   Stream<List<Group>> getChatGroups() {
//     return fireStore.collection('groups').snapshots().map((event) {
//       List<Group> groups = [];
//       for (var document in event.docs) {
//         var group = Group.fromMap(document.data());
//         if (group.membersUid.contains(auth.currentUser!.uid)) {
//           groups.add(group);
//         }
//       }
//       return groups;
//     });
//   }

//   Stream<List<Message>> getChatStream(String recieverUserId) {
//     return fireStore
//         .collection('users')
//         .doc(auth.currentUser!.uid)
//         .collection('chats')
//         .doc(recieverUserId)
//         .collection('messages')
//         .orderBy('timeSent')
//         .snapshots()
//         .map((event) {
//       List<Message> messages = [];
//       for (var document in event.docs) {
//         messages.add(Message.fromMap(document.data()));
//       }
//       // for (var message in messages) {
//       //   print('Message: ${message.text}, Time: ${message.timeSent}');
//       // }

//       return messages;
//     });
//   }

//   Stream<List<Message>> getGroupChatStream(String groupId) {
//     return fireStore
//         .collection('groups')
//         .doc(groupId)
//         .collection('chats')
//         .orderBy('timeSent')
//         .snapshots()
//         .map((event) {
//       List<Message> messages = [];
//       for (var document in event.docs) {
//         messages.add(Message.fromMap(document.data()));
//       }
//       // for (var message in messages) {
//       //   print('Message: ${message.text}, Time: ${message.timeSent}');
//       // }

//       return messages;
//     });
//   }

//   void _saveDataToContactsSubcollection(
//     UserModel senderUserData,
//     UserModel? recieverUserData,
//     String text,
//     DateTime timeSent,
//     String recieverUserId,
//     bool isGroupChat,
//   ) async {
//     if (isGroupChat) {
//       await fireStore.collection('groups').doc(recieverUserId).update({
//         'lastMessage': text,
//         'timeSent': DateTime.now().microsecondsSinceEpoch,
//       });
//     } else {
//       //users -> reciever user id -> chats -> current user id -> set data
//       var recieverChatContact = ChatContact(
//         name: senderUserData.name,
//         profilePic: senderUserData.profilePic,
//         contactId: senderUserData.uid,
//         timeSent: timeSent,
//         lastMessage: text,
//       );
//       await fireStore
//           .collection('users')
//           .doc(recieverUserId)
//           .collection('chats')
//           .doc(auth.currentUser!.uid)
//           .set(recieverChatContact.toMap());
//       //users -> current  user id -> chats ->  reciever user id -> set data
//       var senderChatContact = ChatContact(
//         name: recieverUserData!.name,
//         profilePic: recieverUserData.profilePic,
//         contactId: recieverUserData.uid,
//         timeSent: timeSent,
//         lastMessage: text,
//       );

//       await fireStore
//           .collection('users')
//           .doc(auth.currentUser!.uid)
//           .collection('chats')
//           .doc(recieverUserId)
//           .set(senderChatContact.toMap());
//     }
//   }

//   void _saveMessageToMessageSubcollection({
//     required String recieverUserId,
//     required String text,
//     required DateTime timeSent,
//     required String messageId,
//     required String username,
//     // required String recieverUsername,
//     required MessageEnum messageType,
//     required MessageReply? messageReply,
//     required String senderUsername,
//     required String? recieverUserName,
//     required bool isGroupChat,
//   }) async {
//     final message = Message(
//       senderId: auth.currentUser!.uid,
//       recieverid: recieverUserId,
//       text: text,
//       type: messageType,
//       timeSent: timeSent,
//       messageId: messageId,
//       isSeen: false,
//       repliedMessage: messageReply == null ? '' : messageReply.messsage,
//       repliedTo: messageReply == null
//           ? ''
//           : messageReply.isMe
//               ? senderUsername
//               : recieverUserName ?? '',
//       repliedMessageType:
//           messageReply == null ? MessageEnum.text : messageReply.messageEnum,
//     );

//     if (isGroupChat) {
//       await fireStore
//           .collection('groups')
//           .doc(recieverUserId)
//           .collection('chats')
//           .doc(messageId)
//           .set(message.toMap());
//     } else {
//       // users -> sender id -> reciever id -> messages -> mesage id -> store message

//       await fireStore
//           .collection('users')
//           .doc(auth.currentUser!.uid)
//           .collection('chats')
//           .doc(recieverUserId)
//           .collection('messages')
//           .doc(messageId)
//           .set(
//             message.toMap(),
//           );

//       await fireStore
//           .collection('users')
//           .doc(recieverUserId)
//           .collection('chats')
//           .doc(auth.currentUser!.uid)
//           .collection('messages')
//           .doc(messageId)
//           .set(
//             message.toMap(),
//           );
//     }
//   }

//   void sendTextMessage({
//     required BuildContext context,
//     required String text,
//     required String recieverUserId,
//     required UserModel senderUser,
//     required MessageReply? messageReply,
//     required bool isGroupChat,
//   }) async {
//     try {
//       var timeSent = DateTime.now();
//       UserModel? recieverUserData;
//       if (!isGroupChat) {
//         var userDataMap =
//             await fireStore.collection('users').doc(recieverUserId).get();
//         recieverUserData = UserModel.fromMap(userDataMap.data()!);
//       }

//       var messageId = const Uuid().v1();
//       _saveDataToContactsSubcollection(
//         senderUser,
//         recieverUserData,
//         text,
//         timeSent,
//         recieverUserId,
//         isGroupChat,
//       );

//       _saveMessageToMessageSubcollection(
//         recieverUserId: recieverUserId,
//         text: text,
//         timeSent: timeSent,
//         messageType: MessageEnum.text,
//         messageId: messageId,
//         username: senderUser.name,
//         messageReply: messageReply,
//         recieverUserName: recieverUserData?.name,
//         senderUsername: senderUser.name,
//         isGroupChat: isGroupChat,
//       );
//     } catch (e) {
//       showSnackBar(context: context, content: e.toString());
//     }
//   }

//   void sendFileMessage({
//     required BuildContext context,
//     required File file,
//     required String recieverUserId,
//     required UserModel senderUserData,
//     required ProviderRef ref,
//     required MessageEnum messageEnum,
//     required MessageReply? messageReply,
//     required bool isGroupChat,
//   }) async {
//     try {
//       var timeSent = DateTime.now();
//       var messageId = const Uuid().v1();
//       // String imageUrl = await ref
//       //     .read(commonFirebaseStorageRepositoryProvider)
//       //     .storeFileToFirebase(
//       //         'chat/${messageEnum.type}/${senderUserData.uid}/${recieverUserId}/$messageId',
//       //         file);
//       String imageUrl = '';
//       UserModel? recieverUserData;
//       if (!isGroupChat) {
//         var userDataMap =
//             await fireStore.collection('users').doc(recieverUserId).get();
//         recieverUserData = UserModel.fromMap(userDataMap.data()!);
//       }
//       String contactMsg;
//       switch (messageEnum) {
//         case MessageEnum.image:
//           contactMsg = '📷 Photo';
//           break;
//         case MessageEnum.video:
//           contactMsg = '📸 Video';
//           break;
//         case MessageEnum.audio:
//           contactMsg = '🎵 Audio';
//           break;
//         case MessageEnum.gif:
//           contactMsg = 'GIF';
//           break;
//         default:
//           contactMsg = 'GIF';
//       }
//       _saveDataToContactsSubcollection(
//         senderUserData,
//         recieverUserData,
//         contactMsg,
//         timeSent,
//         recieverUserId,
//         isGroupChat,
//       );
//       _saveMessageToMessageSubcollection(
//         recieverUserId: recieverUserId,
//         text: imageUrl,
//         timeSent: timeSent,
//         messageId: messageId,
//         username: senderUserData.name,
//         // recieverUsername: recieverUserData.name,
//         messageType: messageEnum,
//         messageReply: messageReply,
//         recieverUserName: recieverUserData?.name,
//         senderUsername: senderUserData.name,
//         isGroupChat: isGroupChat,
//       );
//     } catch (e) {
//       print('lỗi $e');
//       showSnackBar(context: context, content: e.toString());
//     }
//   }

//   void sendGIFMessage({
//     required BuildContext context,
//     required String gifUrl,
//     required String recieverUserId,
//     required UserModel senderUser,
//     required MessageReply? messageReply,
//     required bool isGroupChat,
//   }) async {
//     try {
//       var timeSent = DateTime.now();
//       UserModel? recieverUserData;
//       if (!isGroupChat) {
//         var userDataMap =
//             await fireStore.collection('users').doc(recieverUserId).get();
//         recieverUserData = UserModel.fromMap(userDataMap.data()!);
//       }

//       var messageId = const Uuid().v1();
//       _saveDataToContactsSubcollection(
//         senderUser,
//         recieverUserData,
//         'GIF',
//         timeSent,
//         recieverUserId,
//         isGroupChat,
//       );

//       _saveMessageToMessageSubcollection(
//         recieverUserId: recieverUserId,
//         text: gifUrl,
//         timeSent: timeSent,
//         messageType: MessageEnum.gif,
//         messageId: messageId,
//         // recieverUsername: recieverUserData.name,
//         username: senderUser.name,
//         messageReply: messageReply,
//         recieverUserName: recieverUserData?.name,
//         senderUsername: senderUser.name,
//         isGroupChat: isGroupChat,
//       );
//     } catch (e) {
//       showSnackBar(context: context, content: e.toString());
//     }
//   }

//   void setChatMessageSeen(
//     BuildContext context,
//     String recieverUserId,
//     String messageId,
//   ) async {
//     try {
//       await fireStore
//           .collection('users')
//           .doc(auth.currentUser!.uid)
//           .collection('chats')
//           .doc(recieverUserId)
//           .collection('messages')
//           .doc(messageId)
//           .update({'isSeen': true});

//       await fireStore
//           .collection('users')
//           .doc(recieverUserId)
//           .collection('chats')
//           .doc(auth.currentUser!.uid)
//           .collection('messages')
//           .doc(messageId)
//           .update({'isSeen': true});
//     } catch (e) {
//       showSnackBar(context: context, content: e.toString());
//     }
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sep490/common/enums/message_enum.dart';
import 'package:sep490/common/provider/message_reply_provider.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/models/chat_contact.dart';
import 'package:sep490/models/group.dart';
import 'package:sep490/models/message.dart';
import 'package:sep490/models/room_chat.dart';
import 'package:sep490/models/user_model.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository());

class ChatRepository {
  final String baseUrl =
      'https://your-api.com/api'; // Replace with your API base URL

  final StreamController<List<ChatContact>> _chatContactsController =
      StreamController.broadcast();
  final StreamController<List<Group>> _chatGroupsController =
      StreamController.broadcast();
  final Map<String, StreamController<List<Message>>> _chatStreams = {};
  final Map<String, StreamController<List<Message>>> _groupChatStreams = {};

  ///fetch roomChat
  Stream<List<RoomChat>> getRoomChatStream(String userId) async* {
    while (true) {
      try {
        final response = await http.get(Uri.parse(
            'https://api.diavan-valuation.asia/chat-management/$userId/room-chat'));
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseBody = jsonDecode(response.body);
          if (responseBody['status'] == 1) {
            List<dynamic> data = responseBody['data'];
            yield data.map((json) => RoomChat.fromJson(json)).toList();
          } else {
            yield [];
          }
        } else {
          yield [];
        }
      } catch (e) {
        yield [];
      }
      await Future.delayed(const Duration(seconds: 5)); // Poll every 5 seconds
    }
  }

  /// Stream for chat contacts
  Stream<List<ChatContact>> getContactsStream(String userId) {
    _fetchContacts(userId);
    return _chatContactsController.stream;
  }

  Future<void> _fetchContacts(String userId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/chats/$userId/contacts'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        _chatContactsController
            .add(data.map((e) => ChatContact.fromMap(e)).toList());
      } else {
        _chatContactsController.addError('Failed to load chat contacts');
      }
    } catch (e) {
      _chatContactsController.addError(e.toString());
    }
  }

  /// Stream for chat groups
  Stream<List<Group>> getGroupsStream(String userId) {
    _fetchGroups(userId);
    return _chatGroupsController.stream;
  }

  Future<void> _fetchGroups(String userId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/chats/$userId/groups'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        _chatGroupsController.add(data.map((e) => Group.fromMap(e)).toList());
      } else {
        _chatGroupsController.addError('Failed to load chat groups');
      }
    } catch (e) {
      _chatGroupsController.addError(e.toString());
    }
  }

  /// Stream for private chat messages
  Stream<List<Message>> getChatStream(String senderId, String receiverId) {
    String chatKey = '$senderId-$receiverId';
    if (!_chatStreams.containsKey(chatKey)) {
      _chatStreams[chatKey] = StreamController<List<Message>>.broadcast();
      _fetchChatMessages(senderId, receiverId);
    }
    return _chatStreams[chatKey]!.stream;
  }

  Future<void> _fetchChatMessages(String senderId, String receiverId) async {
    String chatKey = '$senderId-$receiverId';
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/chats/$senderId/$receiverId/messages'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        List<Message> messages = data.map((e) => Message.fromMap(e)).toList();
        // messages.sort((a, b) =>
        //     b.timestamp.compareTo(a.timestamp)); // Sort by latest first
        _chatStreams[chatKey]!.add(messages);
      } else {
        _chatStreams[chatKey]!.addError('Failed to load messages');
      }
    } catch (e) {
      _chatStreams[chatKey]!.addError(e.toString());
    }
  }

  /// Stream for group chat messages
  Stream<List<Message>> getGroupChatStream(String groupId) {
    if (!_groupChatStreams.containsKey(groupId)) {
      _groupChatStreams[groupId] = StreamController<List<Message>>.broadcast();
      _fetchGroupMessages(groupId);
    }
    return _groupChatStreams[groupId]!.stream;
  }

  Future<void> _fetchGroupMessages(String groupId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/groups/$groupId/messages'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        List<Message> messages = data.map((e) => Message.fromMap(e)).toList();
        // messages.sort((a, b) =>
        //     b.timestamp.compareTo(a.timestamp)); // Sort by latest first
        _groupChatStreams[groupId]!.add(messages);
      } else {
        _groupChatStreams[groupId]!.addError('Failed to load group messages');
      }
    } catch (e) {
      _groupChatStreams[groupId]!.addError(e.toString());
    }
  }

  /// Send text message
  Future<void> sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now().toIso8601String();
      var messageId = const Uuid().v1();

      final response = await http.post(
        Uri.parse('$baseUrl/messages/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'senderId': senderUser.uid,
          'receiverId': receiverUserId,
          'text': text,
          'timeSent': timeSent,
          'messageId': messageId,
          'isGroupChat': isGroupChat,
          'repliedMessage': messageReply?.messsage ?? '',
          'repliedTo': messageReply?.isMe == true ? senderUser.name : '',
          'messageType': MessageEnum.text.toString(),
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  /// Send file message
  Future<void> sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/messages/upload'),
      );
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields['senderId'] = senderUserData.uid;
      request.fields['receiverId'] = receiverUserId;
      request.fields['messageType'] = messageEnum.toString();
      request.fields['isGroupChat'] = isGroupChat.toString();

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var data = json.decode(responseData);
        var fileUrl = data['fileUrl'];

        sendTextMessage(
          context: context,
          text: fileUrl,
          receiverUserId: receiverUserId,
          senderUser: senderUserData,
          messageReply: messageReply,
          isGroupChat: isGroupChat,
        );
      } else {
        throw Exception('Failed to upload file');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
