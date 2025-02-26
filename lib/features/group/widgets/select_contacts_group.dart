import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/widgets/error.dart';
import 'package:sep490/common/widgets/loader.dart';
import 'package:sep490/features/select_contacts/controller/select_contact_controller.dart';

final selectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  final ScrollController _scrollController = ScrollController();
  void selectContact(Contact contact) {
    final selectedContacts = ref.read(selectedGroupContacts);

    if (selectedContacts.contains(contact)) {
      // Remove contact if already selected
      ref
          .read(selectedGroupContacts.state)
          .update((state) => state.where((c) => c != contact).toList());
    } else {
      // Add contact only if it's not already selected
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
    setState(() {}); // Refresh UI
  }

  void removeContact(Contact contact) {
    ref
        .read(selectedGroupContacts.state)
        .update((state) => state.where((c) => c != contact).toList());
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
          data: (contactList) {
            final selectedContacts = ref.watch(selectedGroupContacts);
            final unselectedContacts = contactList
                .where((c) => !selectedContacts.contains(c))
                .toList();
            final sortedContacts = [...selectedContacts, ...unselectedContacts];

            return SingleChildScrollView(
              child: Column(
                children: [
                  if (selectedContacts.isNotEmpty)
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10),
                    //   child: SizedBox(
                    //     height: 90, // Limit row height
                    //     child: ListView.builder(
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount: selectedContacts.length,
                    //       itemBuilder: (context, index) {
                    //         final contact = selectedContacts[index];
                    //         return Padding(
                    //           padding:
                    //               const EdgeInsets.symmetric(horizontal: 5),
                    //           child: Column(
                    //             children: [
                    //               CircleAvatar(
                    //                 radius: 25,
                    //                 backgroundColor: Colors.grey[300],
                    //                 child: contact.photo != null
                    //                     ? ClipOval(
                    //                         child: Image.memory(contact.photo!,
                    //                             fit: BoxFit.cover,
                    //                             width: 50,
                    //                             height: 50),
                    //                       )
                    //                     : Icon(Icons.person, size: 30),
                    //               ),
                    //               SizedBox(height: 5),
                    //               Text(
                    //                 contact.displayName,
                    //                 // contact.displayName.split(' ').first,
                    //                 style: TextStyle(fontSize: 12),
                    //                 overflow: TextOverflow.ellipsis,
                    //               ),
                    //             ],
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      child: SizedBox(
                        height: 90, // Limit row height
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
                                        child: contact.photo != null
                                            ? ClipOval(
                                                child: Image.memory(
                                                  contact.photo!,
                                                  fit: BoxFit.cover,
                                                  width: 50,
                                                  height: 50,
                                                ),
                                              )
                                            : Icon(Icons.person, size: 30),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        contact.displayName,
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
                  SizedBox(
                    height: 500, // Set a fixed height
                    child: ListView.builder(
                      itemCount: sortedContacts.length,
                      itemBuilder: (context, index) {
                        final contact = sortedContacts[index];
                        final isSelected = selectedContacts.contains(contact);

                        return InkWell(
                          onTap: () => selectContact(contact),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                child: contact.photo != null
                                    ? ClipOval(
                                        child: Image.memory(contact.photo!,
                                            fit: BoxFit.cover,
                                            width: 40,
                                            height: 40),
                                      )
                                    : Icon(Icons.person, size: 24),
                              ),
                              title: Text(
                                contact.displayName,
                                style: TextStyle(fontSize: 18),
                              ),
                              trailing: isSelected
                                  ? Icon(Icons.done, color: Colors.green)
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
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
