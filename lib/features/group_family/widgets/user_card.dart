import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:sep490/features/group_family/screens/user_detail_page.dart';
import 'package:sep490/theme/color.dart';

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final int currentUserAccountID;
  final int currentRoleID;
  final VoidCallback fetchGroupData;

  const UserCard({
    Key? key,
    required this.user,
    required this.currentUserAccountID,
    required this.currentRoleID,
    required this.fetchGroupData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCurrentUser = user['accountId'] == currentUserAccountID;
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (isCurrentUser) {
            CherryToast.info(
              title: const Text('Đây là bạn', style: TextStyle(fontSize: 16)),
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
                user: user,
                relationshipStatus: 'group',
                currentUserAccountID: currentUserAccountID,
                currentRoleID: currentRoleID,
                refreshCallback: fetchGroupData,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
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
                    image: NetworkImage(user['avatar'] ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user['fullName'] ?? 'Không có tên'} ${isCurrentUser ? "(Bạn)" : ""}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          user['roleId'] == 2
                              ? Icons.elderly
                              : Icons.family_restroom,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user['roleId'] == 2 ? 'Người già' : 'Người thân',
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
              Text(
                user['phoneNumber'] ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.pink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
