import 'package:flutter/material.dart';
import 'package:sep490/models/room_chat.dart';
import 'package:sep490/theme/color.dart';

class RoomChatDetailScreen extends StatelessWidget {
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;
  final List<User> users;

  const RoomChatDetailScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin cuộc trò chuyện"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profilePic),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    isGroupChat ? "Trò chuyện nhóm" : "Trò chuyện riêng tư",
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (isGroupChat) ...[
              Row(
                children: [
                  Icon(
                    Icons.group,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Thành viên nhóm:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(user.name[0]),
                      ),
                      title: Text(user.name),
                      subtitle: Text('ID: ${user.id}'),
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Leave group chat functionality
                },
                child: ListTile(
                  leading: Icon(Icons.output, color: Colors.red),
                  title: Text(
                    'Rời khỏi cuộc trò chuyện',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ] else ...[
              GestureDetector(
                onTap: () {
                  // Remove friend functionality
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 12.0),
                  child: ListTile(
                    leading: Icon(Icons.person_off_outlined, color: Colors.red),
                    title: Text(
                      'Xóa liên hệ bạn bè',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
