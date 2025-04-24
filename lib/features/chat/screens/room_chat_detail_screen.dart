import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/common/widgets/loader.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/chat/screens/add_member_group_chat.dart';
import 'package:sep490/features/chat/screens/confirm_avatar_group_screen.dart';
import 'package:sep490/features/group/controller/group_controller.dart';
import 'package:sep490/features/select_contacts_friend/controller/select_contact_controller.dart';
import 'package:sep490/models/room_chat_detail.dart';
import 'package:sep490/presentation/pages/auth/controller/auth_controller.dart';
import 'package:sep490/presentation/pages/navigation_menu.dart';
import 'package:sep490/theme/color.dart';

class RoomChatDetailScreen extends ConsumerStatefulWidget {
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
  ConsumerState<RoomChatDetailScreen> createState() =>
      _RoomChatDetailScreenState();
}

class _RoomChatDetailScreenState extends ConsumerState<RoomChatDetailScreen> {
  late TextEditingController _roomNameController;
  final ValueNotifier<int?> selectedUserIndex = ValueNotifier<int?>(null);

  void _showRemoveDialog(int userId) {
    final groupController = ref.watch(groupControllerProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận"),
        content:
            const Text("Bạn có chắc chắn muốn xóa thành viên này khỏi nhóm?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () async {
              SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
              final currentUserId = sharedPrefsHelper.getInt("accountId");

              final success = await groupController.outGroupChat(
                context,
                currentUserId ?? 0,
                widget.roomId,
                userId,
              );

              // // Show a snackbar based on the result
              if (success) {
                ref.invalidate(groupControllerProvider);

                if (currentUserId == userId) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavigationMenu(
                        keyIndex: 2,
                      ),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text("Không thể xóa người này khỏi cuộc trò chuyện"),
                  ),
                );
              }
              print("xóa id $userId ra khỏi nhóm");
              // widget.onRemoveUser(userId);
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _roomNameController = TextEditingController(text: widget.roomName);
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  void _showRenameDialog(BuildContext context, String currentName) {
    _roomNameController.text = currentName; // Pre-fill the text field
    final groupController = ref.watch(groupControllerProvider);

    showDialog(
      context: context,
      builder: (context) {
        bool isLoading = false; // Local state for loading

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Đổi tên cuộc trò chuyện"),
              content: Column(
                mainAxisSize:
                    MainAxisSize.min, // Ensure the dialog doesn't expand
                children: [
                  TextField(
                    controller: _roomNameController,
                    decoration: const InputDecoration(
                      hintText: "Nhập tên mới",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (isLoading) // Show loading indicator if isLoading is true
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null // Disable button when loading
                      : () {
                          Navigator.pop(context); // Close the dialog
                        },
                  child: const Text(
                    "Hủy",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null // Disable button when loading
                      : () async {
                          final newName = _roomNameController.text.trim();
                          if (newName.isNotEmpty) {
                            setState(() {
                              isLoading = true; // Start loading
                            });

                            // Call the API or method to update the group chat name
                            final success =
                                await groupController.changeNameGroupChat(
                              context,
                              widget.roomId,
                              newName,
                            );

                            setState(() {
                              isLoading = false; // Stop loading
                            });

                            if (success) {
                              ref.invalidate(groupControllerProvider);
                              Navigator.pop(
                                  context); // Close the dialog on success
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Đổi tên thất bại"),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Tên không được để trống"),
                              ),
                            );
                          }
                        },
                  child: const Text(
                    "Lưu",
                    style: TextStyle(color: AppColors.secondaryColor),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupController = ref.read(groupControllerProvider);
    final accountIdAsync = ref.watch(accountIdProvider);
    final selectContactController = ref.watch(selectContactControllerProvider);
    SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
    final currentUserRoleId = sharedPrefsHelper.getInt("roleId");
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true; // Ensures the screen pops correctly
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
            title: const Text("Thông tin cuộc trò chuyện"),
            centerTitle: true,
            actions: [
              if (widget.isGroupChat)
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert,
                      color: AppColors.secondaryColor),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text(
                        "Đổi tên cuộc trò chuyện",
                      ),
                      onTap: () {
                        Future.delayed(Duration.zero, () {
                          // Use the roomName from roomChatDetail
                          final roomChatDetail = ref
                              .read(groupControllerProvider)
                              .getRoomChatDetail(context, widget.roomId,
                                  accountIdAsync.value!);
                          roomChatDetail.then((detail) {
                            if (detail != null) {
                              _showRenameDialog(context, detail.roomName);
                            }
                          });
                        });
                      },
                    ),
                    if (currentUserRoleId == 3)
                      PopupMenuItem(
                        child: const Text(
                          "Thêm thành viên",
                        ),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddMemberGroupChat(groupId: widget.roomId),
                            ),
                          );
                          if (result == true) {
                            setState(
                                () {}); // Force UI update to show new avatar
                          }
                          print("them thnahf viên");
                        },
                      )
                  ],
                )
            ]),
        body: accountIdAsync.when(
          data: (userId) {
            if (userId == null) {
              return const Center(child: Text("Không tìm thấy ID người dùng"));
            }
            return FutureBuilder<RoomChatDetail?>(
              future: groupController.getRoomChatDetail(
                  context, widget.roomId, userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Loader());
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text("Không thể tải dữ liệu"));
                }

                final roomChatDetail = snapshot.data!;

                SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
                final currentUserId = sharedPrefsHelper.getInt("accountId");
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  NetworkImage(roomChatDetail.roomAvatar),
                            ),
                            if (roomChatDetail.isGroupChat)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.bgColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: AppColors.primaryColor,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      File? pickedImage =
                                          await pickImageFromGallery(context);
                                      if (pickedImage != null) {
                                        final result =
                                            await Navigator.pushNamed(
                                          context,
                                          ConfirmChangeAvatarGroupChatScreen
                                              .routeName,
                                          arguments: {
                                            "file": pickedImage,
                                            "groupId": roomChatDetail.roomId,
                                          },
                                        );

                                        if (result == true) {
                                          setState(
                                              () {}); // Force UI update to show new avatar
                                        }
                                      }
                                      // Handle edit image functionality
                                      print("Edit image clicked");
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              textAlign: TextAlign.center,
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
                                  : roomChatDetail.isFriend
                                      ? "Các bạn là bạn bè từ: ${DateFormat("dd-MM-yyyy").format(DateFormat("dd-MM-yyyy HH:mm").parse(roomChatDetail.createdAt))}"
                                      : "Các bạn là người thân hỗ trợ từ: ${DateFormat("dd-MM-yyyy").format(DateFormat("dd-MM-yyyy HH:mm").parse(roomChatDetail.createdAt))}",
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
                        // Expanded(
                        //   child: ListView.builder(
                        //     itemCount: roomChatDetail.users.length,
                        //     itemBuilder: (context, index) {
                        //       final user = roomChatDetail.users[index];
                        //       return GestureDetector(
                        //         onTap: () {
                        //           setState(() {
                        //             selectedUserIndex =
                        //                 selectedUserIndex == index ? null : index;
                        //           });
                        //         },
                        //         child: ListTile(
                        //           leading: CircleAvatar(
                        //             radius: 25,
                        //             backgroundImage: NetworkImage(user.avatar),
                        //           ),
                        //           title: Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Text(
                        //                 user.fullName,
                        //                 style: TextStyle(
                        //                   fontSize: 20,
                        //                   fontWeight: FontWeight.w500,
                        //                 ),
                        //                 overflow: TextOverflow.ellipsis,
                        //               ),
                        //               user.isCreator
                        //                   ? Text(
                        //                       "Quản trị viên",
                        //                       style: TextStyle(
                        //                         color: AppColors.primaryColor,
                        //                       ),
                        //                     )
                        //                   : Text(""),
                        //             ],
                        //           ),
                        //           subtitle: Row(
                        //             children: [
                        //               Icon(
                        //                 user.gender.toLowerCase() == "female"
                        //                     ? Icons.female
                        //                     : user.gender.toLowerCase() == "male"
                        //                         ? Icons.male
                        //                         : Icons
                        //                             .help_outline, // Default icon for unknown gender
                        //                 color: user.gender.toLowerCase() ==
                        //                         "female"
                        //                     ? Colors.pink
                        //                     : user.gender.toLowerCase() == "male"
                        //                         ? Colors.blue
                        //                         : Colors
                        //                             .grey, // Default color for unknown gender
                        //               ),
                        //               const SizedBox(
                        //                   width:
                        //                       5), // Space between icon and text
                        //               Text(
                        //                 user.gender.toLowerCase() == "female"
                        //                     ? "Nữ"
                        //                     : user.gender.toLowerCase() == "male"
                        //                         ? "Nam"
                        //                         : "Không rõ",
                        //               ),
                        //             ],
                        //           ),
                        //           trailing: selectedUserIndex == index
                        //               ? IconButton(
                        //                   icon: const Icon(Icons.remove_circle,
                        //                       color: Colors.red),
                        //                   onPressed: () =>
                        //                       _showRemoveDialog(user.accountId),
                        //                 )
                        //               : null,
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),

                        Expanded(
                          child: ValueListenableBuilder<int?>(
                            valueListenable: selectedUserIndex,
                            builder: (context, value, child) {
                              return ListView.builder(
                                itemCount: roomChatDetail.users.length,
                                itemBuilder: (context, index) {
                                  final user = roomChatDetail.users[index];
                                  return GestureDetector(
                                    onTap: () {
                                      selectedUserIndex.value =
                                          selectedUserIndex.value == index
                                              ? null
                                              : index;
                                    },
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundImage:
                                            NetworkImage(user.avatar),
                                      ),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              user.fullName,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          user.isCreator
                                              ? Text(
                                                  "Quản trị viên",
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                )
                                              : Text(""),
                                          if (user.accountId == currentUserId)
                                            Text("Bạn"),
                                        ],
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Icon(
                                            user.gender.toLowerCase() ==
                                                    "female"
                                                ? Icons.female
                                                : user.gender.toLowerCase() ==
                                                        "male"
                                                    ? Icons.male
                                                    : Icons
                                                        .help_outline, // Default icon for unknown gender
                                            color: user.gender.toLowerCase() ==
                                                    "female"
                                                ? Colors.pink
                                                : user.gender.toLowerCase() ==
                                                        "male"
                                                    ? Colors.blue
                                                    : Colors
                                                        .grey, // Default color for unknown gender
                                          ),
                                          const SizedBox(
                                              width:
                                                  5), // Space between icon and text
                                          Text(
                                            user.gender.toLowerCase() ==
                                                    "female"
                                                ? "Nữ"
                                                : user.gender.toLowerCase() ==
                                                        "male"
                                                    ? "Nam"
                                                    : "Không rõ",
                                          ),
                                        ],
                                      ),
                                      trailing: selectedUserIndex.value == index
                                          ? IconButton(
                                              icon: const Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.red),
                                              onPressed: () =>
                                                  _showRemoveDialog(
                                                      user.accountId),
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            // Show a confirmation dialog
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Xác nhận"),
                                  content: const Text(
                                      "Bạn có chắc chắn muốn rời khỏi cuộc trò chuyện này không?"),
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
                                      child: const Text("Rời"),
                                    ),
                                  ],
                                );
                              },
                            );

                            // Proceed only if the user confirmed the action
                            if (confirmed == true) {
                              SharedPrefsHelper sharedPrefsHelper =
                                  SharedPrefsHelper();
                              final currentUserId =
                                  sharedPrefsHelper.getInt("accountId");

                              final success =
                                  await groupController.outGroupChat(
                                context,
                                currentUserId ?? 0,
                                widget.roomId,
                                currentUserId ?? 0,
                              );

                              // // Show a snackbar based on the result
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
                                    content: Text(
                                        "Không thể rời khỏi cuộc trò chuyện"),
                                  ),
                                );
                              }
                            }
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
                        if (roomChatDetail.isFriend)
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
      ),
    );
  }
}
