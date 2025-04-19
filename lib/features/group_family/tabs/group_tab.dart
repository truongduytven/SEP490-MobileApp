// import 'package:flutter/material.dart';
// import 'package:sep490/features/group_family/widgets/user_card.dart';
// import 'package:sep490/theme/color.dart';

// class GroupTab extends StatelessWidget {
//   final Map<String, dynamic>? groupData;
//   final int currentUserAccountID;
//   final int currentRoleID;
//   final VoidCallback fetchGroupData;
//   final VoidCallback _showLeaveGroupDialog;
//   final Function(int groupId)? _showDeleteGroupDialog;

//   const GroupTab({
//     Key? key,
//     required this.groupData,
//     required this.currentUserAccountID,
//     required this.currentRoleID,
//     required this.fetchGroupData,
//     required VoidCallback showLeaveGroupDialog,
//     Function(int)? showDeleteGroupDialog,
//     Function(int)? showAddMemberDialog,
//   })  : _showLeaveGroupDialog = showLeaveGroupDialog,
//         _showDeleteGroupDialog = showDeleteGroupDialog,
//         super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<dynamic> groups = [];

//     if (currentRoleID == 2) {
//       final groupInfo = groupData?['groupInfor'];
//       if (groupInfo != null) groups.add(groupInfo);
//     } else if (currentRoleID == 3) {
//       final groupInfors = groupData?['groupInfors'];
//       if (groupInfors != null) groups.addAll(groupInfors);
//     }

//     if (groups.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/images/nodata.webp',
//               width: 150,
//               height: 150,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Chưa có nhóm gia đình',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               textAlign: TextAlign.center,
//               currentRoleID == 2
//                   ? 'Hãy gửi lời mời cho người thân hỗ trợ để được thêm vào nhóm gia đình'
//                   : "Hãy tạo nhóm gia đình với những người thân mà bạn hỗ trợ",
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: groups.length,
//       itemBuilder: (context, index) {
//         final group = groups[index];
//         final usersInGroup = group['usersInGroup'] as List<dynamic>? ?? [];
//         final groupId = group['groupId'] as int? ?? 0;

//         return Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               margin: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: AppColors.primaryColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Group header with name and member count
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.group,
//                             color: AppColors.primaryColor,
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             'Nhóm ${index + 1}',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.primaryColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                       if (currentRoleID == 2)
//                         IconButton(
//                           icon: Container(
//                             padding: const EdgeInsets.all(6),
//                             decoration: BoxDecoration(
//                               color: Colors.red.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(Icons.exit_to_app,
//                                     size: 20, color: Colors.red),
//                                 SizedBox(width: 4),
//                                 Text(
//                                   'Rời nhóm',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           onPressed: _showLeaveGroupDialog,
//                         )
//                       else if (currentRoleID == 3)
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: Container(
//                                 padding: const EdgeInsets.all(6),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: const Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(Icons.delete,
//                                         size: 20, color: Colors.red),
//                                     SizedBox(width: 4),
//                                     Text(
//                                       'Xóa nhóm',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.red,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               onPressed: () =>
//                                   _showDeleteGroupDialog?.call(groupId),
//                             ),
//                           ],
//                         ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     group['groupName'] ?? 'Không có tên',
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       const Icon(Icons.people, size: 16, color: Colors.grey),
//                       const SizedBox(width: 4),
//                       Text(
//                         '${usersInGroup.length} thành viên',
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             usersInGroup.isEmpty
//                 ? Center(
//                     child: Column(
//                       children: [
//                         Image.asset(
//                           'assets/images/nodata.webp',
//                           width: 120,
//                           height: 120,
//                         ),
//                         const SizedBox(height: 8),
//                         const Text(
//                           'Chưa có thành viên nào',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                         if (currentRoleID == 3)
//                           Padding(
//                             padding: const EdgeInsets.only(top: 16),
//                             child: ElevatedButton.icon(
//                               icon: const Icon(Icons.person_add, size: 18),
//                               label: const Text('Thêm thành viên'),
//                               style: ElevatedButton.styleFrom(
//                                 foregroundColor: Colors.white,
//                                 backgroundColor: AppColors.primaryColor,
//                               ),
//                               onPressed: () =>
//                                   _showAddMemberDialog?.call(groupId),
//                             ),
//                           ),
//                       ],
//                     ),
//                   )
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 8),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Thành viên trong nhóm',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             if (currentRoleID == 3)
//                               TextButton.icon(
//                                 icon: const Icon(Icons.person_add,  size: 18),
//                                 label: const Text('Thêm'),
//                                 style: TextButton.styleFrom(
//                                   foregroundColor: AppColors.primaryColor,
//                                 ),
//                                 onPressed: () =>
//                                     _showAddMemberDialog?.call(groupId),
//                               ),
//                           ],
//                         ),
//                       ),
//                       ...usersInGroup
//                           .map(
//                             (user) => UserCard(
//                               user: user,
//                               currentUserAccountID: currentUserAccountID,
//                               currentRoleID: currentRoleID,
//                               fetchGroupData: fetchGroupData,
//                               groupId: groupId,
//                               onRemoveMember: currentRoleID == 3 &&
//                                       user['accountId'] != currentUserAccountID
//                                   ? (kickerId, memberId) =>
//                                       _showRemoveMemberDialog(
//                                           kickerId, memberId, groupId)
//                                   : null,
//                             ),
//                           )
//                           .toList(),
//                     ],
//                   ),
//             const Divider(height: 32),
//             const SizedBox(height: 45),
//           ],
//         );
//       },
//     );
//   }

//   void _showRemoveMemberDialog(int kickerId, int memberId, int groupId) {
//     // Implement your remove member dialog here
//     // You can show a dialog or call a callback function
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:sep490/features/group_family/widgets/user_card.dart';
import 'package:sep490/theme/color.dart';

class GroupTab extends StatelessWidget {
  final Map<String, dynamic>? groupData;
  final int currentUserAccountID;
  final int currentRoleID;
  final VoidCallback fetchGroupData;
  final VoidCallback _showLeaveGroupDialog;
  final Function(int groupId)? _showDeleteGroupDialog;

  const GroupTab({
    Key? key,
    required this.groupData,
    required this.currentUserAccountID,
    required this.currentRoleID,
    required this.fetchGroupData,
    required VoidCallback showLeaveGroupDialog,
    Function(int)? showDeleteGroupDialog,
  })  : _showLeaveGroupDialog = showLeaveGroupDialog,
        _showDeleteGroupDialog = showDeleteGroupDialog,
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
        final groupName = group['groupName'] ?? 'Nhóm không tên';

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
                    groupName,
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
                              onPressed: () => _showAddMemberDialog(
                                  context, groupId, groupName),
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
                                onPressed: () => _showAddMemberDialog(
                                    context, groupId, groupName),
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
                                          context, kickerId, memberId, groupId)
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

  Future<void> _showAddMemberDialog(
      BuildContext context, int groupId, String groupName) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
          child: CircularProgressIndicator(
        color: AppColors.primaryColor,
      )),
    );

    try {
      final response = await http.get(Uri.parse(
          'https://api.diavan-valuation.asia/groups/relationship-information/member-not-in-group/family-member/$currentUserAccountID'));

      Navigator.pop(context); // Close loading dialog

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1 && data['data'] != null) {
          final members = List<Map<String, dynamic>>.from(data['data']);
          _showAddMemberBottomSheet(context, groupId, groupName, members);
        } else {
          CherryToast.error(
            title: Text(data['message'] ?? 'Không có thành viên nào để thêm'),
          ).show(context);
        }
      } else {
        throw Exception('Failed to load members: ${response.statusCode}');
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog if error occurs
      CherryToast.error(
        title: Text('Lỗi: ${e.toString()}'),
      ).show(context);
    }
  }

  void _showAddMemberBottomSheet(BuildContext context, int groupId,
      String groupName, List<Map<String, dynamic>> members) {
    // Thêm state để lưu các thành viên được chọn
    final selectedMembers = <int>[];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          'Thêm thành viên vào "$groupName"',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          if (selectedMembers.isNotEmpty)
                            TextButton(
                              onPressed: () {
                                _addMembersToGroup(
                                  context,
                                  groupId,
                                  selectedMembers,
                                );
                              },
                              child: Text(
                                'Thêm (${selectedMembers.length})',
                                style: const TextStyle(color: Colors.green),
                              ),
                            ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: members.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.group_off,
                                    size: 50, color: Colors.grey),
                                const SizedBox(height: 16),
                                const Text(
                                  'Không có thành viên nào để thêm',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: members.length,
                            itemBuilder: (context, index) {
                              final member = members[index];
                              final isSelected =
                                  selectedMembers.contains(member['accountId']);
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(member['avatar'] ?? ''),
                                ),
                                title:
                                    Text(member['fullName'] ?? 'Không có tên'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(member['phoneNumber'] ?? ''),
                                    Text(
                                      member['dateOfBirth'] != null
                                          ? 'Năm sinh: ${DateTime.parse(member['dateOfBirth']).year}'
                                          : '',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                trailing: Checkbox(
                                  activeColor: AppColors.primaryColor,
                                  checkColor: AppColors.bgColor,
                                  value: isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedMembers
                                            .add(member['accountId']);
                                      } else {
                                        selectedMembers
                                            .remove(member['accountId']);
                                      }
                                    });
                                  },
                                ),
                                onTap: () {
                                  setState(() {
                                    if (selectedMembers
                                        .contains(member['accountId'])) {
                                      selectedMembers
                                          .remove(member['accountId']);
                                    } else {
                                      selectedMembers.add(member['accountId']);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _addMembersToGroup(
      BuildContext context, int groupId, List<int> memberIds) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              backgroundColor: AppColors.bgColor,
              color: AppColors.primaryColor,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Đang thêm thành viên vào nhóm",
              style: TextStyle(
                color: AppColors.bgColor,
              ),
            )
          ],
        ),
      ),
    );

    try {
      const url = 'https://api.diavan-valuation.asia/groups/add-member';
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'groupId': groupId,
          'memberIds': memberIds,
        }),
      );

      Navigator.pop(context); // Đóng dialog loading

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          CherryToast.success(
            title: Text('Đã thêm ${memberIds.length} thành viên vào nhóm'),
          ).show(context);
          fetchGroupData();
          Navigator.pop(context); // Đóng bottom sheet
        } else {
          CherryToast.error(
            title: Text(data['message'] ?? 'Lỗi khi thêm thành viên'),
          ).show(context);
        }
      } else {
        throw Exception('Failed to add members: ${response.statusCode}');
      }
    } catch (e) {
      Navigator.pop(context); // Đóng dialog loading nếu có lỗi
      CherryToast.error(
        title: Text('Lỗi: ${e.toString()}'),
      ).show(context);
    }
  }

  void _showRemoveMemberDialog(
      BuildContext context, int kickerId, int memberId, int groupId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content:
            const Text('Bạn có chắc chắn muốn xóa thành viên này khỏi nhóm?'),
        actions: [
          TextButton(
            child: const Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.pop(context);
              await _removeMemberFromGroup(
                  context, kickerId, memberId, groupId);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _removeMemberFromGroup(
      BuildContext context, int kickerId, int memberId, int groupId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await http.delete(Uri.parse(
          'https://api.diavan-valuation.asia/groups/$groupId/members/$kickerId/$memberId'));

      Navigator.pop(context); // Close loading dialog

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          CherryToast.success(
            title: const Text('Đã xóa thành viên khỏi nhóm'),
          ).show(context);
          fetchGroupData();
        } else {
          CherryToast.error(
            title: Text(data['message'] ?? 'Lỗi khi xóa thành viên'),
          ).show(context);
        }
      } else {
        throw Exception('Failed to remove member: ${response.statusCode}');
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog if error occurs
      CherryToast.error(
        title: Text('Lỗi: ${e.toString()}'),
      ).show(context);
    }
  }
}
