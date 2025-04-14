import 'package:flutter/material.dart';
import 'package:sep490/features/group_family/widgets/user_card.dart';
import 'package:sep490/theme/color.dart';

class GroupTab extends StatelessWidget {
  final Map<String, dynamic>? groupData;
  final int currentUserAccountID;
  final int currentRoleID;
  final VoidCallback fetchGroupData;
  final VoidCallback _showLeaveGroupDialog;

  const GroupTab({
    Key? key,
    required this.groupData,
    required this.currentUserAccountID,
    required this.currentRoleID,
    required this.fetchGroupData,
    required VoidCallback showLeaveGroupDialog,
  })  : _showLeaveGroupDialog = showLeaveGroupDialog,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (groupData?['groupInfor'] == null) {
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
            const Text(
              'Hãy tạo hoặc tham gia một nhóm để bắt đầu',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    final groupInfo = groupData!['groupInfor'];
    final usersInGroup = groupInfo['usersInGroup'] as List<dynamic>? ?? [];

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
                        'Nhóm của bạn',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
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
                          Icon(Icons.exit_to_app, size: 20, color: Colors.red),
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
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                groupInfo['groupName'] ?? 'Không có tên',
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
        Expanded(
          child: usersInGroup.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/nodata.webp',
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Chưa có thành viên nào',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView(
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Thành viên trong nhóm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ...usersInGroup
                        .map(
                          (user) => UserCard(
                            user: user,
                            currentUserAccountID: currentUserAccountID,
                            currentRoleID: currentRoleID,
                            fetchGroupData: fetchGroupData,
                          ),
                        )
                        .toList(),
                  ],
                ),
        ),
      ],
    );
  }
}
