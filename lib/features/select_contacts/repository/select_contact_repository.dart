import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/features/select_contacts/screens/user_information_screen.dart';
import 'package:sep490/models/user_contact.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(),
);

class SelectContactRepository {
  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  Future<void> selectContact(
      Contact selectedContact, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accountId = prefs.getInt('accountId');

    if (accountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Không tìm thấy tài khoản! Vui lòng đăng nhập lại."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedContact.phones.isEmpty) {
      showSnackBar(
          context: context, content: "Liên hệ này không có số điện thoại.");
      return;
    }

    String selectedPhoneNum =
        selectedContact.phones[0].number.replaceAll(' ', '').trim();

    // Convert +84 to 0 if needed
    if (selectedPhoneNum.startsWith("+84")) {
      selectedPhoneNum = "0${selectedPhoneNum.substring(3)}";
    }

    print("Processed Phone Number: $selectedPhoneNum");

    final String apiUrl =
        "https://api.diavan-valuation.asia/account-management/phoneNumber/$selectedPhoneNum/$accountId";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData["status"] == 1 && responseData["data"] != null) {
          final userData = responseData["data"];
          print("select $userData");
          // Check if the user is family
          if (userData["isFamily"] == true) {
            showSnackBar(
                context: context,
                content: "Không thể thêm vì các bạn là cùng nhóm gia đình");
            return;
          }

          // Check if the user is the current user
          if (userData["isMe"] == true) {
            showSnackBar(
                context: context,
                content: "Không thể thêm bạn vì liên hệ này là chính bạn!");
            return;
          }
          if (userData["isFriend"] == true) {
            showSnackBar(context: context, content: "Các bạn đã là bạn bè!");
            return;
          }
          final user = UserContact.fromJson(responseData["data"]);
          // Navigator.pushNamed(
          //   context,
          //   MobileChatScreen.routeName,
          //   arguments: {
          //     "name": userData["fullName"],
          //     "uid": userData["accountId"].toString(),
          //     "avatar": userData["avatar"],
          //     "email": userData["email"],
          //   },
          // );
          // builder: (context) => UserProfileScreen(),
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserInformationScreen(user: user),
            ),
          );
        } else {
          showSnackBar(
              context: context,
              content: "Số này chưa được đăng ký trên ứng dụng này!");
        }
      } else {
        showSnackBar(context: context, content: "Failed to fetch user data.");
      }
    } catch (e) {
      print("Error: $e");
      showSnackBar(
          context: context, content: "Error fetching data: ${e.toString()}");
    }
  }

  Future<bool> sendFriendRequest(
    BuildContext context,
    int requestUserId,
    int responseUserId,
  ) async {
    const String apiUrl =
        "https://api.diavan-valuation.asia/user-link-management/add-friend";

    final Map<String, dynamic> payload = {
      "requestUserId": requestUserId,
      "responseUserId": responseUserId,
      "relationshipType": "Friend"
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData["status"] == 1) {
          showSnackBar(
              context: context,
              content: "Gửi lời mời thành công ",
              type: "green");

          return true;
        }
      }
      showSnackBar(context: context, content: "Gửi lời mời thất bại ");
      return false;
    } catch (e) {
      showSnackBar(
          context: context, content: "Gửi lời mời thất bại ${e.toString()}");
      print("Error sending friend request: \$e");
      return false;
    }
  }

  Future<bool> cancelSendFriendRequest(
    BuildContext context,
    int requestUserId,
    int responseUserId,
  ) async {
    const String apiUrl =
        "https://api.diavan-valuation.asia/user-link-management/response-add-friend";

    final Map<String, dynamic> payload = {
      "requestUserId": requestUserId,
      "responseUserId": responseUserId,
      "responseStatus":
          "Cancelled", // Assuming "cancel" is the correct action for cancellation
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData["status"] == 1) {
          showSnackBar(
              context: context,
              content: "Hủy lời mời kết bạn thành công ",
              type: "green");
          return true;
        }
      }
      showSnackBar(
          context: context,
          content:
              "Hủy lời mời kết bạn thất bại ${json.decode(response.body)["data"]} ${json.decode(response.body)["message"]}");
      return false;
    } catch (e) {
      showSnackBar(
          context: context,
          content: "Lỗi khi hủy lời mời kết bạn: ${e.toString()}");
      print("Error canceling friend request: $e");
      return false;
    }
  }

  Future<bool> acceptedFriendRequest(
    BuildContext context,
    int requestUserId,
    int responseUserId,
  ) async {
    const String apiUrl =
        "https://api.diavan-valuation.asia/user-link-management/response-add-friend";

    final Map<String, dynamic> payload = {
      "requestUserId": requestUserId,
      "responseUserId": responseUserId,
      "responseStatus":
          "Accepted", // Assuming "cancel" is the correct action for cancellation
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData["status"] == 1) {
          showSnackBar(
              context: context,
              content: "Chấp nhận lời mời kết bạn thành công ",
              type: "green");
          return true;
        }
      }
      showSnackBar(
          context: context,
          content:
              "Chấp nhận lời mời kết bạn thất bại ${json.decode(response.body)["data"]} ${json.decode(response.body)["message"]}");
      return false;
    } catch (e) {
      showSnackBar(
          context: context,
          content: "Lỗi khi chập nhận lời mời kết bạn: ${e.toString()}");
      print("Error accepting friend request: $e");
      return false;
    }
  }
}
