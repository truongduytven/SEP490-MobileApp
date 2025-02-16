import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/widgets/loader.dart';
import 'package:sep490/models/user_model.dart';
import 'package:sep490/presentation/pages/auth/controller/auth_controller.dart';
import 'package:sep490/presentation/pages/chat/widgets/bottom_chat_field.dart';
import 'package:sep490/presentation/pages/chat/widgets/chat_list.dart';
import 'package:sep490/theme/color.dart';

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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        foregroundColor: AppColors.secondaryColor,
        backgroundColor: AppColors.bgColor,
        title: isGroupChat
            ? Text(name)
            : StreamBuilder<UserModel?>(
                stream: ref.read(authControllerProvider).userData(1),
                builder: (context, snapshort) {
                  if (snapshort.connectionState == ConnectionState.waiting) {
                    return Loader();
                  }
                  if (!snapshort.hasData || snapshort.data == null) {
                    return Text(
                        name); // Fallback UI when user data is not available
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name),
                      Text(
                        snapshort.data!.isOnline ? "online" : "offline",
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.normal),
                      )
                    ],
                  );
                }),
        centerTitle: false,
        actions: [
          IconButton(
            // onPressed: () => makeCall(
            //   ref,
            //   context,
            // ),
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
            )
          ],
        ),
      ),
    );
  }
}
