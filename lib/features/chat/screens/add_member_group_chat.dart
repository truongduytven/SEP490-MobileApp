import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sep490/models/group_model.dart';
import 'package:sep490/theme/color.dart';

class AddMemberGroupChat extends StatefulWidget {
  final String groupId;

  const AddMemberGroupChat({Key? key, required this.groupId}) : super(key: key);

  @override
  _AddMemberGroupChatState createState() => _AddMemberGroupChatState();
}

class _AddMemberGroupChatState extends State<AddMemberGroupChat> {
  late Future<List<GroupMember>> _groupMembersFuture;
  Set<int> selectedMembers = {}; // Store selected accountId's

  @override
  void initState() {
    super.initState();
    _groupMembersFuture = getGroupMembersToAdd(context, widget.groupId);
  }

  Future<List<GroupMember>> getGroupMembersToAdd(
      BuildContext context, String groupId) async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://api.diavan-valuation.asia/groups/members-to-add/$groupId"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 1) {
          GroupResponse groupResponse = GroupResponse.fromJson(jsonData);
          return groupResponse.data;
        } else {
          throw Exception("API returned an error: ${jsonData['message']}");
        }
      } else {
        throw Exception("Failed to fetch group members.");
      }
    } catch (e) {
      throw Exception("Error fetching group members: $e");
    }
  }

  void _toggleSelection(int accountId) {
    setState(() {
      if (selectedMembers.contains(accountId)) {
        selectedMembers.remove(accountId);
      } else {
        selectedMembers.add(accountId);
      }
    });
  }

  void _addSelectedMembers() async {
    if (selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng chọn ít nhất một thành viên!")),
      );
      return;
    }

    final url = Uri.parse(
        "https://api.diavan-valuation.asia/chat-management/group-chat");

    try {
      var request = http.MultipartRequest("POST", url);

      // Add required fields
      request.fields['GroupId'] = widget.groupId;

      List<Map<String, dynamic>> members = [];
      for (var mem in selectedMembers) {
        members.add({
          "accountId": mem,
          "isCreator": false,
        });
      }
      // Convert selected members into JSON format for the API
      // List<Map<String, dynamic>> members = selectedMembers.map((id) {
      //   return {
      //     "accountId": id,
      //     "isCreator": false // Set `true` for the creator if needed
      //   };
      // }).toList();

      // request.fields['Members'] = jsonEncode(members);

      int index = 0;
      for (int id in selectedMembers) {
        request.fields['Members[$index][accountId]'] = id.toString();
        request.fields['Members[$index][isCreator]'] =
            "false"; // Set to true if needed
        index++;
      }
      print("req mem ${jsonEncode(members)}");

      // Send request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      // Print response in console
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: $responseBody");

      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200 && responseData['status'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Thêm thành viên vào nhóm thành công!")),
        );

        Navigator.pop(context, true);
      } else {
        final responseBody = await response.stream.bytesToString();
        final responseData = jsonDecode(responseBody);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: ${responseData['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi kết nối: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm thành viên"),
        actions: [
          TextButton(
            onPressed: _addSelectedMembers,
            child: Text(
              "Thêm",
              style: TextStyle(color: AppColors.primaryColor, fontSize: 16),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<GroupMember>>(
        future: _groupMembersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "Tất cả các thành viên trong nhóm gia đình đều đã nằm trong nhóm trò chuyện",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }

          final groups = snapshot.data!;
          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, groupIndex) {
              final group = groups[groupIndex];

              return ExpansionTile(
                title: Text(
                  "Nhóm gia đình: ${group.groupName}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                children: group.members.map((member) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => _toggleSelection(member.accountId ?? 0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(member.avatar ?? ""),
                          ),
                          title: Text(
                            member.fullName ?? "",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            member.email ?? "",
                            style: TextStyle(fontSize: 19),
                          ),
                          trailing: Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                checkColor:
                                    MaterialStateProperty.all(Colors.white),
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Colors.pink; // Checked color
                                    }
                                    return Colors.white; // Unchecked color
                                  },
                                ),
                              ),
                            ),
                            child: Checkbox(
                              value: selectedMembers.contains(member.accountId),
                              onChanged: (bool? value) {
                                _toggleSelection(member.accountId ?? 0);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
