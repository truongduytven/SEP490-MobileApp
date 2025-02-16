import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/widgets/loader.dart';
import 'package:sep490/presentation/pages/auth/controller/auth_controller.dart';
import 'package:sep490/presentation/pages/chat/controller/chat_controller.dart';
import 'package:sep490/presentation/pages/chat/widgets/bottom_chat_field.dart';
import 'package:sep490/presentation/pages/chat/widgets/chat_list.dart';
import 'package:sep490/theme/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;

  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
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
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.online_prediction,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                                ),
                              const SizedBox(
                                  width:
                                      5), // Adds spacing between icon and text
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  snapshot.data!.isOnline
                                      ? "online"
                                      : "offline",
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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
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
