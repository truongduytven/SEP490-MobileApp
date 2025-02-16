import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sep490/common/widgets/loader.dart';
import 'package:sep490/models/chat_contact.dart';
import 'package:sep490/models/group.dart';
import 'package:sep490/models/room_chat.dart';
import 'package:sep490/presentation/pages/chat/controller/chat_controller.dart';
import 'package:sep490/theme/color.dart';

// class ContactsList extends ConsumerWidget {
//   const ContactsList({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10.0),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             StreamBuilder<List<Group>>(
//                 stream: ref.watch(chatControllerProvider).chatGroups("1"),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Loader();
//                   }

//                   if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(
//                       child: Text("No groups available."),
//                     );
//                   }
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index) {
//                       var groupData = snapshot.data![index];
//                       var groupDataTest = snapshot.data![index].toMap();
//                       debugPrint("Group Data: $groupDataTest");
//                       return Column(
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               // Navigator.pushNamed(
//                               //     context, MobileChatScreen.routeName,
//                               //     arguments: {
//                               //       'name': groupData.name,
//                               //       'uid': groupData.groupId,
//                               //       'isGroupChat': true,
//                               //       'profilePic': groupData.groupPic,
//                               //     });
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.only(bottom: 8.0),
//                               child: ListTile(
//                                 title: Text(
//                                   groupData.name,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                                 subtitle: Padding(
//                                   padding: const EdgeInsets.only(top: 6.0),
//                                   child: Text(
//                                     groupData.lastMessage,
//                                     style: const TextStyle(fontSize: 15),
//                                   ),
//                                 ),
//                                 leading: CircleAvatar(
//                                   backgroundImage: NetworkImage(
//                                     groupData.groupPic,
//                                   ),
//                                   radius: 30,
//                                 ),
//                                 trailing: Text(
//                                   DateFormat.Hm().format(groupData.timeSent),
//                                   style: const TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Divider(
//                               color: AppColors.primaryColor, indent: 85),
//                         ],
//                       );
//                     },
//                   );
//                 }),
//             StreamBuilder<List<ChatContact>>(
//                 stream: ref.watch(chatControllerProvider).chatContacts("1"),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Loader();
//                   }
//                   if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(
//                       child: Text("No chats available."),
//                     );
//                   }
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index) {
//                       var chatContactData = snapshot.data![index];
//                       return Column(
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               // Navigator.pushNamed(
//                               // context, MobileChatScreen.routeName,
//                               // arguments: {
//                               //   'name': chatContactData.name,
//                               //   'uid': chatContactData.contactId,
//                               //   'isGroupChat': false,
//                               //   'profilePic': chatContactData.profilePic,
//                               // });
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.only(bottom: 8.0),
//                               child: ListTile(
//                                 title: Text(
//                                   chatContactData.name,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                                 subtitle: Padding(
//                                   padding: const EdgeInsets.only(top: 6.0),
//                                   child: Text(
//                                     chatContactData.lastMessage,
//                                     style: const TextStyle(fontSize: 15),
//                                   ),
//                                 ),
//                                 leading: CircleAvatar(
//                                   backgroundImage: NetworkImage(
//                                     chatContactData.profilePic,
//                                   ),
//                                   radius: 30,
//                                 ),
//                                 trailing: Text(
//                                   DateFormat.Hm()
//                                       .format(chatContactData.timeSent),
//                                   style: const TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Divider(
//                               color: AppColors.primaryColor, indent: 85),
//                         ],
//                       );
//                     },
//                   );
//                 }),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sep490/common/widgets/loader.dart';
import 'package:sep490/models/chat_contact.dart';
import 'package:sep490/models/group.dart';
import 'package:sep490/presentation/pages/chat/controller/chat_controller.dart';
import 'package:sep490/theme/color.dart';

final accountIdProvider = FutureProvider<int?>((ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('accountId');
});

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
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<List<RoomChat>>(
                  stream: ref
                      .watch(chatControllerProvider)
                      .getRoomChatStream(accountId.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No groups available."));
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
                                // Navigator.pushNamed(
//                               //     context, MobileChatScreen.routeName,
//                               //     arguments: {
//                               //       'name': groupData.name,
//                               //       'uid': groupData.groupId,
//                               //       'isGroupChat': true,
//                               //       'profilePic': groupData.groupPic,
//                               //     });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ListTile(
                                  title: Text(
                                    groupData.roomName,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      groupData.lastMessage,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(groupData.roomAvatar),
                                    radius: 30,
                                  ),
                                  trailing: Text(
                                    groupData.sentTime ?? "Nodataa",
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                                color: AppColors.primaryColor, indent: 85),
                          ],
                        );
                      },
                    );
                  },
                ),
                // StreamBuilder<List<ChatContact>>(
                //   stream: ref
                //       .watch(chatControllerProvider)
                //       .chatContacts(accountId.toString()),
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Loader();
                //     }
                //     if (!snapshot.hasData || snapshot.data!.isEmpty) {
                //       return const Center(child: Text("No chats available."));
                //     }
                //     return ListView.builder(
                //       shrinkWrap: true,
                //       itemCount: snapshot.data!.length,
                //       itemBuilder: (context, index) {
                //         var chatContactData = snapshot.data![index];
                //         return Column(
                //           children: [
                //             InkWell(
                //               onTap: () {},
                //               child: Padding(
                //                 padding: const EdgeInsets.only(bottom: 8.0),
                //                 child: ListTile(
                //                   title: Text(
                //                     chatContactData.name,
                //                     style: const TextStyle(fontSize: 18),
                //                   ),
                //                   subtitle: Padding(
                //                     padding: const EdgeInsets.only(top: 6.0),
                //                     child: Text(
                //                       chatContactData.lastMessage,
                //                       style: const TextStyle(fontSize: 15),
                //                     ),
                //                   ),
                //                   leading: CircleAvatar(
                //                     backgroundImage: NetworkImage(
                //                         chatContactData.profilePic),
                //                     radius: 30,
                //                   ),
                //                   trailing: Text(
                //                     DateFormat.Hm()
                //                         .format(chatContactData.timeSent),
                //                     style: const TextStyle(
                //                         color: Colors.grey, fontSize: 13),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //             const Divider(
                //                 color: AppColors.primaryColor, indent: 85),
                //           ],
                //         );
                //       },
                //     );
                //   },
                // ),
              ],
            ),
          ),
        );
      },
      loading: () => const Loader(),
      error: (err, stack) => Center(child: Text("Error: $err")),
    );
  }
}
