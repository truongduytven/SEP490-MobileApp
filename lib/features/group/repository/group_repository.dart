import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sep490/common/utils/utils.dart';
import 'package:uuid/uuid.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(),
);

class GroupRepository {
  GroupRepository();

  // Base API URL
  static const String baseUrl = "https://your-api.com";

  Future<void> createGroup(
    BuildContext context,
    String name,
    File? profilePic,
    List<Contact> selectedContacts,
  ) async {
    try {
      // 1️⃣ Convert selected contacts to phone numbers
      List<String> phoneNumbers = selectedContacts
          .where((c) => c.phones.isNotEmpty)
          .map((c) => c.phones[0].number.replaceAll(' ', ''))
          .toList();

      // 2️⃣ Fetch user UIDs from API
      final userResponse = await http.post(
        Uri.parse("$baseUrl/get-users-by-phone"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumbers': phoneNumbers}),
      );

      if (userResponse.statusCode != 200) {
        throw Exception("Failed to fetch users.");
      }

      List<String> uids = List<String>.from(jsonDecode(userResponse.body));

      // 3️⃣ Generate group ID
      var groupId = const Uuid().v1();
      String profileUrl =
          "https://png.pngtree.com/element_our/png_detail/20180904/group-avatar-icon-design-vector-png_75950.jpg";

      // 4️⃣ Upload profile picture if available
      if (profilePic != null) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse("$baseUrl/upload-profile"),
        );
        request.files
            .add(await http.MultipartFile.fromPath('file', profilePic.path));

        var response = await request.send();
        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          profileUrl = jsonDecode(responseData)['imageUrl'];
        } else {
          throw Exception("Failed to upload image.");
        }
      }

      // 5️⃣ Create group via API
      final groupResponse = await http.post(
        Uri.parse("$baseUrl/create-group"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'senderId': "your-user-id", // Replace with user ID from auth
          'name': name,
          'groupId': groupId,
          'lastMessage': '',
          'groupPic': profileUrl,
          'membersUid': ["your-user-id", ...uids], // Replace with user ID
          'timeSent': DateTime.now().toIso8601String(),
        }),
      );

      if (groupResponse.statusCode != 201) {
        throw Exception("Failed to create group.");
      }

      showSnackBar(context: context, content: "Group created successfully!");
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
