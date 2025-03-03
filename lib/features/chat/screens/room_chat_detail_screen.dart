import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sep490/common/widgets/loader.dart';
import 'package:sep490/features/group/controller/group_controller.dart';
import 'package:sep490/features/select_contacts/controller/select_contact_controller.dart';
import 'package:sep490/features/select_contacts/screens/user_information_screen.dart';
import 'package:sep490/models/room_chat_detail.dart';
import 'package:sep490/presentation/layout/mobile_layout_screen.dart';
import 'package:sep490/presentation/pages/navigation_menu.dart';
import 'package:sep490/theme/color.dart';

class RoomChatDetailScreen extends ConsumerWidget {
  final String roomId;
  final String roomName;
  final bool isGroupChat;
  final String profilePic;

  const RoomChatDetailScreen({
    Key? key,
    required this.roomId,
    required this.roomName,
    required this.isGroupChat,
    this.profilePic = "",
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupController = ref.read(groupControllerProvider);
    final accountIdAsync = ref.watch(accountIdProvider);
    final selectContactController = ref.read(selectContactControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin cuộc trò chuyện"),
        centerTitle: true,
      ),
      body: accountIdAsync.when(
        data: (userId) {
          if (userId == null) {
            return const Center(child: Text("Không tìm thấy ID người dùng"));
          }
          return FutureBuilder<RoomChatDetail?>(
            future: groupController.getRoomChatDetail(context, roomId, userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Loader());
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Center(child: Text("Không thể tải dữ liệu"));
              }

              final roomChatDetail = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            NetworkImage(roomChatDetail.roomAvatar),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            roomChatDetail.roomName,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            roomChatDetail.isGroupChat
                                ? "Trò chuyện nhóm"
                                : "Trò chuyện riêng tư",
                            style: const TextStyle(
                              fontSize: 20,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            roomChatDetail.isGroupChat
                                ? "Cuộc trò chuyện được tạo ngày: ${DateFormat("dd-MM-yyyy").format(DateFormat("dd-MM-yyyy HH:mm").parse(roomChatDetail.createdAt))}"
                                : "Các bạn là bạn bè từ: ${DateFormat("dd-MM-yyyy").format(DateFormat("dd-MM-yyyy HH:mm").parse(roomChatDetail.createdAt))}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (roomChatDetail.isGroupChat) ...[
                      Row(
                        children: const [
                          Icon(Icons.group, size: 28),
                          SizedBox(width: 10),
                          Text(
                            'Thành viên nhóm:',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: roomChatDetail.users.length,
                          itemBuilder: (context, index) {
                            final user = roomChatDetail.users[index];
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(user.avatar),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    user.fullName,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  user.isCreator
                                      ? Text(
                                          "Quản trị viên",
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                          ),
                                        )
                                      : Text("Thành viên"),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Icon(
                                    user.gender.toLowerCase() == "female"
                                        ? Icons.female
                                        : user.gender.toLowerCase() == "male"
                                            ? Icons.male
                                            : Icons
                                                .help_outline, // Default icon for unknown gender
                                    color: user.gender.toLowerCase() == "female"
                                        ? Colors.pink
                                        : user.gender.toLowerCase() == "male"
                                            ? Colors.blue
                                            : Colors
                                                .grey, // Default color for unknown gender
                                  ),
                                  const SizedBox(
                                      width: 5), // Space between icon and text
                                  Text(
                                    user.gender.toLowerCase() == "female"
                                        ? "Nữ"
                                        : user.gender.toLowerCase() == "male"
                                            ? "Nam"
                                            : "Không rõ",
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Leave group chat functionality
                        },
                        child: const ListTile(
                          leading: Icon(Icons.output, color: Colors.red),
                          title: Text(
                            'Rời khỏi cuộc trò chuyện',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      GestureDetector(
                        onTap: () async {
                          // Show a confirmation dialog
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Xác nhận"),
                                content: const Text(
                                    "Bạn có chắc chắn muốn xóa liên hệ bạn bè này không?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context,
                                          false); // Return false if canceled
                                    },
                                    child: const Text("Hủy"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context,
                                          true); // Return true if confirmed
                                    },
                                    child: const Text("Xóa"),
                                  ),
                                ],
                              );
                            },
                          );

                          // Proceed only if the user confirmed the action
                          if (confirmed == true) {
                            // Get the IDs of the two users in the private chat
                            final requestUserId =
                                roomChatDetail.users[0].accountId;
                            final responseUserId =
                                roomChatDetail.users[1].accountId;

                            // Call the removeFriend method
                            final success =
                                await selectContactController.removeFriend(
                              context,
                              requestUserId,
                              responseUserId,
                            );

                            // Show a snackbar based on the result
                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NavigationMenu(
                                    keyIndex: 2,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Xóa bạn bè thất bại"),
                                ),
                              );
                            }
                          }
                        },
                        child: const Card(
                          margin: EdgeInsets.symmetric(vertical: 12.0),
                          child: ListTile(
                            leading: Icon(Icons.person_off_outlined,
                                color: Colors.red),
                            title: Text(
                              'Xóa liên hệ bạn bè',
                              style: TextStyle(
                                fontSize: 20,
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
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("Lỗi: $error")),
      ),
    );
  }
}
