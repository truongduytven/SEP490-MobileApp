import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/widgets/loader.dart';
import 'package:sep490/models/room_chat.dart';
import 'package:sep490/presentation/pages/auth/controller/auth_controller.dart';
import 'package:sep490/presentation/pages/chat/controller/chat_controller.dart';
import 'package:sep490/presentation/pages/chat/screens/mobile_chat_screen.dart';
import 'package:sep490/theme/color.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountIdAsync = ref.watch(accountIdProvider);

    return accountIdAsync.when(
      data: (accountId) {
        if (accountId == null) {
          return const Center(child: Text("Account ID not found."));
        }
        return Container(
          color: AppColors.bgColor,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  StreamBuilder<List<RoomChat>>(
                    stream: ref
                        .watch(chatControllerProvider)
                        .getRoomChatStream(accountId.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Loader();
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 70,
                            ),
                            Image.asset(
                              'assets/img/no_chat.webp',
                              width: 200,
                              height: 200,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Chưa có cuộc trò chuyện.",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var groupData = snapshot.data![index];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, MobileChatScreen.routeName,
                                      arguments: {
                                        'name': groupData.roomName,
                                        'uid': groupData.roomId,
                                        'isGroupChat': groupData.isGroupChat,
                                        'profilePic': groupData.roomAvatar,
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ListTile(
                                    title: Text(
                                      groupData.roomName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text(
                                        (groupData.lastMessage.isEmpty)
                                            ? "Let's Start The Chat 👋"
                                            : groupData.lastMessage,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    leading: Stack(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              AppColors.borderColor,
                                          backgroundImage: NetworkImage(
                                            groupData.roomAvatar.isEmpty
                                                ? "https://t4.ftcdn.net/jpg/09/56/45/19/360_F_956451938_HPWoO9ZZOpcRXuUGQ3GjEAOvWt8opZaQ.jpg"
                                                : groupData.roomAvatar,
                                          ),
                                          radius: 30,
                                        ),
                                        // Online status indicator
                                        if (!groupData.isGroupChat &&
                                            groupData.isOnline)
                                          Positioned(
                                            bottom: 2,
                                            right: 2,
                                            child: Container(
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
                                          ),
                                      ],
                                    ),
                                    trailing: Text(
                                      groupData.sentTime ?? "",
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Loader(),
      error: (err, stack) => Center(child: Text("Error: $err")),
    );
  }
}
