import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/models/friend_request.dart';
import 'package:sep490/theme/color.dart';

class FriendRequestScreen extends StatefulWidget {
  final int requestUserId;

  const FriendRequestScreen({Key? key, required this.requestUserId})
      : super(key: key);

  @override
  _FriendRequestScreenState createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
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

  void _acceptFriendRequest(int requestId) {
    // Implement the logic to accept the friend request
    debugPrint("Accepted friend request with ID: $requestId");
    // You can call an API here to update the friend request status
  }

  void _cancelFriendRequest(int requestId) {
    // Implement the logic to accept the friend request
    debugPrint("Cancel friend request with ID: $requestId");
    // You can call an API here to update the friend request status
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
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
                  return Center(child: Text("No friend requests found."));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final request = snapshot.data![index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(request.requestUserAvatar ?? ""),
                      ),
                      title: Text(request.requestUserName ?? "Unknown"),
                      subtitle: Text(
                          "Requested to ${request.responseUserName ?? 'Unknown'}"),
                      trailing: ElevatedButton(
                        onPressed: () =>
                            _cancelFriendRequest(request.requestUserId ?? 0),
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
                  return Center(child: Text("No pending responses found."));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final response = snapshot.data![index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(response.responseUserAvatar ?? ""),
                      ),
                      title: Text(response.requestUserName ?? "Unknown"),
                      subtitle: Text(
                          "Requested by ${response.requestUserName ?? 'Unknown'}"),
                      trailing: ElevatedButton(
                        onPressed: () =>
                            _acceptFriendRequest(response.requestUserId ?? 0),
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
