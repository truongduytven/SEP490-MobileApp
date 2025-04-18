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

  Future<bool> sendFamilyRequest(
    BuildContext context,
    int requestUserId,
    int responseUserId,
  ) {
    return selectContactFamilyRepository.sendFamilyRequest(
        context, requestUserId, responseUserId);
  }

  Future<bool> cancelSendFamilyRequest(
    BuildContext context,
    int requestUserId,
    int responseUserId,
  ) {
    return selectContactFamilyRepository.cancelSendFamilyRequest(
        context, requestUserId, responseUserId);
  }

  Future<bool> acceptedFamilyRequest(
    BuildContext context,
    int requestUserId,
    int responseUserId,
  ) {
    return selectContactFamilyRepository.acceptedFamilyRequest(
        context, requestUserId, responseUserId);
  }
}
