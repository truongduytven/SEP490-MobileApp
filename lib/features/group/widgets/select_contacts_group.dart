// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/contact.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sep490/common/widgets/error.dart';
// import 'package:sep490/common/widgets/loader.dart';
// import 'package:sep490/features/select_contacts/controller/select_contact_controller.dart';

// final selectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

// class SelectContactsGroup extends ConsumerStatefulWidget {
//   const SelectContactsGroup({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _SelectContactsGroupState();
// }

// class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
//   List<int> selectedContactIndex = [];
//   void selectContact(
//     int index,
//     Contact contact,
//   ) {
//     if (selectedContactIndex.contains(index)) {
//       selectedContactIndex.remove(index);
//     } else {
//       selectedContactIndex.add(index);
//     }
//     setState(() {});
//     ref
//         .read(selectedGroupContacts.state)
//         .update((state) => [...state, contact]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ref.watch(getContactsProvider).when(
//           data: (contactList) => Expanded(
//             child: ListView.builder(
//                 itemCount: contactList.length,
//                 itemBuilder: (context, index) {
//                   final contact = contactList[index];
//                   return InkWell(
//                     onTap: () => selectContact(index, contact),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: ListTile(
//                         title: Text(
//                           contact.displayName,
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         leading: selectedContactIndex.contains(index)
//                             ? IconButton(
//                                 onPressed: () {}, icon: Icon(Icons.done))
//                             : null,
//                       ),
//                     ),
//                   );
//                 }),
//           ),
//           error: (err, tract) => ErrorScreen(error: err.toString()),
//           loading: () => const Loader(),
//         );
//   }
// }
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
    }
    setState(() {}); // Refresh UI
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        height: 90, // Limit row height
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedContacts.length,
                          itemBuilder: (context, index) {
                            final contact = selectedContacts[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.grey[300],
                                    child: contact.photo != null
                                        ? ClipOval(
                                            child: Image.memory(contact.photo!,
                                                fit: BoxFit.cover,
                                                width: 50,
                                                height: 50),
                                          )
                                        : Icon(Icons.person, size: 30),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    contact.displayName,
                                    // contact.displayName.split(' ').first,
                                    style: TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 300, // Set a fixed height
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
