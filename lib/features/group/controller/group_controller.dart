import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/group/repository/group_repository.dart';
import 'package:sep490/models/group_model.dart';
import 'package:sep490/models/user_contact.dart';
import 'package:sep490/presentation/pages/auth/controller/auth_controller.dart';

final groupControllerProvider = Provider((ref) {
  final groupRepository = ref.read(groupRepositoryProvider);
  return GroupController(groupRepository: groupRepository);
});
final groupMembersProvider =
    FutureProvider.family<List<GroupMember>, BuildContext>(
        (ref, context) async {
  final accountId = await ref.watch(accountIdProvider.future);

  if (accountId == null) {
    debugPrint("Account ID is null. Returning an empty list.");
    return [];
  }

  final groupRepository = ref.read(groupRepositoryProvider);
  try {
    return await groupRepository.getGroupMembers(context, accountId);
  } catch (e) {
    debugPrint("Error fetching group members: $e");
    return [];
  }
});

class GroupController {
  final GroupRepository groupRepository;

  GroupController({required this.groupRepository});

  Future<List<GroupMember>> getGroupMembers(
      BuildContext context, int userId) async {
    try {
      return await groupRepository.getGroupMembers(context, userId);
    } catch (e) {
      debugPrint("Error fetching group members: $e");
      return [];
    }
  }

  void createGroup(
    BuildContext context,
    String name,
    File? profilePic,
    List<UserContact> selectedContacts,
  ) {
    groupRepository.createGroup(context, name, profilePic, selectedContacts);
  }
}
