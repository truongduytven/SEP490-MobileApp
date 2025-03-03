import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/widgets/loader.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/chat/screens/room_chat_detail_screen.dart';
import 'package:sep490/features/group/controller/group_controller.dart';
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
    SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
    final currentUserId = sharedPrefsHelper.getInt("accountId");
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
          // sendCallButton(
          //   isVideoCall: false,
          //   inviteeUsers: users,
          //   onCallFinished: onSendCallInvitationFinished,
          // ),
          // sendCallButton(
          //   isVideoCall: true,
          //   inviteeUsers: users,
          //   onCallFinished: onSendCallInvitationFinished,
          // ),

          SendCallButton(
            ref: ref,
            context: context,
            roomId: uid,
            userId: currentUserId ?? 0,
            isVideoCall: false,
            inviteeUsers: users,
            onCallFinished: onSendCallInvitationFinished,
          ),
          SendCallButton(
            ref: ref,
            context: context,
            roomId: uid,
            userId: currentUserId ?? 0,
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

Future<List<ZegoUIKitUser>> fetchLatestInvitees(
  WidgetRef ref,
  BuildContext context,
  String roomId,
  int userId,
  List<User> inviteeUsers,
) async {
  try {
    final roomChatDetail = await ref.read(roomChatDetailProvider({
      'context': context,
      'roomId': roomId,
      'userId': userId,
    }).future);

    if (roomChatDetail != null && roomChatDetail.users.isNotEmpty) {
      return roomChatDetail.users.map((user) {
        return ZegoUIKitUser(
          id: user.accountId.toString(),
          name: user.fullName,
        );
      }).toList();
    }
  } catch (e) {
    debugPrint("Error fetching room chat details: $e");
  }

  // If fetching fails, fall back to initial invitee list
  return inviteeUsers.map((user) {
    return ZegoUIKitUser(
      id: user.id.toString(),
      name: user.name,
    );
  }).toList();
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

class SendCallButton extends StatefulWidget {
  final WidgetRef ref;
  final BuildContext context;
  final String roomId;
  final int userId;
  final bool isVideoCall;
  final List<User> inviteeUsers;
  final void Function(String code, String message, List<String>) onCallFinished;

  const SendCallButton({
    required this.ref,
    required this.context,
    required this.roomId,
    required this.userId,
    required this.isVideoCall,
    required this.inviteeUsers,
    required this.onCallFinished,
    Key? key,
  }) : super(key: key);

  @override
  _SendCallButtonState createState() => _SendCallButtonState();
}

class _SendCallButtonState extends State<SendCallButton> {
  late Future<List<ZegoUIKitUser>> _inviteesFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future with the initial data
    _inviteesFuture = fetchLatestInvitees(
      widget.ref,
      widget.context,
      widget.roomId,
      widget.userId,
      widget.inviteeUsers,
    );
  }

  // Method to refresh the invitees list
  Future<void> _refreshInvitees() async {
    setState(() {
      _inviteesFuture = fetchLatestInvitees(
        widget.ref,
        widget.context,
        widget.roomId,
        widget.userId,
        widget.inviteeUsers,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ZegoUIKitUser>>(
      future: _inviteesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return IconButton(
            onPressed: () {},
            icon: Icon(
              widget.isVideoCall ? Icons.video_call : Icons.phone,
              color: Colors.grey,
            ),
          ); // Show loading indicator
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return IconButton(
            icon: Icon(
              widget.isVideoCall ? Icons.video_call : Icons.phone,
              color: Colors.grey,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("No users available for calling.")),
              );
            },
          );
        }

        return ZegoSendCallInvitationButton(
          isVideoCall: widget.isVideoCall,
          invitees: snapshot.data!,
          resourceID: 'zego_data',
          iconSize: const Size(40, 40),
          buttonSize: const Size(50, 50),
          onPressed: (code, message, errorInvitees) async {
            // Refresh the invitees list BEFORE starting the call
            await _refreshInvitees();

            // Wait for the FutureBuilder to rebuild with the new data
            final updatedSnapshot = await _inviteesFuture;

            // Call the callback
            widget.onCallFinished(code, message, errorInvitees);

            // Use the updated invitees list for the call
            if (updatedSnapshot.isNotEmpty) {
              // Perform the call with the updated invitees
              // (You may need to pass the updated list to ZegoSendCallInvitationButton)
            }
          },
          icon: ButtonIcon(
            icon: Icon(
              widget.isVideoCall ? Icons.video_call : Icons.phone,
              color: AppColors.primaryColor,
            ),
          ),
        );
      },
    );
  }
}
