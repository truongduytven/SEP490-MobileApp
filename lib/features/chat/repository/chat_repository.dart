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
import 'package:sep490/models/group_chat.dart';
import 'package:sep490/models/message.dart';
import 'package:sep490/models/room_chat.dart';
import 'package:sep490/models/user_model.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository());

class ChatRepository {
 
  Timer? _statusTimer;
  Timer? _fetchTimer;
 
  final StreamController<ChatRoomStatus> _statusStreamController =
      StreamController.broadcast();
  

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


  Future<void> sendTextMessage({
    required BuildContext context,
    required int senderId,
    required String roomId,
    required dynamic message, // Can be String or File
    required MessageEnum messageType,
    String? repliedMessageId,
  }) async {
    print("loại tn ${messageType.toJson()} repliy ${repliedMessageId}");
    try {
      // var request = http.MultipartRequest(
      //   'POST',
      //   Uri.parse(
      //       'https://api.diavan-valuation.asia/chat-management/send-message'),
      // );

      String apiUrl = repliedMessageId != null
          ? 'https://api.diavan-valuation.asia/chat-management/reply-message'
          : 'https://api.diavan-valuation.asia/chat-management/send-message';

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      if (repliedMessageId != null) {
        print("gưi reply $repliedMessageId");
        request.fields['RepliedMessageId'] = repliedMessageId.toString();
      }
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

 
  Future<void> setChatMessaageSeen({
    required BuildContext context,
    required String roomId,
    required int currentUserID,
  }) async {
    final String apiUrl =
        "https://api.diavan-valuation.asia/chat-management/seen";
    try {
      final response = await http.put(
        Uri.parse("$apiUrl?roomId=$roomId&currentUserId=$currentUserID"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final Map<String, dynamic> responseData = json.decode(response.body);

          if (responseData["status"] == 1) {
            // showSnackBar(context: context, content: responseData["message"]);
          } else {
            showSnackBar(
                context: context, content: "Error: ${responseData["message"]}");
          }
        } else {
          showSnackBar(
              context: context, content: "Error: Empty response from server.");
        }
      } else {
        showSnackBar(
            context: context, content: "HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      showSnackBar(context: context, content: "Exception: ${e.toString()}");
    }
  }
}
