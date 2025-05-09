import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/features/select_contacts_friend/controller/select_contact_controller.dart';
import 'package:sep490/features/select_contacts_friend/screens/user_information_screen.dart';
import 'package:sep490/models/friend_request.dart';
import 'package:sep490/theme/color.dart';

class FriendRequestScreen extends ConsumerStatefulWidget {
  final int requestUserId;

  const FriendRequestScreen({Key? key, required this.requestUserId})
      : super(key: key);

  @override
  _FriendRequestScreenState createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends ConsumerState<FriendRequestScreen> {
  Future<List<FriendRequest>> getFriendRequestByUserId(
      BuildContext context, int requestUserId) async {
    final String apiUrl =
        "https://api.diavan-valuation.asia/user-link-management/request/$requestUserId";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData["status"] == 1) {
          showSnackBar(
              context: context,
              content: "Đã tải lên danh sách lời mời",
              type: "green");

          // ✅ Corrected conversion of JSON data into a list of FriendRequest objects
          return (responseData["data"] as List)
              .map((json) => FriendRequest.fromJson(json))
              .toList();
        } else {
          showSnackBar(
              context: context,
              content: "Lỗi tải dữ liệu ${responseData["message"]}");
          throw Exception(
              "Failed to fetch friend requests: ${responseData["message"]}");
        }
      } else {
        showSnackBar(
            context: context, content: "HTTP Error: ${response.statusCode}");
        throw Exception("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      showSnackBar(context: context, content: "Lỗi tải ${e.toString()}");
      debugPrint("Error fetching friend requests: $e");
      return [];
    }
  }

  Future<List<FriendRequest>> getFriendResponseByUserId(
      BuildContext context, int requestUserId) async {
    final String apiUrl =
        "https://api.diavan-valuation.asia/user-link-management/response/$requestUserId";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData["status"] == 1) {
          showSnackBar(
              context: context,
              content: "Đã tải lên danh sách lời mời",
              type: "green");

          // ✅ Corrected conversion of JSON data into a list of FriendRequest objects
          return (responseData["data"] as List)
              .map((json) => FriendRequest.fromJson(json))
              .toList();
        } else {
          showSnackBar(
              context: context,
              content: "Lỗi tải dữ liệu ${responseData["message"]}");
          throw Exception(
              "Failed to fetch friend requests: ${responseData["message"]}");
        }
      } else {
        showSnackBar(
            context: context, content: "HTTP Error: ${response.statusCode}");
        throw Exception("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      showSnackBar(context: context, content: "Lỗi tải ${e.toString()}");
      debugPrint("Error fetching friend requests: $e");
      return [];
    }
  }

  String formatDateTime(String dateTimeString) {
    DateTime parsedDate = DateTime.parse(dateTimeString);
    return DateFormat("HH:mm dd/MM/yyyy").format(parsedDate);
  }

  void _cancelFriendRequest(int requestId, int responseId) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Xác nhận hủy lời mời"),
          content: Text("Bạn có chắc chắn muốn hủy lời mời kết bạn này không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // No
              child: Text("Hủy bỏ"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Yes
              child: Text("Đồng ý"),
            ),
          ],
        );
      },
    );

    // If the user confirms, proceed with the action
    if (confirmed == true) {
      final controller = ref.read(selectContactControllerProvider);
      final success = await controller.cancelSendFriendRequest(
        context,
        requestId,
        responseId,
      );

      if (success) {
        showSnackBar(
          context: context,
          content: "Đã hủy lời mời kết bạn",
          type: "green",
        );
        setState(() {}); // Refresh the UI
      } else {
        showSnackBar(
          context: context,
          content: "Hủy lời mời kết bạn thất bại",
        );
      }
    }
  }

  void _acceptFriendRequest(int requestId, int responseId) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Xác nhận chấp nhận"),
          content: Text(
              "Bạn có chắc chắn muốn chấp nhận lời mời kết bạn này không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // No
              child: Text("Hủy bỏ"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Yes
              child: Text("Đồng ý"),
            ),
          ],
        );
      },
    );

    // If the user confirms, proceed with the action
    if (confirmed == true) {
      final controller = ref.read(selectContactControllerProvider);
      final success = await controller.acceptedFriendRequest(
        context,
        requestId,
        responseId,
      );

      if (success) {
        showSnackBar(
          context: context,
          content: "Đã chấp nhận lời mời kết bạn",
          type: "green",
        );
        setState(() {}); // Refresh the UI
      } else {
        showSnackBar(
          context: context,
          content: "Chấp nhận lời mời kết bạn thất bại",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize:
                Size.fromHeight(10), // Adjust the height of the TabBar
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 16), // Add margin to bring tabs closer
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color.fromARGB(
                    255, 235, 237, 239), // Background color for the TabBar
              ),
              child: TabBar(
                indicatorWeight: 0,
                dividerHeight: 0,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors
                      .primaryColor, // Background color for the selected tab
                ),
                labelColor:
                    AppColors.bgColor, // Text color for the selected tab
                unselectedLabelColor:
                    AppColors.secondaryColor, // Text color for unselected tabs
                labelPadding: EdgeInsets.zero, // Remove default padding
                tabs: [
                  Tab(
                    child: Stack(
                      children: [
                        Container(
                          width: double
                              .infinity, // Make the tab take full available width
                          alignment: Alignment.center,
                          child: Text(
                            "Lời mời đã gửi",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 0,
                          child: FutureBuilder<List<FriendRequest>>(
                            future: getFriendRequestByUserId(
                                context, widget.requestUserId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox.shrink(); // Hide while loading
                              } else if (snapshot.hasData &&
                                  snapshot.data!.isNotEmpty) {
                                return Container(
                                  width: 28, // Set a fixed width for the circle
                                  height:
                                      28, // Set a fixed height for the circle
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.bgColor,
                                    shape: BoxShape
                                        .circle, // Use BoxShape.circle for a perfect circle
                                    border: Border.all(
                                      color: AppColors
                                          .primaryColor, // Add a border for better visibility
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      snapshot.data!.length.toString(),
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return SizedBox.shrink(); // Hide if no data
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Stack(children: [
                      Container(
                        width: double
                            .infinity, // Make the tab take full available width
                        alignment: Alignment.center,
                        child: Text(
                          "Đang đợi phản hồi",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 0,
                        child: FutureBuilder<List<FriendRequest>>(
                          future: getFriendResponseByUserId(
                              context, widget.requestUserId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox.shrink(); // Hide while loading
                            } else if (snapshot.hasData &&
                                snapshot.data!.isNotEmpty) {
                              return Container(
                                width: 28, // Set a fixed width for the circle
                                height: 28, // Set a fixed height for the circle
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.bgColor,
                                  shape: BoxShape
                                      .circle, // Use BoxShape.circle for a perfect circle
                                  border: Border.all(
                                    color: AppColors
                                        .primaryColor, // Add a border for better visibility
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    snapshot.data!.length.toString(),
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return SizedBox.shrink(); // Hide if no data
                          },
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Requests Sent Tab
            FutureBuilder<List<FriendRequest>>(
              future: getFriendRequestByUserId(context, widget.requestUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text("Tất cả lời mời đã được chấp nhận!"));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final request = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserInformationScreen(user: request.user),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage:
                              NetworkImage(request.requestUserAvatar ?? ""),
                        ),
                        title: Text(
                          request.responseUserName ?? "Không xác định",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                            "Đã gửi vào ${formatDateTime(request.createdAt.toString()) ?? 'Không xác định'}"),
                        trailing: ElevatedButton(
                          onPressed: () => _cancelFriendRequest(
                              widget.requestUserId,
                              request.responseUserId ?? 0),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Hủy gửi lời mời",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Waiting Response Tab
            FutureBuilder<List<FriendRequest>>(
              future: getFriendResponseByUserId(context, widget.requestUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("Không có lời mời kết bạn nào!"));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final response = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserInformationScreen(user: response.user),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage:
                              NetworkImage(response.responseUserAvatar ?? ""),
                        ),
                        title: Text(
                          response.requestUserName ?? "Không xác định",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                            "Đã gửi vào ${formatDateTime(response.createdAt.toString()) ?? 'Không xác định'}"),
                        trailing: ElevatedButton(
                          onPressed: () => _acceptFriendRequest(
                              widget.requestUserId,
                              response.requestUserId ?? 0),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Chấp nhận",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
