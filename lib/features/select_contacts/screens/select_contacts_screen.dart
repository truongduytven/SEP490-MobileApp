import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/widgets/error.dart';
import 'package:sep490/common/widgets/loader.dart';
import 'package:sep490/features/select_contacts/controller/select_contact_controller.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const String routeName = '/select-contact';
  const SelectContactsScreen({super.key});

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chọn liên hệ"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.more_vert),
          // ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
          data: (contactList) => ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return InkWell(
                  onTap: () => selectContact(ref, contact, context),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      bottom: 8.0,
                    ),
                    child: ListTile(
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        contact.phones.isNotEmpty
                            ? contact.phones[0].number
                            : "No phone number",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      leading: contact.photo == null
                          ? null
                          : CircleAvatar(
                              backgroundImage: MemoryImage(contact.photo!),
                              radius: 30,
                            ),
                    ),
                  ),
                );
              }),
          error: (err, trace) => ErrorScreen(error: err.toString()),
          loading: () => const Loader()),
    );
  }
}
