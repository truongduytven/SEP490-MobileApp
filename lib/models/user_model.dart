// // class UserModel {
// //   final String name;
// //   final String uid;
// //   final String profilePic;
// //   final bool isOnline;
// //   final String phoneNumber;
// //   final List<String> groupId;

// //   UserModel({
// //     required this.name,
// //     required this.uid,
// //     required this.profilePic,
// //     required this.isOnline,
// //     required this.phoneNumber,
// //     required this.groupId,
// //   });

// //   Map<String, dynamic> toMap() {
// //     return <String, dynamic>{
// //       'name': name,
// //       'uid': uid,
// //       'profilePic': profilePic,
// //       'isOnline': isOnline,
// //       'phoneNumber': phoneNumber,
// //       'groupId': groupId,
// //     };
// //   }

// //   factory UserModel.fromMap(Map<String, dynamic> map) {
// //     return UserModel(
// //       name: map['name'] as String,
// //       uid: map['uid'] as String,
// //       profilePic: map['profilePic'] as String,
// //       isOnline: map['isOnline'] as bool,
// //       phoneNumber: map['phoneNumber'] as String,
// //       groupId: List<String>.from(
// //         (map['groupId'] as List<String>),
// //       ),
// //     );
// //   }
// // }
// class UserModel {
//   final String name;
//   final String uid;
//   final String profilePic;
//   final bool isOnline;
//   final String phoneNumber;
//   final List<String> groupId;

//   UserModel({
//     required this.name,
//     required this.uid,
//     required this.profilePic,
//     required this.isOnline,
//     required this.phoneNumber,
//     required this.groupId,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'name': name,
//       'uid': uid,
//       'profilePic': profilePic,
//       'isOnline': isOnline,
//       'phoneNumber': phoneNumber,
//       'groupId': groupId,
//     };
//   }

//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       name: map['name'] as String,
//       uid: map['uid'] as String,
//       profilePic: map['profilePic'] as String,
//       isOnline: map['isOnline'] as bool,
//       phoneNumber: map['phoneNumber'] as String,
//       groupId: (map['groupId'] as List<dynamic>)
//           .map((group) => group as String)
//           .toList(), // Corrected the type conversion for groupId
//     );
//   }
// }
class UserModel {
  final int accountId;
  final int roleId;
  final String email;
  final String fullName;
  final String avatar;
  final String gender;
  final String phoneNumber;
  final String dateOfBirth;
  final String status;
  final bool isOnline;

  UserModel({
    required this.accountId,
    required this.roleId,
    required this.email,
    required this.fullName,
    required this.avatar,
    required this.gender,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.status,
    required this.isOnline,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      accountId: json['accountId'],
      roleId: json['roleId'],
      email: json['email'],
      fullName: json['fullName'],
      avatar: json['avatar'],
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth: json['dateOfBirth'],
      status: json['status'],
      isOnline: json['isOnline'],
    );
  }
}
