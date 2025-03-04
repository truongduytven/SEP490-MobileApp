import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/group/repository/group_repository.dart';
import 'package:sep490/models/group_model.dart';
import 'package:sep490/models/room_chat_detail.dart';
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
final roomChatDetailProvider =
    FutureProvider.family<RoomChatDetail?, Map<String, dynamic>>(
        (ref, params) async {
  final groupRepository = ref.read(groupRepositoryProvider);
  final BuildContext context = params['context'];
  final String roomId = params['roomId'];
  final int userId = params['userId'];

  try {
    return await groupRepository.getRoomChatDetail(context, roomId, userId);
  } catch (e) {
    debugPrint("Error fetching room chat detail: $e");
    return null;
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

  Future<bool> createGroup(
    BuildContext context,
    String name,
    File? profilePic,
    List<UserContact> selectedContacts,
  ) {
    return groupRepository.createGroup(
        context, name, profilePic, selectedContacts);
  }

  Future<RoomChatDetail?> getRoomChatDetail(
    BuildContext context,
    String roomId,
    int userId,
  ) {
    return groupRepository.getRoomChatDetail(context, roomId, userId);
  }

  Future<bool> changeNameGroupChat(
    BuildContext context,
    String groupId,
    String groupName,
  ) {
    return groupRepository.changeNameGroupChat(
      context,
      groupId,
      groupName,
    );
  }
  Future<bool> changeAvatarGroupChat(
    BuildContext context,
    String groupId,
    File groupAvatar,
  ) {
    return groupRepository.changeAvatarGroupChat(
      context,
      groupId,
      groupAvatar,
    );
  }
  Future<bool> outGroupChat(
    BuildContext context,
    int kickerId,
    String groupId,
    int userId,
  ) {
    return groupRepository.outGroupChat(
      context,
      kickerId,
      groupId,
      userId,
    );
  }
}
