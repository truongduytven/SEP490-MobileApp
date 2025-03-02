// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sep490/models/user_model.dart';
// import 'package:sep490/presentation/pages/auth/repository/auth_repository.dart';

// final authControllerProvider = Provider((ref) {
//   final authRepository = ref.watch(authRepositoryProvider);
//   return AuthController(authRepository: authRepository, ref: ref);
// });

// final userDataAuthProvider = FutureProvider((ref) {
//   final authController = ref.watch(authControllerProvider);
//   return authController.getUserData();
// });

// class AuthController {
//   final AuthRepository authRepository;
//   final ProviderRef ref;
//   AuthController({
//     required this.authRepository,
//     required this.ref,
//   });

//   Future<UserModel?> getUserData() async {
//     UserModel? user = await authRepository.getCurrentUserData();
//     return user;
//   }

//   void singInWithPhone(BuildContext context, String phoneNumber) {
//     authRepository.singInWithPhone(context, phoneNumber);
//   }

//   void verifyOTP(
//     BuildContext context,
//     String verificationId,
//     String userOTP,
//   ) {
//     authRepository.verifyOTP(
//       context: context,
//       verificationId: verificationId,
//       userOTP: userOTP,
//     );
//   }

//   void saveUserDataToFirebase(
//       BuildContext context, String name, File? profilePic) {
//     authRepository.saveUserDataToFirebase(
//       name: name,
//       profilePic: profilePic,
//       ref: ref,
//       context: context,
//     );
//   }

//   Stream<UserModel> userDataById(String userId) {
//     return authRepository.userData(userId);
//   }

//   void setUserState(bool isOnline) {
//     authRepository.setUserState(isOnline);
//   }
// }

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/models/user_model.dart';
import 'package:sep490/presentation/pages/auth/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});
final accountIdProvider = FutureProvider<int?>((ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('accountId');
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getUserData() async {
    return await authRepository.getCurrentUserData();
  }

  Stream<UserModel?> userData(int userId) {
    print("vo controller");
    return authRepository.getUserDataStream(userId);
  }

  Future<void> setUserState(bool isOnline) async {
    final int? currentUserId = await ref.read(accountIdProvider.future);
    if (currentUserId == null) {
      print("Error: User ID not found.");
      return;
    }

    await authRepository.setUserState(currentUserId, isOnline);
  }
}
