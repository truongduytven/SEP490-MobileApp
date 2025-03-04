import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/models/group_model.dart';
import 'package:sep490/models/room_chat_detail.dart';
import 'package:sep490/models/user_contact.dart';
import 'package:shared_preferences/shared_preferences.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(),
);

class GroupRepository {
  GroupRepository();

  // Base API URL
  static const String baseUrl = "https://your-api.com";
  Future<List<GroupMember>> getGroupMembers(
      BuildContext context, int userId) async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://api.diavan-valuation.asia/groups/members-in-group/$userId"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 1) {
          GroupResponse groupResponse = GroupResponse.fromJson(jsonData);
          return groupResponse.data;
        } else {
          showSnackBar(context: context, content: "Lỗi tải dữ liệu");

          throw Exception(
              "API returned an error: ${jsonData['message']} ${jsonData['data']}");
        }
      } else {
        showSnackBar(context: context, content: "Lỗi nè hehe");

        throw Exception("Failed to fetch group members.");
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());

      throw Exception("Error fetching group members: $e");
    }
  }

  Future<bool> createGroup(
    BuildContext context,
    String name,
    File? profilePic,
    List<UserContact> selectedContacts,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final accountId = prefs.getInt('accountId');

      if (accountId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Không tìm thấy tài khoản! Vui lòng đăng nhập lại."),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }

      Dio dio = Dio();
      List<Map<String, dynamic>> members = [
        {"accountId": accountId, "isCreator": true}
      ];

      for (var contact in selectedContacts) {
        members.add({
          "accountId": contact.accountId ?? 0,
          "isCreator": false,
        });
      }

      FormData formData = FormData.fromMap({
        "GroupId": "",
        "GroupName": name,
        if (profilePic != null)
          "GroupAvatar": await MultipartFile.fromFile(
            profilePic.path,
            filename: profilePic.path.split('/').last,
          ),
        "Members": members,
      });

      Response response = await dio.post(
        'https://api.diavan-valuation.asia/chat-management/group-chat',
        data: formData,
        options: Options(headers: {
          'accept': '*/*',
          'Content-Type': 'multipart/form-data',
        }),
      );

      final Map<String, dynamic> responseData = response.data;
      print("resonse tạo nhóm ${responseData}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData["status"] == 1) {
          showSnackBar(
              context: context, content: "Tạo nhóm thành công", type: "green");
          return true;
        } else {
          showSnackBar(
              context: context,
              content:
                  "Lỗi: ${responseData["message"]} ${responseData["data"]}");
          return false;
        }
      } else {
        showSnackBar(context: context, content: "Lỗi khi tạo nhóm");
        return false;
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      return false;
    }
  }

  Future<RoomChatDetail?> getRoomChatDetail(
      BuildContext context, String roomId, int userId) async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://api.diavan-valuation.asia/chat-management/room-chat/$roomId/$userId"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 1) {
          // showSnackBar(
          //   context: context,
          //   content: "Tải chi tiết cuộc trò chuyện thành công!",
          //   type: "green",
          // );
          // print("chi tiets cuộc trò hcuyeenj ${jsonData['data']}");
          return RoomChatDetail.fromJson(jsonData['data']);
        } else {
          showSnackBar(
              context: context,
              content: "Lỗi tải dữ liệu: ${jsonData['message']} }");
          return null;
        }
      } else {
        showSnackBar(
            context: context, content: "Lỗi khi tải chi tiết phòng chat");
        return null;
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      return null;
    }
  }

  Future<bool> changeNameGroupChat(
      BuildContext context, String groupId, String groupName) async {
    try {
      final response = await http.put(
        Uri.parse(
            "https://api.diavan-valuation.asia/chat-management/group-chat/group-name?groupId=${groupId}&groupName=${groupName}"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 1) {
          showSnackBar(
            context: context,
            content: "Cuộc trò chuyện đã được đổi tên!",
            type: "green",
          );
          // print("chi tiets cuộc trò hcuyeenj ${jsonData['data']}");
          return true;
        } else {
          showSnackBar(
              context: context,
              content: "Lỗi đổi tên cuộc trò chuyện: ${jsonData['message']}");
          return false;
        }
      } else {
        showSnackBar(context: context, content: "Lỗi đổi tên cuộc trò chuyện");
        return false;
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      return false;
    }
  }

  Future<bool> changeAvatarGroupChat(
      BuildContext context, String groupId, File groupAvatar) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(
            "https://api.diavan-valuation.asia/chat-management/group-chat/group-avatar?groupId=$groupId"),
      );

      request.headers.addAll({
        'accept': '*/*',
        'Content-Type': 'multipart/form-data',
      });

      request.files.add(
        await http.MultipartFile.fromPath('groupAvatar', groupAvatar.path),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseBody);

      if (response.statusCode == 200 && jsonData['status'] == 1) {
        showSnackBar(
          context: context,
          content: "Cuộc trò chuyện đã được đổi ảnh!",
          type: "green",
        );
        return true;
      } else {
        showSnackBar(
          context: context,
          content: "Lỗi đổi ảnh cuộc trò chuyện: ${jsonData['message']}",
        );
        return false;
      }
    } catch (e) {
      showSnackBar(context: context, content: "Lỗi: ${e.toString()}");
      return false;
    }
  }

  Future<bool> outGroupChat(
    BuildContext context,
    int kickerId,
    String groupId,
    int userId,
  ) async {
    final String apiUrl =
        "https://api.diavan-valuation.asia/chat-management/kick-member?kickerId=$kickerId&groupId=$groupId&userId=$userId";

    try {
      final response = await http.put(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 1) {
          if (kickerId == userId) {
            showSnackBar(
              context: context,
              content: "Đã rời khỏi cuộc trò chuyện",
              type: "green",
            );
          } else {
            showSnackBar(
              context: context,
              content: "Đã xóa liên hệ cuộc trò chuyện",
              type: "green",
            );
          }
          return true; // Successfully removed from the group
        } else {
          showSnackBar(
            context: context,
            content:
                "Lỗi rời cuộc trò chuyện: ${responseData['message']} ${responseData['data']}",
          );
          debugPrint("Error: ${responseData['message']}");
          return false;
        }
      } else {
        showSnackBar(
          context: context,
          content: "Lỗi rời cuộc trò chuyện: ${response.statusCode}",
        );
        debugPrint("Server error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Request failed: $e");
      showSnackBar(
        context: context,
        content: "Lỗi rời cuộc trò chuyện: ${e.toString()}",
      );
      return false;
    }
  }
}
