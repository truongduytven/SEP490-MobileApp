import 'package:flutter/material.dart';
import 'package:sep490/features/group_family/screens/user_detail_page.dart';

class UserOutOfGroupCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final int currentUserAccountID;
  final int currentRoleID;
  final VoidCallback fetchGroupData;

  const UserOutOfGroupCard({
    Key? key,
    required this.user,
    required this.currentUserAccountID,
    required this.currentRoleID,
    required this.fetchGroupData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailPage(
              user: user,
              relationshipStatus: 'non-group',
              currentUserAccountID: currentUserAccountID,
              currentRoleID: currentRoleID,
              refreshCallback: fetchGroupData,
            ),
          ),
        ),
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
                    color: Colors.green,
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
                      user['fullName'] ?? 'Không có tên',
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
