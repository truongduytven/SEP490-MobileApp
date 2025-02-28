import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sep490/features/select_contacts/controller/select_contact_controller.dart';
import 'package:sep490/models/user_contact.dart';
import 'package:sep490/presentation/layout/mobile_layout_screen.dart';
import 'package:sep490/presentation/pages/navigation_menu.dart';
import 'package:sep490/theme/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

// FutureProvider to get accountId from SharedPreferences
final accountIdProvider = FutureProvider<int?>((ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('accountId');
});

// StateProvider to track friend request status
final friendRequestSentProvider = StateProvider<bool>((ref) => false);
final cancleFriendRequestSentProvider = StateProvider<bool>((ref) => false);

class UserInformationScreen extends ConsumerStatefulWidget {
  final UserContact user;

  const UserInformationScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserInformationScreenState createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  @override
  void initState() {
    super.initState();
    // Reset friend request state when mounting the screen
    Future.microtask(() {
      ref.read(friendRequestSentProvider.notifier).state = false;
    });
    Future.microtask(() {
      ref.read(cancleFriendRequestSentProvider.notifier).state = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectContactController = ref.read(selectContactControllerProvider);
    final accountIdAsync = ref.watch(accountIdProvider);
    final isRequestSent = ref.watch(friendRequestSentProvider);
    final isCancelRequest = ref.watch(cancleFriendRequestSentProvider);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          'Thông tin người dùng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                // Top Background with Avatar
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage('assets/img/happy_4.jpg'),
                          fit: BoxFit.cover,
                          opacity: 1,
                        ),
                      ),
                    ),
                    // Profile Image
                    Positioned(
                      bottom: -50,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 52,
                          backgroundImage:
                              NetworkImage(widget.user.avatar ?? ""),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Name & Status
                Text(
                  widget.user.fullName ?? "Không có tên",
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Text(
                  isRequestSent
                      ? "Đang đợi tài khoản đồng ý kết bạn"
                      : isCancelRequest
                          ? ""
                          : widget.user.requestUserId != null
                              ? (widget.user.accountId ==
                                      widget.user.requestUserId
                                  ? "Tài khoản này đã gửi lời mời kết bạn tới bạn"
                                  : "Đang đợi tài khoản đồng ý kết bạn")
                              : "",
                  style: TextStyle(color: AppColors.grayColor5, fontSize: 16),
                ),
                const SizedBox(height: 10),

                // Add Friend Button
                accountIdAsync.when(
                  data: (currentUserId) {
                    return ElevatedButton.icon(
                      onPressed: () async {
                        if (isRequestSent) {
                          bool success = await selectContactController
                              .cancelSendFriendRequest(
                            context,
                            currentUserId ?? 0,
                            widget.user.accountId ?? 0,
                          );

                          if (success) {
                            print("Cancel Friend request sent successfully!");
                            ref.read(friendRequestSentProvider.notifier).state =
                                false;
                            ref
                                .read(cancleFriendRequestSentProvider.notifier)
                                .state = true;
                          } else {
                            print("Failed to cancel friend request.");
                          }
                          // Cancel friend request logic (if needed)
                          print(
                              "Canceled friend request to ${widget.user.fullName}");
                        } else if (isCancelRequest) {
                          bool success =
                              await selectContactController.sendFriendRequest(
                            context,
                            currentUserId ?? 0,
                            widget.user.accountId ?? 0,
                          );

                          if (success) {
                            print("Friend request sent successfully!");
                            ref.read(friendRequestSentProvider.notifier).state =
                                true;
                          } else {
                            print("Failed to send friend request.");
                          }
                        } else if (widget.user.requestUserId != null) {
                          if (widget.user.accountId ==
                              widget.user.requestUserId) {
                            bool success = await selectContactController
                                .acceptedFriendRequest(
                              context,
                              currentUserId ?? 0,
                              widget.user.accountId ?? 0,
                            );
                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NavigationMenu(
                                          keyIndex: 2,
                                        )),
                              );
                              print("Cancel Friend request sent successfully!");
                            } else {
                              print("Failed to cancel friend request.");
                            }
                            // Accept friend request
                            print(
                                "Accepted friend request from ${widget.user.fullName}");
                          } else {
                            bool success = await selectContactController
                                .cancelSendFriendRequest(
                              context,
                              currentUserId ?? 0,
                              widget.user.accountId ?? 0,
                            );

                            if (success) {
                              print("Cancel Friend request sent successfully!");
                              ref
                                  .read(
                                      cancleFriendRequestSentProvider.notifier)
                                  .state = true;
                            } else {
                              print("Failed to cancel friend request.");
                            }
                            print(
                                "Canceled friend request to ${widget.user.fullName}");
                          }
                        } else {
                          bool success =
                              await selectContactController.sendFriendRequest(
                            context,
                            currentUserId ?? 0,
                            widget.user.accountId ?? 0,
                          );

                          if (success) {
                            print("Friend request sent successfully!");
                            ref.read(friendRequestSentProvider.notifier).state =
                                true;
                          } else {
                            print("Failed to send friend request.");
                          }
                        }
                      },
                      icon: Icon(
                        isRequestSent
                            ? Icons.hourglass_top
                            : isCancelRequest
                                ? Icons.person_add
                                : widget.user.requestUserId != null
                                    ? (widget.user.accountId ==
                                            widget.user.requestUserId
                                        ? Icons.check
                                        : Icons.hourglass_top)
                                    : Icons.person_add,
                        size: 26,
                        color: Colors.white,
                      ),
                      label: Text(
                        isRequestSent
                            ? "Hủy gửi lời mời"
                            : isCancelRequest
                                ? "Thêm bạn"
                                : widget.user.requestUserId != null
                                    ? widget.user.accountId ==
                                            widget.user.requestUserId
                                        ? "Chấp nhận"
                                        : "Hủy gửi lời mời"
                                    : "Thêm bạn",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text(
                    "Lỗi tải dữ liệu tài khoản",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),

                // User Info
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInfoRow("Số điện thoại",
                          widget.user.phoneNumber ?? "Không có"),
                      buildInfoRow(
                        "Giới tính",
                        widget.user.gender?.toLowerCase() == "female"
                            ? "Nữ"
                            : widget.user.gender?.toLowerCase() == "male"
                                ? "Nam"
                                : "Không rõ",
                      ),
                      buildInfoRow(
                          "Ngày sinh", formatDate(widget.user.dateOfBirth)),
                      buildInfoRow("Email", widget.user.email ?? "Không có"),
                      buildInfoRow("Thành viên từ ngày",
                          formatDate(widget.user.createdDate)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String formatDate(DateTime? dob) {
  if (dob == null) return "Chưa có thông tin";
  return DateFormat('dd/MM/yyyy').format(dob);
}

Widget buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 22,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        const Divider(thickness: 1),
      ],
    ),
  );
}
// class UserInformationScreen extends ConsumerWidget {
//   final UserContact user;

//   const UserInformationScreen({Key? key, required this.user}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectContactController = ref.read(selectContactControllerProvider);
//     final accountIdAsync = ref.watch(accountIdProvider);
//     final isRequestSent = ref.watch(friendRequestSentProvider);

//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         title: const Text(
//           'Thông tin người dùng',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Top Background with Avatar
//             Stack(
//               alignment: Alignment.center,
//               clipBehavior: Clip.none,
//               children: [
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 10),
//                   height: 200,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     image: DecorationImage(
//                       image: AssetImage('assets/img/happy_4.jpg'),
//                       fit: BoxFit.cover,
//                       opacity: 1,
//                     ),
//                   ),
//                 ),
//                 // Profile Image
//                 Positioned(
//                   bottom: -50,
//                   child: CircleAvatar(
//                     radius: 55,
//                     backgroundColor: Colors.white,
//                     child: CircleAvatar(
//                       radius: 52,
//                       backgroundImage: NetworkImage(user.avatar ?? ""),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 60),

//             // Name & Status
//             Text(
//               user.fullName ?? "Không có tên",
//               style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               isRequestSent
//                   ? "Đang đợi tài khoản đồng ý kết bạn"
//                   : user.requestUserId != null
//                       ? (user.accountId == user.requestUserId
//                           ? "Tài khoản này đã gửi lời mời kết bạn tới bạn"
//                           : "Đang đợi tài khoản đồng ý kết bạn")
//                       : "",
//               style: TextStyle(color: AppColors.grayColor5, fontSize: 16),
//             ),
//             const SizedBox(height: 10),

//             // Add Friend Button
//             accountIdAsync.when(
//               data: (currentUserId) {
//                 return ElevatedButton.icon(
//                   onPressed: () async {
//                     if (isRequestSent) {
//                       // Cancel friend request logic (if needed)
//                       print("Canceled friend request to ${user.fullName}");
//                       ref.read(friendRequestSentProvider.notifier).state =
//                           false;
//                     } else if (user.requestUserId != null) {
//                       if (user.accountId == user.requestUserId) {
//                         // Accept friend request
//                         print("Accepted friend request from ${user.fullName}");
//                       } else {
//                         print("Canceled friend request to ${user.fullName}");
//                         ref.read(friendRequestSentProvider.notifier).state =
//                             false;
//                       }
//                     } else {
//                       bool success =
//                           await selectContactController.sendFriendRequest(
//                         context,
//                         currentUserId ?? 0,
//                         user.accountId ?? 0,
//                       );

//                       if (success) {
//                         print("Friend request sent successfully!");
//                         ref.read(friendRequestSentProvider.notifier).state =
//                             true;
//                       } else {
//                         print("Failed to send friend request.");
//                       }
//                     }

//                     // if (currentUserId != null &&
//                     //     user.accountId != null) {
//                     //   if (user.accountId == user.requestUserId) {
//                     //     // Action: Accept friend re quest
//                     //     print("Accepted friend request from ${user.fullName}");
//                     //   } else {
//                     //     bool success =
//                     //         await selectContactController.sendFriendRequest(
//                     //       context,
//                     //       currentUserId,
//                     //       user.accountId ?? 0,
//                     //     );

//                     //     if (success) {
//                     //       print("Friend request sent successfully!");
//                     //       ref.read(friendRequestSentProvider.notifier).state =
//                     //           true;
//                     //     } else {
//                     //       print("Failed to send friend request.");
//                     //     }
//                     // }
//                     // }
//                   },
//                   icon: Icon(
//                     isRequestSent
//                         ? Icons.hourglass_top
//                         : user.requestUserId != null
//                             ? (user.accountId == user.requestUserId
//                                 ? Icons.check
//                                 : Icons.hourglass_top)
//                             : Icons.person_add,
//                     size: 26,
//                     color: Colors.white,
//                   ),
//                   label: Text(
//                     isRequestSent
//                         ? "Hủy gửi lời mời"
//                         : user.requestUserId != null
//                             ? user.accountId == user.requestUserId
//                                 ? "Chấp nhận"
//                                 : "Hủy gửi lời mời"
//                             : "Thêm bạn",
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryColor,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 );
//               },
//               loading: () => const CircularProgressIndicator(),
//               error: (err, stack) => Text(
//                 "Lỗi tải dữ liệu tài khoản",
//                 style: TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             ),

//             // User Info
//             Container(
//               width: double.infinity,
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   buildInfoRow("Số điện thoại", user.phoneNumber ?? "Không có"),
//                   buildInfoRow(
//                     "Giới tính",
//                     user.gender?.toLowerCase() == "female"
//                         ? "Nữ"
//                         : user.gender?.toLowerCase() == "male"
//                             ? "Nam"
//                             : "Không rõ",
//                   ),
//                   buildInfoRow("Ngày sinh", formatDate(user.dateOfBirth)),
//                   buildInfoRow("Email", user.email ?? "Không có"),
//                   buildInfoRow(
//                       "Thành viên từ ngày", formatDate(user.createdDate)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String formatDate(DateTime? dob) {
//     if (dob == null) return "Chưa có thông tin";
//     return DateFormat('dd/MM/yyyy').format(dob);
//   }

//   Widget buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//                 fontSize: 22,
//                 color: AppColors.primaryColor,
//                 fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             value,
//             style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
//           ),
//           const Divider(thickness: 1),
//         ],
//       ),
//     );
//   }
// }
