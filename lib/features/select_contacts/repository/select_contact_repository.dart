import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sep490/common/utils/utils.dart';
import 'dart:convert';

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
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> usersData = json.decode(response.body);
        bool isFound = false;
        String selectedPhoneNum =
            selectedContact.phones[0].number.replaceAll(' ', '');

        // for (var user in usersData) {
        //   var userData = UserModel.fromMap(user);
        //   if (selectedPhoneNum == userData.phoneNumber) {
        //     isFound = true;
        //     Navigator.pushNamed(
        //       context,
        //       MobileChatScreen.routeName,
        //       arguments: {
        //         "name": userData.name,
        //         "uid": userData.uid,
        //       },
        //     );
        //     break;
        //   }
        // }

        if (!isFound) {
          showSnackBar(
              context: context,
              content: "This number is not exist on this app!");
        }
      } else {
        showSnackBar(context: context, content: "Failed to fetch user data.");
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
