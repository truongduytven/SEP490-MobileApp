import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:sep490/features/group_family/screens/user_detail_page.dart';
import 'package:sep490/theme/color.dart';
import 'package:http/http.dart' as http;

class UserCard extends StatefulWidget {
  final Map<String, dynamic> user;
  final int currentUserAccountID;
  final int currentRoleID;
  final int groupId;
  final VoidCallback fetchGroupData;
  final Function(int, int)? onRemoveMember;

  const UserCard({
    Key? key,
    required this.user,
    required this.currentUserAccountID,
    required this.currentRoleID,
    required this.groupId,
    required this.fetchGroupData,
    this.onRemoveMember,
  }) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool _isDeleting = false; // Biến trạng thái loading khi xóa

  @override
  Widget build(BuildContext context) {
    final bool isCurrentUser =
        widget.user['accountId'] == widget.currentUserAccountID;
    final bool canRemove = widget.currentRoleID == 3 && !isCurrentUser;

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _isDeleting
            ? null
            : () {
                if (isCurrentUser) {
                  CherryToast.info(
                    title: const Text('Đây là bạn',
                        style: TextStyle(fontSize: 16)),
                    width: MediaQuery.of(context).size.width,
                    animationDuration: const Duration(milliseconds: 200),
                    toastDuration: const Duration(seconds: 1),
                    toastPosition: Position.bottom,
                    displayCloseButton: false,
                  ).show(context);
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailPage(
                      user: widget.user,
                      relationshipStatus: 'group',
                      currentUserAccountID: widget.currentUserAccountID,
                      currentRoleID: widget.currentRoleID,
                      refreshCallback: widget.fetchGroupData,
                    ),
                  ),
                );
              },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(widget.user['avatar'] ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.user['fullName'] ?? 'Không có tên'} ${isCurrentUser ? "(Bạn)" : ""}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          widget.user['roleId'] == 2
                              ? Icons.elderly
                              : Icons.family_restroom,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.user['roleId'] == 2
                              ? 'Người già'
                              : 'Người thân',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Phone number and remove button
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.user['phoneNumber'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.pink,
                    ),
                  ),
                  if (canRemove) ...[
                    const SizedBox(width: 12),
                    _isDeleting
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          )
                        : IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: Colors.red,
                              ),
                            ),
                            onPressed: () => _showRemoveConfirmation(context),
                          ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRemoveConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: Text(
          'Bạn có chắc chắn muốn xóa ${widget.user['fullName']} khỏi nhóm?',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _removeMember(context, widget.user['accountId'], widget.groupId);
    }
  }

  Future<void> _removeMember(
      BuildContext context, int memberId, int groupId) async {
    setState(() => _isDeleting = true);

    try {
      final url =
          'https://api.diavan-valuation.asia/groups/$groupId/members/${widget.currentUserAccountID}/$memberId';
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          CherryToast.success(
            title: Text('Đã xóa ${widget.user['fullName']} khỏi nhóm'),
            toastDuration: const Duration(seconds: 2),
          ).show(context);
          widget.fetchGroupData();
        } else {
          CherryToast.error(
            title: Text(data['message'] ?? 'Lỗi khi xóa thành viên'),
          ).show(context);
        }
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      CherryToast.error(
        title: Text('Lỗi: ${e.toString()}'),
      ).show(context);
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }
}
