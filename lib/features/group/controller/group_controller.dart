import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/group/repository/group_repository.dart';

final groupControllerProvider = Provider((ref) {
  final groupRepository = ref.read(groupRepositoryProvider);
  return GroupController(groupRepository: groupRepository);
});

class GroupController {
  final GroupRepository groupRepository;

  GroupController({required this.groupRepository});

  void createGroup(
    BuildContext context,
    String name,
    File? profilePic,
    List<Contact> selectedContacts,
  ) {
    groupRepository.createGroup(context, name, profilePic, selectedContacts);
  }
}
