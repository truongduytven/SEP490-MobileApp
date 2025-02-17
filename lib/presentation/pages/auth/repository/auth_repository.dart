// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sep490/common/utils/utils.dart';
// import 'package:sep490/models/user_model.dart';
// import 'package:whatsapp/common/repositories/common_firebase_storage_repository.dart';
// import 'package:whatsapp/common/utils/utils.dart';
// import 'package:whatsapp/features/auth/screens/otp_screen.dart';
// import 'package:whatsapp/features/auth/screens/user_information_screen.dart';
// import 'package:whatsapp/models/user_model.dart';
// import 'package:whatsapp/screens/mobile_layout_screen.dart';

// final authRepositoryProvider = Provider(
//   (ref) => AuthRepository(
//       auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance),
// );

// class AuthRepository {
//   final FirebaseAuth auth;
//   final FirebaseFirestore firestore;

//   AuthRepository({
//     required this.auth,
//     required this.firestore,
//   });

//   Future<UserModel?> getCurrentUserData() async {
//     var userData =
//         await firestore.collection("users").doc(auth.currentUser?.uid).get();
//     UserModel? user;

//     if (userData.data() != null) {
//       user = UserModel.fromMap(userData.data()!);
//     }
//     return user;
//   }

//   void singInWithPhone(BuildContext context, String phoneNumber) async {
//     try {
//       await auth.verifyPhoneNumber(
//           phoneNumber: phoneNumber,
//           verificationCompleted: (PhoneAuthCredential credential) async {
//             await auth.signInWithCredential(credential);
//           },
//           verificationFailed: (e) {
//             throw Exception(e.message);
//           },
//           codeSent: ((String verificationId, int? resendToken) async {
//             Navigator.pushNamed(
//               context,
//               OTPScreen.routeName,
//               arguments: verificationId,
//             );
//           }),
//           codeAutoRetrievalTimeout: (String verificationId) {});
//     } on FirebaseAuthException catch (e) {
//       showSnackBar(context: context, content: e.message!);
//     }
//   }

//   void verifyOTP({
//     required BuildContext context,
//     required String verificationId,
//     required String userOTP,
//   }) async {
//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: userOTP,
//       );
//       await auth.signInWithCredential(credential);
//       Navigator.pushNamedAndRemoveUntil(
//         context,
//         UserInformationScreen.routeName,
//         (route) => false,
//       );
//     } on FirebaseAuthException catch (e) {
//       showSnackBar(context: context, content: e.message!);
//     }
//   }

//   void saveUserDataToFirebase({
//     required String name,
//     required File? profilePic,
//     required ProviderRef ref,
//     required BuildContext context,
//   }) async {
//     try {
//       String uid = auth.currentUser!.uid;
//       String photoUrl =
//           "https://cdn-icons-png.flaticon.com/512/3607/3607444.png";
//       if (profilePic != null) {
//         photoUrl = await ref
//             .read(commonFirebaseStorageRepositoryProvider)
//             .storeFileToFirebase(
//               'profilePic/${uid}',
//               profilePic,
//             );
//       }

//       var user = UserModel(
//         name: name,
//         uid: uid,
//         profilePic: photoUrl,
//         isOnline: true,
//         phoneNumber: auth.currentUser!.phoneNumber!,
//         groupId: [],
//       );

//       await firestore.collection("users").doc(uid).set(user.toMap());
//       Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
//           (route) => false);
//     } catch (e) {
//       showSnackBar(context: context, content: e.toString());
//     }
//   }

//   Stream<UserModel> userData(String userId) {
//     return firestore.collection("users").doc(userId).snapshots().map(
//           (event) => UserModel.fromMap(
//             event.data()!,
//           ),
//         );
//   }

//   void setUserState(bool isOnline) async {
//     await firestore.collection('users').doc(auth.currentUser!.uid).update({
//       'isOnline': isOnline,
//     });
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sep490/models/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(baseUrl: 'https://your-api.com/api'),
);

class AuthRepository {
  final String baseUrl;
  AuthRepository({required this.baseUrl});
  Stream<UserModel?> getUserDataStream(int userId) async* {
    while (true) {
      try {
        final response = await http.get(Uri.parse(
            'https://api.diavan-valuation.asia/account-management/userId?userId=$userId'));
        if (response.statusCode == 200) {

          final Map<String, dynamic> responseBody = jsonDecode(response.body);
          if (responseBody['status'] == 1) {
            yield UserModel.fromJson(responseBody['data']);
          } else {
            yield null;
          }
        } else {
          yield null;
        }
      } catch (e) {
        yield null;
      }
      await Future.delayed(const Duration(seconds: 5)); // Poll every 5 seconds
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/me'),
        // headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
    return null;
  }

  Stream<UserModel?> userData(String userId) async* {
    while (true) {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/user/$userId'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          yield UserModel.fromJson(jsonDecode(response.body));
        } else {
          yield null;
        }
      } catch (e) {
        debugPrint('Error fetching user data: $e');
        yield null;
      }

      await Future.delayed(Duration(seconds: 10)); // Poll every 10 seconds
    }
  }

  void setUserState(bool isOnline) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/update-status'),
        body: jsonEncode({'isOnline': isOnline}),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        debugPrint('Failed to update user state');
      }
    } catch (e) {
      debugPrint('Error updating user state: $e');
    }
  }
}
