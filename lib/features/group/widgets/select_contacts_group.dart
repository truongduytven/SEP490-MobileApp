import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/widgets/error.dart';
import 'package:sep490/common/widgets/loader.dart';
import 'package:sep490/features/group/controller/group_controller.dart';
import 'package:sep490/models/user_contact.dart';
import 'package:sep490/theme/color.dart';

final selectedGroupContacts = StateProvider<List<UserContact>>((ref) => []);
final selectedGroupIdProvider = StateProvider<int?>((ref) => null);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  final ScrollController _scrollController = ScrollController();

  void selectContact(UserContact contact, int groupId) {
    final selectedContacts = ref.read(selectedGroupContacts);
    final selectedGroupId = ref.read(selectedGroupIdProvider);

    if (selectedGroupId != null && selectedGroupId != groupId) {
      // Show error if trying to select from a different group
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bạn chỉ có thể chọn thành viên từ cùng một nhóm."),
          backgroundColor: AppColors.errorColor,
        ),
      );
      return;
    }

    if (selectedContacts.contains(contact)) {
      // Remove contact if already selected
      ref
          .read(selectedGroupContacts.state)
          .update((state) => state.where((c) => c != contact).toList());

      if (selectedContacts.length == 1) {
        // Reset groupId if no contacts are left
        ref.read(selectedGroupIdProvider.state).state = null;
      }
    } else {
      // Add contact and set groupId if it's the first selection
      ref
          .read(selectedGroupContacts.state)
          .update((state) => [...state, contact]);
      if (selectedGroupId == null) {
        ref.read(selectedGroupIdProvider.state).state = groupId;
      }

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
    ref.read(selectedGroupContacts.state).update((state) {
      final updatedContacts = state.where((c) => c != contact).toList();

      if (updatedContacts.isEmpty) {
        ref.read(selectedGroupIdProvider.state).state = null; // Reset group ID
      }

      return updatedContacts;
    });
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
            return Column(
              children: [
                // Selected contacts display
                if (selectedContacts.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      // vertical: 10,
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
                            padding: const EdgeInsets.symmetric(horizontal: 5),
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

                // Contact List by Group (Scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: groupedContacts.entries.map((entry) {
                        int groupId = entry.key;
                        List<UserContact> members = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Group Header
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Text(
                                "Nhóm ${groupList.firstWhere((g) => g.groupId == groupId).groupName}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // Group Members (Scrollable inside)
                            ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  NeverScrollableScrollPhysics(), // Prevent inner list from scrolling separately
                              itemCount: members.length,
                              itemBuilder: (context, index) {
                                final contact = members[index];
                                final isSelected =
                                    selectedContacts.contains(contact);
                                return InkWell(
                                  onTap: () => selectContact(contact, groupId),
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
                                          ? Icon(Icons.done,
                                              color: Colors.green)
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          },
          error: (err, stack) => ErrorScreen(error: err.toString()),
          loading: () => const Loader(),
        );
  }
}
