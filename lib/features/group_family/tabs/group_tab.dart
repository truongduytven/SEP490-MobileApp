import 'package:flutter/material.dart';
import 'package:sep490/features/group_family/widgets/user_card.dart';
import 'package:sep490/theme/color.dart';

class GroupTab extends StatelessWidget {
  final Map<String, dynamic>? groupData;
  final int currentUserAccountID;
  final int currentRoleID;
  final VoidCallback fetchGroupData;
  final VoidCallback _showLeaveGroupDialog;
  final Function(int groupId)? _showDeleteGroupDialog;
  final Function(int groupId)? _showAddMemberDialog;

  const GroupTab({
    Key? key,
    required this.groupData,
    required this.currentUserAccountID,
    required this.currentRoleID,
    required this.fetchGroupData,
    required VoidCallback showLeaveGroupDialog,
    Function(int)? showDeleteGroupDialog,
    Function(int)? showAddMemberDialog,
  })  : _showLeaveGroupDialog = showLeaveGroupDialog,
        _showDeleteGroupDialog = showDeleteGroupDialog,
        _showAddMemberDialog = showAddMemberDialog,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> groups = [];

    if (currentRoleID == 2) {
      final groupInfo = groupData?['groupInfor'];
      if (groupInfo != null) groups.add(groupInfo);
    } else if (currentRoleID == 3) {
      final groupInfors = groupData?['groupInfors'];
      if (groupInfors != null) groups.addAll(groupInfors);
    }

    if (groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/nodata.webp',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 16),
            const Text(
              'Chưa có nhóm gia đình',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              textAlign: TextAlign.center,
              currentRoleID == 2
                  ? 'Hãy gửi lời mời cho người thân hỗ trợ để được thêm vào nhóm gia đình'
                  : "Hãy tạo nhóm gia đình với những người thân mà bạn hỗ trợ",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        final usersInGroup = group['usersInGroup'] as List<dynamic>? ?? [];
        final groupId = group['groupId'] as int? ?? 0;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group header with name and member count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.group,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Nhóm ${index + 1}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      if (currentRoleID == 2)
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.exit_to_app,
                                    size: 20, color: Colors.red),
                                SizedBox(width: 4),
                                Text(
                                  'Rời nhóm',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: _showLeaveGroupDialog,
                        )
                      else if (currentRoleID == 3)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.delete,
                                        size: 20, color: Colors.red),
                                    SizedBox(width: 4),
                                    Text(
                                      'Xóa nhóm',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () =>
                                  _showDeleteGroupDialog?.call(groupId),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    group['groupName'] ?? 'Không có tên',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.people, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${usersInGroup.length} thành viên',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            usersInGroup.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/nodata.webp',
                          width: 120,
                          height: 120,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Chưa có thành viên nào',
                          style: TextStyle(color: Colors.grey),
                        ),
                        if (currentRoleID == 3)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.person_add, size: 18),
                              label: const Text('Thêm thành viên'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: AppColors.primaryColor,
                              ),
                              onPressed: () =>
                                  _showAddMemberDialog?.call(groupId),
                            ),
                          ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Thành viên trong nhóm',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            if (currentRoleID == 3)
                              TextButton.icon(
                                icon: const Icon(Icons.person_add, size: 18),
                                label: const Text('Thêm'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primaryColor,
                                ),
                                onPressed: () =>
                                    _showAddMemberDialog?.call(groupId),
                              ),
                          ],
                        ),
                      ),
                      ...usersInGroup
                          .map(
                            (user) => UserCard(
                              user: user,
                              currentUserAccountID: currentUserAccountID,
                              currentRoleID: currentRoleID,
                              fetchGroupData: fetchGroupData,
                              groupId: groupId,
                              onRemoveMember: currentRoleID == 3 &&
                                      user['accountId'] != currentUserAccountID
                                  ? (kickerId, memberId) =>
                                      _showRemoveMemberDialog(
                                          kickerId, memberId, groupId)
                                  : null,
                            ),
                          )
                          .toList(),
                    ],
                  ),
            const Divider(height: 32),
            const SizedBox(height: 45),
          ],
        );
      },
    );
  }

  void _showRemoveMemberDialog(int kickerId, int memberId, int groupId) {
    // Implement your remove member dialog here
    // You can show a dialog or call a callback function
  }
}
