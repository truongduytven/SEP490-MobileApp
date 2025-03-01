import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/widgets/loader.dart';
import 'package:sep490/features/chat/screens/room_chat_detail_screen.dart';
import 'package:sep490/models/room_chat.dart';
import 'package:sep490/presentation/pages/auth/controller/auth_controller.dart';
import 'package:sep490/features/chat/controller/chat_controller.dart';
import 'package:sep490/features/chat/widgets/bottom_chat_field.dart';
import 'package:sep490/features/chat/widgets/chat_list.dart';
import 'package:sep490/theme/color.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;
  final List<User> users;

  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountIdAsync = ref.watch(accountIdProvider);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        foregroundColor: AppColors.secondaryColor,
        backgroundColor: AppColors.bgColor,
        title: isGroupChat
            ? Text(name)
            : accountIdAsync.when(
                data: (accountId) {
                  if (accountId == null) return Text(name);

                  return StreamBuilder(
                    stream: ref
                        .read(chatControllerProvider)
                        .getRoomChatStatus(uid, accountId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Loader();
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return Text(name);
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (snapshot.data!.isOnline)
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.online_prediction,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                                ),
                              const SizedBox(width: 5),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  snapshot.data!.isOnline
                                      ? "Đang hoạt động"
                                      : "Không hoạt động",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: snapshot.data!.isOnline
                                        ? Colors.green
                                        : AppColors.secondaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                loading: () => Loader(),
                error: (error, stack) => Text(name),
              ),
        centerTitle: false,
        actions: [
          sendCallButton(
            isVideoCall: false,
            inviteeUsers: users,
            onCallFinished: onSendCallInvitationFinished,
          ),
          sendCallButton(
            isVideoCall: true,
            inviteeUsers: users,
            onCallFinished: onSendCallInvitationFinished,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomChatDetailScreen(
                    roomId: uid,
                    roomName: name,
                    isGroupChat: isGroupChat,
                    profilePic: profilePic,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 240, 242, 245),
        child: Column(
          children: [
            Expanded(
              child: ChatList(
                roomId: uid.toString(),
                isGroupChat: isGroupChat,
              ),
            ),
            BottomChatField(
              roomId: uid.toString(),
              isGroupChat: isGroupChat,
            ),
          ],
        ),
      ),
    );
  }
}

Widget sendCallButton({
  required bool isVideoCall,
  required List<User> inviteeUsers,
  void Function(String code, String message, List<String>)? onCallFinished,
}) {
  // Convert List<User> to List<ZegoUIKitUser>
  List<ZegoUIKitUser> invitees = inviteeUsers.map((user) {
    return ZegoUIKitUser(
      id: user.id.toString(), // Ensure ID is a string
      name: user.name,
    );
  }).toList();

  print("Calling users: ${invitees.map((e) => e.name).join(', ')}");

  return ZegoSendCallInvitationButton(
    isVideoCall: isVideoCall,
    invitees: invitees,
    //[2,3,4]
    resourceID: 'zego_data',
    iconSize: const Size(40, 40),
    buttonSize: const Size(50, 50),
    onPressed: onCallFinished,
    icon: ButtonIcon(
      icon: isVideoCall
          ? Icon(Icons.video_call, color: AppColors.primaryColor)
          : Icon(Icons.phone, color: AppColors.primaryColor),
    ),
  );
}

// ✅ Handles call invitation results
void onSendCallInvitationFinished(
  String code,
  String message,
  List<String> errorInvitees,
) {
  if (errorInvitees.isNotEmpty) {
    var userIDs = errorInvitees.take(5).join(' ');
    var errorMessage = "User doesn't exist or is offline: $userIDs";

    if (code.isNotEmpty) {
      errorMessage += ', code: $code, message:$message';
    }

    debugPrint(errorMessage);
  } else if (code.isNotEmpty) {
    debugPrint('Call failed: code: $code, message:$message');
  }
}
