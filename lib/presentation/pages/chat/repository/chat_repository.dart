import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:sep490/common/enums/message_enum.dart';
import 'package:sep490/common/provider/message_reply_provider.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/models/chat_contact.dart';
import 'package:sep490/models/chat_room_status.dart';
import 'package:sep490/models/group.dart';
import 'package:sep490/models/message.dart';
import 'package:sep490/models/room_chat.dart';
import 'package:sep490/models/user_model.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository());

class ChatRepository {
  final String baseUrl =
      'https://your-api.com/api'; // Replace with your API base URL
  Timer? _statusTimer;
  Timer? _fetchTimer;
  final StreamController<List<ChatContact>> _chatContactsController =
      StreamController.broadcast();
  final StreamController<ChatRoomStatus> _statusStreamController =
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

//fetch message in room chat

  final StreamController<List<Message>> _chatStreamController =
      StreamController.broadcast();

  Stream<List<Message>> getChatStream(String roomId) {
    print("✅ getChatStream called for roomId: $roomId");
    startFetchingMessages(roomId);
    return _chatStreamController.stream;
  }

  void startFetchingMessages(String roomId) {
    _fetchMessages(roomId); // Fetch initially
    _fetchTimer?.cancel(); // Prevent multiple timers
    _fetchTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchMessages(roomId); // Fetch every 5 seconds
    });
  }

  Future<void> _fetchMessages(String roomId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.diavan-valuation.asia/chat-management/$roomId/messages'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 1 && jsonResponse.containsKey('data')) {
          List<Message> messages = (jsonResponse['data'] as List)
              .map((msg) => Message.fromJson(msg))
              .toList();

          _chatStreamController.add(messages);
        } else {
          print('No messages found or incorrect response format.');
        }
      } else {
        print('Failed to fetch messages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching chat messages: $e');
    }
  }

  void dispose() {
    _statusTimer?.cancel();
    _fetchTimer?.cancel();
    _chatStreamController.close();
    _statusStreamController.close();
  }

  //get status online oorr offline of roomchat
  Stream<ChatRoomStatus> getStatusRoomChatStream(
      String roomId, int currentUserId) {
    _startChatStatusPolling(roomId, currentUserId);
    return _statusStreamController.stream;
  }

  void _startChatStatusPolling(String roomId, int currentUserId) {
    // Cancel existing timer if running to prevent multiple loops
    _statusTimer?.cancel();

    _statusTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final response = await http.get(
          Uri.parse(
            'https://api.diavan-valuation.asia/chat-management/status-in-room-chat?roomId=$roomId&currentUserId=$currentUserId',
          ),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status'] == 1 && jsonResponse.containsKey('data')) {
            bool isOnline = jsonResponse['data']['isOnline'];
            _statusStreamController.add(ChatRoomStatus(isOnline: isOnline));
          } else {
            _statusStreamController.add(ChatRoomStatus(isOnline: false));
          }
        } else {
          _statusStreamController.add(ChatRoomStatus(isOnline: false));
        }
      } catch (e) {
        _statusStreamController.add(ChatRoomStatus(isOnline: false));
      }
    });
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

  // /// Stream for private chat messages
  // Stream<List<Message>> getChatStream(String senderId, String receiverId) {
  //   String chatKey = '$senderId-$receiverId';
  //   if (!_chatStreams.containsKey(chatKey)) {
  //     _chatStreams[chatKey] = StreamController<List<Message>>.broadcast();
  //     _fetchChatMessages(senderId, receiverId);
  //   }
  //   return _chatStreams[chatKey]!.stream;
  // }

  Future<void> _fetchChatMessages(String senderId, String receiverId) async {
    String chatKey = '$senderId-$receiverId';
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/chats/$senderId/$receiverId/messages'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        List<Message> messages = data.map((e) => Message.fromJson(e)).toList();
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
        List<Message> messages = data.map((e) => Message.fromJson(e)).toList();
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
  // Future<void> sendTextMessage({
  //   required BuildContext context,
  //   required String text,
  //   required String receiverUserId,
  //   required UserModel senderUser,
  //   required MessageReply? messageReply,
  //   required bool isGroupChat,
  // }) async {
  //   try {
  //     var timeSent = DateTime.now().toIso8601String();
  //     var messageId = const Uuid().v1();

  //     final response = await http.post(
  //       Uri.parse('$baseUrl/messages/send'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'senderId': senderUser.accountId,
  //         'receiverId': receiverUserId,
  //         'text': text,
  //         'timeSent': timeSent,
  //         'messageId': messageId,
  //         'isGroupChat': isGroupChat,
  //         'repliedMessage': messageReply?.messsage ?? '',
  //         'repliedTo': messageReply?.isMe == true ? senderUser.fullName : '',
  //         'messageType': MessageEnum.Text.toString(),
  //       }),
  //     );

  //     if (response.statusCode != 200) {
  //       throw Exception('Failed to send message');
  //     }
  //   } catch (e) {
  //     showSnackBar(context: context, content: e.toString());
  //   }
  // }

  // Future<void> sendTextMessage({
  //   required BuildContext context,
  //   required int senderId,
  //   required String roomId,
  //   required dynamic  message,
  //   required MessageEnum messageType,
  // }) async {
  //   try {
  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse(
  //           'https://api.diavan-valuation.asia/chat-management/send-message'),
  //     );

  //     request.fields['SenderId'] = senderId.toString();
  //     request.fields['RoomId'] = roomId;
  //     request.fields['MessageType'] = messageType.toJson();
  //     request.fields['Message'] = message;

  //   if (message is String) {
  //     request.fields['Message'] = message;
  //   } else if (message is File) {
  //     request.files.add(await http.MultipartFile.fromPath(
  //       'FileMessage', // Key for the file
  //       message.path,
  //     ));
  //   } else {
  //     throw Exception("Invalid message type: must be a String or File");
  //   }
  //     request.headers['Content-Type'] = 'multipart/form-data';

  //     var response = await request.send();
  //     var responseBody = await response.stream.bytesToString();
  //     var jsonResponse = jsonDecode(responseBody);

  //     if (response.statusCode == 200 && jsonResponse['status'] == 1) {
  //       print("✅ Message sent successfully");
  //     } else {
  //       print("❌ Failed to send message: ${jsonResponse['message']}");
  //     }
  //   } catch (e) {
  //     showSnackBar(context: context, content: e.toString());

  //     print("🚨 Error sending message: $e");
  //   }
  // }

  Future<void> sendTextMessage({
    required BuildContext context,
    required int senderId,
    required String roomId,
    required dynamic message, // Can be String or File
    required MessageEnum messageType,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://api.diavan-valuation.asia/chat-management/send-message'),
      );

      request.fields['SenderId'] = senderId.toString();
      request.fields['RoomId'] = roomId;
      request.fields['MessageType'] =
          messageType.toJson(); // ✅ Convert enum to string

      if (message is String) {
        // ✅ Handle text message
        request.fields['Message'] = message;
      } else if (message is File) {
        // ✅ Handle file message
        String fileName = basename(message.path);
        String? mimeType = lookupMimeType(message.path);

        request.files.add(await http.MultipartFile.fromPath(
          'FileMessage', // ✅ Key for file in API request
          message.path,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        ));
      } else {
        throw Exception("Invalid message type: must be a String or File");
      }

      request.headers['Content-Type'] = 'multipart/form-data';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 && jsonResponse['status'] == 1) {
        print("✅ Message sent successfully");
      } else {
        print("❌ Failed to send message: ${jsonResponse['message']}");
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      print("🚨 Error sending message: $e");
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
      request.fields['senderId'] = senderUserData.avatar;
      request.fields['receiverId'] = receiverUserId;
      request.fields['messageType'] = messageEnum.toString();
      request.fields['isGroupChat'] = isGroupChat.toString();

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var data = json.decode(responseData);
        var fileUrl = data['fileUrl'];

        // sendTextMessage(
        //   context: context,
        //   text: fileUrl,
        //   receiverUserId: receiverUserId,
        //   senderUser: senderUserData,
        //   messageReply: messageReply,
        //   isGroupChat: isGroupChat,
        // );
      } else {
        throw Exception('Failed to upload file');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
