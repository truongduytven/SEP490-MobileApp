import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/select_contact_family/repository/select_contact_family_repository.dart';

final getContactsFamilyProvider = FutureProvider((ref) {
  final selectContactFamilyRepository =
      ref.watch(selectContactFamilyRepositoryProvider);
  return selectContactFamilyRepository.getContacts();
});

final selectContactFamilyControllerProvider = Provider((ref) {
  final selectContactFamilyRepository =
      ref.watch(selectContactFamilyRepositoryProvider);
  return SelectContactFamilyController(
    ref: ref,
    selectContactFamilyRepository: selectContactFamilyRepository,
  );
});

class SelectContactFamilyController {
  final ProviderRef ref;
  final SelectContactFamilyRepository selectContactFamilyRepository;

  SelectContactFamilyController({
    required this.ref,
    required this.selectContactFamilyRepository,
  });

  Future<void> selectContact(
      Contact selectedContact, BuildContext context) async {
    await selectContactFamilyRepository.selectContact(selectedContact, context);
  }

  Future<bool> sendFriendRequest(
    BuildContext context,
    int requestUserId,
    int responseUserId,
  ) {
    return selectContactFamilyRepository.sendFriendRequest(
        context, requestUserId, responseUserId);
  }

  Future<bool> cancelSendFriendRequest(
    BuildContext context,
    int requestUserId,
    int responseUserId,
  ) {
    return selectContactFamilyRepository.cancelSendFriendRequest(
        context, requestUserId, responseUserId);
  }

  Future<bool> acceptedFriendRequest(
    BuildContext context,
    int requestUserId,
    int responseUserId,
  ) {
    return selectContactFamilyRepository.acceptedFriendRequest(
        context, requestUserId, responseUserId);
  }

  Future<bool> removeFriend(
    BuildContext context,
    int requestUserId,
    int responseUserId,
  ) {
    return selectContactFamilyRepository.removeFriend(
        context, requestUserId, responseUserId);
  }
}
