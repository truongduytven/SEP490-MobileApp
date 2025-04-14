import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sep490/data/helper/shared_prefs_helper.dart';

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
            toastDuration: Duration(seconds: 3),
            title: Text(
              data['message'] ?? "Không thể tải dữ liệu",
              style: TextStyle(color: Colors.black),
            ),
          ).show(context);
          throw Exception(data['message'] ?? 'Failed to load data');
        }
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            'Không thể tải dữ liệu: ${response.statusCode}',
            style: TextStyle(color: Colors.black),
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

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user['avatar'] ?? ''),
          radius: 25,
        ),
        title: Text(user['fullName'] ?? 'Không có tên'),
        subtitle: Text(
          user['roleId'] == 2 ? 'Người già' : 'Người thân',
        ),
        trailing: Text(user['phoneNumber'] ?? ''),
      ),
    );
  }

  Widget _buildGroupTab() {
    if (groupData?['groupInfor'] == null) {
      return const Center(child: Text('Không có thông tin nhóm'));
    }

    final groupInfo = groupData!['groupInfor'];
    final usersInGroup = groupInfo['usersInGroup'] as List<dynamic>? ?? [];

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Nhóm: ${groupInfo['groupName'] ?? 'Không có tên'}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (usersInGroup.isNotEmpty)
          ...usersInGroup.map((user) => _buildUserCard(user)).toList()
        else
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Không có thành viên nào trong nhóm này'),
          ),
      ],
    );
  }

  Widget _buildListTab(List<dynamic>? users, String emptyMessage) {
    if (users == null || users.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView(
      children: users.map((user) => _buildUserCard(user)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: const Center(child: CircularProgressIndicator()));
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Lỗi: $errorMessage'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchGroupData,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhóm gia đình'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchGroupData,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Nhóm gia đình của bạn'),
            Tab(text: 'Yêu cầu đã gửi'),
            Tab(text: 'Yêu cầu đang chờ bạn phản hồi'),
            Tab(text: 'Người thân không thuộc nhóm'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGroupTab(),
          _buildListTab(groupData?['requestUsers'], 'No pending requests'),
          _buildListTab(groupData?['responseUsers'], 'No responded users'),
          _buildListTab(groupData?['familyNotInGroup'],
              'No family members outside group'),
        ],
      ),
    );
  }
}
