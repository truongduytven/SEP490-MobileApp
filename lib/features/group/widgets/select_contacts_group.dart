// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sep490/common/widgets/error.dart';
// import 'package:sep490/common/widgets/loader.dart';
// import 'package:sep490/features/group/controller/group_controller.dart';
// import 'package:sep490/models/user_contact.dart';

// final selectedGroupContacts = StateProvider<List<UserContact>>((ref) => []);

// class SelectContactsGroup extends ConsumerStatefulWidget {
//   const SelectContactsGroup({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _SelectContactsGroupState();
// }

// class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
//   final ScrollController _scrollController = ScrollController();
//   void selectContact(UserContact contact) {
//     final selectedContacts = ref.read(selectedGroupContacts);

//     if (selectedContacts.contains(contact)) {
//       // Remove contact if already selected
//       ref
//           .read(selectedGroupContacts.state)
//           .update((state) => state.where((c) => c != contact).toList());
//     } else {
//       // Add contact only if it's not already selected
//       ref
//           .read(selectedGroupContacts.state)
//           .update((state) => [...state, contact]);

//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (_scrollController.hasClients) {
//           _scrollController.animateTo(
//             _scrollController.position.maxScrollExtent,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//           );
//         }
//       });
//     }
//     setState(() {}); // Refresh UI
//   }

//   void removeContact(UserContact contact) {
//     ref
//         .read(selectedGroupContacts.state)
//         .update((state) => state.where((c) => c != contact).toList());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ref.watch(groupMembersProvider(context)).when(
//           data: (contactList) {
//             print("contactlist ${contactList}");
//             final selectedContacts = ref.watch(selectedGroupContacts);
//             final unselectedContacts = contactList
//                 .where((c) => !selectedContacts.contains(c))
//                 .toList();
//             final sortedContacts = [...selectedContacts, ...unselectedContacts];

//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   if (selectedContacts.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 15,
//                       ),
//                       child: SizedBox(
//                         height: 90, // Limit row height
//                         child: ListView.builder(
//                           controller: _scrollController,
//                           scrollDirection: Axis.horizontal,
//                           itemCount: selectedContacts.length,
//                           itemBuilder: (context, index) {
//                             final contact = selectedContacts[index];
//                             return Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 5),
//                               child: Stack(
//                                 alignment: Alignment.topRight,
//                                 children: [
//                                   Column(
//                                     children: [
//                                       CircleAvatar(
//                                         radius: 25,
//                                         backgroundColor: Colors.grey[300],
//                                         child: contact.avatar != null
//                                             ? null
//                                             //  ClipOval(
//                                             //     child: Image.memory(
//                                             //       contact.avatar!,
//                                             //       fit: BoxFit.cover,
//                                             //       width: 50,
//                                             //       height: 50,
//                                             //     ),
//                                             //   )
//                                             : Icon(Icons.person, size: 30),
//                                       ),
//                                       SizedBox(height: 5),
//                                       Text(
//                                         contact.fullName ?? "Không có tên",
//                                         style: TextStyle(fontSize: 12),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ],
//                                   ),
//                                   Positioned(
//                                     top: 0,
//                                     right: 0,
//                                     child: GestureDetector(
//                                       onTap: () => removeContact(contact),
//                                       child: CircleAvatar(
//                                         radius: 10,
//                                         backgroundColor: Colors.red,
//                                         child: Icon(
//                                           Icons.close,
//                                           size: 14,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   SizedBox(
//                     height: 500, // Set a fixed height
//                     child: ListView.builder(
//                       itemCount: sortedContacts.length,
//                       itemBuilder: (context, index) {
//                         final contact = sortedContacts[index];
//                         final isSelected = selectedContacts.contains(contact);
//                         return
//                             //  InkWell(
//                             //   onTap: () => selectContact(contact),
//                             //   child: Padding(
//                             //     padding: const EdgeInsets.all(8),
//                             //     child: ListTile(
//                             //       leading: CircleAvatar(
//                             //         backgroundColor: Colors.grey[300],
//                             //         child: contact.photo != null
//                             //             ? ClipOval(
//                             //                 child: Image.memory(contact.photo!,
//                             //                     fit: BoxFit.cover,
//                             //                     width: 40,
//                             //                     height: 40),
//                             //               )
//                             //             : Icon(Icons.person, size: 24),
//                             //       ),
//                             //       title: Text(
//                             //         contact.displayName,
//                             //         style: TextStyle(fontSize: 18),
//                             //       ),
//                             //       trailing: isSelected
//                             //           ? Icon(Icons.done, color: Colors.green)
//                             //           : null,
//                             //     ),
//                             //   ),
//                             // );
//                             SizedBox();
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//           error: (err, stack) => ErrorScreen(error: err.toString()),
//           loading: () => const Loader(),
//         );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/widgets/error.dart';
import 'package:sep490/common/widgets/loader.dart';
import 'package:sep490/features/group/controller/group_controller.dart';
import 'package:sep490/models/user_contact.dart';

final selectedGroupContacts = StateProvider<List<UserContact>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  final ScrollController _scrollController = ScrollController();

  void selectContact(UserContact contact) {
    final selectedContacts = ref.read(selectedGroupContacts);
    if (selectedContacts.contains(contact)) {
      // Remove contact if already selected
      ref
          .read(selectedGroupContacts.state)
          .update((state) => state.where((c) => c != contact).toList());
    } else {
      // Add contact
      ref
          .read(selectedGroupContacts.state)
          .update((state) => [...state, contact]);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
    setState(() {});
  }

  void removeContact(UserContact contact) {
    ref
        .read(selectedGroupContacts.state)
        .update((state) => state.where((c) => c != contact).toList());
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(groupMembersProvider(context)).when(
          data: (groupList) {
            final selectedContacts = ref.watch(selectedGroupContacts);

            // Map groupId to members
            Map<int, List<UserContact>> groupedContacts = {};
            for (var group in groupList) {
              groupedContacts[group.groupId] =
                  group.members; // No need to map through fromJson
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Selected contacts display
                  if (selectedContacts.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      child: SizedBox(
                        height: 90,
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedContacts.length,
                          itemBuilder: (context, index) {
                            final contact = selectedContacts[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.grey[300],
                                        backgroundImage: contact.avatar != null
                                            ? NetworkImage(contact.avatar!)
                                            : null,
                                        child: contact.avatar == null
                                            ? Icon(Icons.person, size: 30)
                                            : null,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        contact.fullName ?? "Không có tên",
                                        style: TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () => removeContact(contact),
                                      child: CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.red,
                                        child: Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  // Contact List by Group
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: groupedContacts.length,
                    itemBuilder: (context, index) {
                      int groupId = groupedContacts.keys.elementAt(index);
                      List<UserContact> members = groupedContacts[groupId]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Group Header
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Text(
                              "Group $groupId", // Adjust to show groupName if needed
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Group Members
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: members.length,
                            itemBuilder: (context, index) {
                              final contact = members[index];
                              final isSelected =
                                  selectedContacts.contains(contact);
                              return InkWell(
                                onTap: () => selectContact(contact),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: contact.avatar != null
                                          ? NetworkImage(contact.avatar!)
                                          : null,
                                      child: contact.avatar == null
                                          ? Icon(Icons.person, size: 24)
                                          : null,
                                    ),
                                    title: Text(
                                      contact.fullName ?? "Không có tên",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    trailing: isSelected
                                        ? Icon(Icons.done, color: Colors.green)
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
          error: (err, stack) => ErrorScreen(error: err.toString()),
          loading: () => const Loader(),
        );
  }
}
