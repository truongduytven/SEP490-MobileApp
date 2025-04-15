import 'package:flutter/material.dart';
import 'package:sep490/features/group_family/screens/user_detail_page.dart';

class SentRequestUserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final int currentUserAccountID;
  final int currentRoleID;
  final Future<void> Function() refreshCallback;
  final void Function(int accountId) onCancelRequest;

  const SentRequestUserCard({
    super.key,
    required this.user,
    required this.currentUserAccountID,
    required this.currentRoleID,
    required this.refreshCallback,
    required this.onCancelRequest,
  });

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
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailPage(
              user: user,
              relationshipStatus: 'sent',
              currentUserAccountID: currentUserAccountID,
              currentRoleID: currentRoleID,
              refreshCallback: refreshCallback,
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
                    color: Colors.blue.withOpacity(0.5),
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
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                // onPressed: () => onCancelRequest(user['accountId']),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Xác nhận'),
                        content:
                            const Text('Bạn có chắc muốn hủy lời mời không?'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(), // Đóng dialog
                            child: const Text('Không'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); 
                              onCancelRequest(user['accountId']); 
                            },
                            child: const Text('Có'),
                          ),
                        ],
                      );
                    },
                  );
                },

                child: const Text(
                  'Hủy lời mời',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
