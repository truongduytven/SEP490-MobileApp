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
  List<int> selectedContactIndex = [];
  void selectContact(
    int index,
    Contact contact,
  ) {
    if (selectedContactIndex.contains(index)) {
      selectedContactIndex.remove(index);
    } else {
      selectedContactIndex.add(index);
    }
    setState(() {});
    ref
        .read(selectedGroupContacts.state)
        .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
          data: (contactList) => Expanded(
            child: ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return InkWell(
                    onTap: () => selectContact(index, contact),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(
                          contact.displayName,
                          style: TextStyle(fontSize: 18),
                        ),
                        leading: selectedContactIndex.contains(index)
                            ? IconButton(
                                onPressed: () {}, icon: Icon(Icons.done))
                            : null,
                      ),
                    ),
                  );
                }),
          ),
          error: (err, tract) => ErrorScreen(error: err.toString()),
          loading: () => const Loader(),
        );
  }
}
