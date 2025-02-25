import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/features/select_contacts/screens/user_information_screen.dart';
import 'package:sep490/models/user_contact.dart';
import 'dart:convert';

import 'package:sep490/models/user_model.dart';

final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(),
);

class SelectContactRepository {
  final String apiUrl = 'https://yourapi.com/users';

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    print("vo getcontect");
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
        "https://api.diavan-valuation.asia/account-management/phoneNumber?phoneNumber=$selectedPhoneNum";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData["status"] == 1 && responseData["data"] != null) {
          // final userData = responseData["data"];
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
}
