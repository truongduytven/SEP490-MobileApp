import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/select_contacts_friend/repository/select_contact_repository.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return selectContactRepository.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return SelectContactController(
    ref: ref,
    selectContactRepository: selectContactRepository,
  );
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  SelectContactController({
    required this.ref,
    required this.selectContactRepository,
  });

  Future<void> selectContact(
      Contact selectedContact, BuildContext context) async {
    await selectContactRepository.selectContact(selectedContact, context);
  }

  Future<bool> sendFriendRequest(
    BuildContext context,
    int requestUserId,
    int responseUserId,
  ) {
    return selectContactRepository.sendFriendRequest(
        context, requestUserId, responseUserId);
  }

  Future<bool> cancelSendFriendRequest(
    BuildContext context,
    int requestUserId,
    int responseUserId,
  ) {
    return selectContactRepository.cancelSendFriendRequest(
        context, requestUserId, responseUserId);
  }

  Future<bool> acceptedFriendRequest(
    BuildContext context,
    int requestUserId,
    int responseUserId,
  ) {
    return selectContactRepository.acceptedFriendRequest(
        context, requestUserId, responseUserId);
  }
  Future<bool> removeFriend(
    BuildContext context,
    int requestUserId,
    int responseUserId,
  ) {
    return selectContactRepository.removeFriend(
        context, requestUserId, responseUserId);
  }
}
