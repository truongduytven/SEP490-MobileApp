import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/group_family/tabs/group_tab.dart';
import 'package:sep490/features/group_family/widgets/pending_request_user_card.dart';
import 'package:sep490/features/group_family/widgets/sent_request_user_card.dart';
import 'package:sep490/features/group_family/widgets/user_out_of_group_card.dart';
import 'package:sep490/theme/color.dart';

class GroupFamily extends StatefulWidget {
  const GroupFamily({super.key});

  @override
  State<GroupFamily> createState() => _GroupFamilyState();
}

class _GroupFamilyState extends State<GroupFamily>
    with SingleTickerProviderStateMixin {
  final SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late final int currentUserAccountID;
  late final int currentRoleID;

  Map<String, dynamic>? groupData;
  bool isLoading = true;
  String errorMessage = '';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    currentUserAccountID = sharedPrefsHelper.getInt("accountId") ?? 0;
    currentRoleID = sharedPrefsHelper.getInt("roleId") ?? 0;
    _tabController = TabController(length: 4, vsync: this);
    fetchGroupData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchGroupData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final url = currentRoleID == 2
          ? 'https://api.diavan-valuation.asia/groups/relationship-information/elderly/$currentUserAccountID'
          : 'https://api.diavan-valuation.asia/groups/relationship-information/family-member/$currentUserAccountID';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          setState(() {
            groupData = data['data'];
            isLoading = false;
          });
        } else {
          CherryToast.error(
            toastDuration: const Duration(seconds: 3),
            title: Text(
              data['message'] ?? "Không thể tải dữ liệu",
            ),
          ).show(context);
          throw Exception(data['message'] ?? 'Failed to load data');
        }
      } else {
        CherryToast.error(
          toastDuration: const Duration(seconds: 3),
          title: Text(
            'Không thể tải dữ liệu: ${response.statusCode}',
          ),
        ).show(context);
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _handleAcceptRequest(int accountId) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.diavan-valuation.asia/groups/accept-request'),
        body: {
          'senderId': accountId.toString(),
          'receiverId': currentUserAccountID.toString(),
        },
      );

      if (response.statusCode == 200) {
        CherryToast.success(
          toastDuration: const Duration(seconds: 3),
          title: const Text(
            'Đã chấp nhận yêu cầu',
          ),
          action: Text(
            "Tải lại dữ liệu...",
          ),
          actionHandler: () => fetchGroupData(),
        ).show(context);
        fetchGroupData();
      } else {
        throw Exception('Failed to accept request');
      }
    } catch (e) {
      CherryToast.error(
        toastDuration: const Duration(seconds: 3),
        title: Text(
          'Lỗi khi chấp nhận yêu cầu: ${e.toString()}',
        ),
      ).show(context);
    }
  }

  Future<void> _handleRejectRequest(int accountId) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.diavan-valuation.asia/groups/reject-request'),
        body: {
          'senderId': accountId.toString(),
          'receiverId': currentUserAccountID.toString(),
        },
      );

      if (response.statusCode == 200) {
        CherryToast.success(
          toastDuration: const Duration(seconds: 3),
          title: const Text(
            'Đã từ chối yêu cầu',
          ),
          action: Text(
            "Tải lại dữ liệu...",
          ),
          actionHandler: () => fetchGroupData(),
        ).show(context);
        fetchGroupData();
      } else {
        throw Exception('Failed to reject request');
      }
    } catch (e) {
      CherryToast.error(
        toastDuration: const Duration(seconds: 3),
        title: Text(
          'Lỗi khi từ chối yêu cầu: ${e.toString()}',
        ),
      ).show(context);
    }
  }

  void _showLeaveGroupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận rời nhóm'),
          content:
              const Text('Bạn có chắc chắn muốn rời khỏi nhóm gia đình này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleLeaveGroup();
              },
              child: const Text(
                'Rời nhóm',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLeaveGroup() async {
    try {
      // Gọi API để rời nhóm
      final response = await http.post(
        Uri.parse('https://api.diavan-valuation.asia/groups/leave-group'),
        body: {
          'accountId': currentUserAccountID.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          CherryToast.success(
            toastDuration: const Duration(seconds: 3),
            title: const Text(
              'Đã rời nhóm thành công',
            ),
          ).show(context);
          fetchGroupData(); // Làm mới dữ liệu
        } else {
          throw Exception(data['message'] ?? 'Failed to leave group');
        }
      } else {
        throw Exception('Failed to leave group: ${response.statusCode}');
      }
    } catch (e) {
      CherryToast.error(
        toastDuration: const Duration(seconds: 3),
        title: Text(
          'Lỗi khi rời nhóm: ${e.toString()}',
        ),
      ).show(context);
    }
  }

  Future<void> _handleCancelRequest(int accountId) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.diavan-valuation.asia/groups/cancel-request'),
        body: {
          'senderId': currentUserAccountID.toString(),
          'receiverId': accountId.toString(),
        },
      );

      if (response.statusCode == 200) {
        CherryToast.success(
          toastDuration: const Duration(seconds: 3),
          title: const Text(
            'Đã hủy lời mời',
          ),
          action: Text(
            "Tải lại dữ liệu...",
          ),
          actionHandler: () => fetchGroupData(),
        ).show(context);
        fetchGroupData();
      } else {
        throw Exception('Failed to cancel request');
      }
    } catch (e) {
      CherryToast.error(
        toastDuration: const Duration(seconds: 3),
        title: Text(
          'Lỗi khi hủy lời mời: ${e.toString()}',
        ),
      ).show(context);
    }
  }

  Widget _buildPendingRequestsTab() {
    final users = groupData?['responseUsers'] as List<dynamic>? ?? [];

    return users.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/empty_requests.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Không có yêu cầu nào đang chờ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tất cả yêu cầu đã được xử lý',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        : Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_active,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${users.length} yêu cầu đang chờ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: users
                      .map(
                        (user) => PendingRequestUserCard(
                          user: user,
                          currentUserAccountID: currentUserAccountID,
                          currentRoleID: currentRoleID,
                          fetchGroupData: fetchGroupData,
                          onAccept: _handleAcceptRequest,
                          onReject: _handleRejectRequest,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
  }

  Widget _buildSentRequestsTab() {
    final users = groupData?['requestUsers'] as List<dynamic>? ?? [];

    return users.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/empty_sent.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Không có yêu cầu nào đã gửi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Hãy gửi lời mời để thêm người thân vào nhóm',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        : Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${users.length} lời mời đã gửi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: users
                      .map(
                        (user) => SentRequestUserCard(
                          user: user,
                          currentUserAccountID: currentUserAccountID,
                          currentRoleID: currentRoleID,
                          refreshCallback: fetchGroupData,
                          onCancelRequest: _handleCancelRequest,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
  }

  Widget _buildNonGroupFamilyTab() {
    final users = groupData?['familyNotInGroup'] as List<dynamic>? ?? [];

    return users.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/empty_family.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Không có người thân nào ngoài nhóm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tất cả người thân đã trong nhóm của bạn',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        : Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_add,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${users.length} người thân chưa trong nhóm',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: users
                      .map(
                        (user) => UserOutOfGroupCard(
                          user: user,
                          currentUserAccountID: currentUserAccountID,
                          currentRoleID: currentRoleID,
                          fetchGroupData: fetchGroupData,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                'Đang tải dữ liệu nhóm...',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red[400],
              ),
              const SizedBox(height: 20),
              const Text(
                'Đã xảy ra lỗi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: fetchGroupData,
                child: const Text(
                  'Thử lại',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nhóm gia đình',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchGroupData,
            tooltip: 'Làm mới',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: AppColors.primaryColor,
              indicatorWeight: 4,
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: AppColors.secondaryColor,
              labelStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(text: 'Nhóm của bạn'),
                Tab(text: 'Lời mời đã gửi'),
                Tab(text: 'Yêu cầu chờ xử lý'),
                Tab(text: 'Người thân ngoài nhóm'),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF5F5F5)],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            GroupTab(
              groupData: groupData,
              currentUserAccountID: currentUserAccountID,
              currentRoleID: currentRoleID,
              fetchGroupData: fetchGroupData,
              showLeaveGroupDialog: _showLeaveGroupDialog,
            ),
            _buildSentRequestsTab(),
            _buildPendingRequestsTab(),
            _buildNonGroupFamilyTab(),
          ],
        ),
      ),
    );
  }
}
