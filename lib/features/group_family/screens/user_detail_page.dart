import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sep490/theme/color.dart';

class UserDetailPage extends StatefulWidget {
  final Map<String, dynamic> user;
  final String relationshipStatus; // 'group', 'pending', 'sent', 'non-group'
  final int currentUserAccountID;
  final int currentRoleID;
  final VoidCallback refreshCallback;

  const UserDetailPage({
    super.key,
    required this.user,
    required this.relationshipStatus,
    required this.currentUserAccountID,
    required this.currentRoleID,
    required this.refreshCallback,
  });

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        title: Text(widget.user['fullName'] ?? 'Thông tin người dùng'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserHeader(),
          const SizedBox(height: 24),
          _buildRelationshipStatus(),
          const SizedBox(height: 24),
          _buildUserInfoSection(),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 50,
            backgroundImage: NetworkImage(widget.user['avatar'] ?? ''),
          ),
          const SizedBox(height: 16),
          Text(
            widget.user['fullName'] ?? 'Không có tên',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.user['roleId'] == 2 ? 'Người già' : 'Người thân',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipStatus() {
    String statusText = '';
    IconData iconData;
    Color color;

    switch (widget.relationshipStatus) {
      case 'group':
        statusText = 'Bạn đang cùng nhóm gia đình';
        iconData = Icons.group;
        color = Colors.green;
        break;
      case 'pending':
        statusText = 'Đang chờ bạn phản hồi yêu cầu';
        iconData = Icons.access_time;
        color = Colors.orange;
        break;
      case 'sent':
        statusText = 'Đang đợi chấp nhận lời mời';
        iconData = Icons.hourglass_top;
        color = Colors.blue;
        break;
      case 'non-group':
        statusText = 'Chưa cùng trong nhóm gia đình';
        iconData = Icons.person_outline;
        color = Colors.grey;
        break;
      default:
        statusText = 'Không xác định mối quan hệ';
        iconData = Icons.help_outline;
        color = Colors.grey;
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconData, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 16,
                height: 1.2,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin liên hệ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildInfoItem(Icons.phone, 'Số điện thoại',
            widget.user['phoneNumber'] ?? 'Chưa cập nhật'),
        const SizedBox(height: 8),
        _buildInfoItem(
            Icons.email, 'Email', widget.user['email'] ?? 'Chưa cập nhật'),
        const SizedBox(height: 8),
        _buildInfoItem(Icons.cake, 'Ngày sinh',
            widget.user['dateOfBirth'] ?? 'Chưa cập nhật'),
        const SizedBox(height: 8),
        _buildInfoItem(Icons.person_4_sharp, 'Giới tính',
            widget.user['gender'] ?? 'Chưa cập nhật'),
        const SizedBox(height: 8),
        _buildInfoItem(Icons.join_inner, 'Tham gia ngày',
            widget.user['createdDate'] ?? 'Chưa cập nhật'),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    String _formatValue(String label, String value) {
      if (value.isEmpty) return 'Chưa cập nhật';

      switch (label) {
        case 'Ngày sinh':
        case 'Tham gia ngày':
          try {
            DateTime dateTime = DateTime.parse(value);
            return DateFormat('dd/MM/yyyy').format(dateTime);
          } catch (_) {
            return 'Chưa cập nhật';
          }
        case 'Giới tính':
          return (value.toLowerCase() == 'male') ? 'Nam' : 'Nữ';
        default:
          return value;
      }
    }

    final formattedValue = _formatValue(label, value);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedValue,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    switch (widget.relationshipStatus) {
      // case 'group':
      //   return _buildGroupActions();
      case 'pending':
        return _buildPendingActions();
      case 'sent':
        return _buildSentActions();
      case 'non-group':
        return _buildNonGroupActions();
      default:
        return Container();
    }
  }

  Widget _buildGroupActions() {
    return Column(
      children: [
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text('Trở về'),
        ),
      ],
    );
  }

  Widget _buildPendingActions() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Xác nhận'),
                  content: const Text(
                      'Bạn có chắc chắn muốn chấp nhận yêu cầu này không?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Không'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _handleAcceptRequest();
                      },
                      child: const Text('Có'),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text(
            'Chấp nhận yêu cầu',
            style: TextStyle(
              color: AppColors.bgColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Xác nhận'),
                  content: const Text(
                      'Bạn có chắc chắn muốn từ chối yêu cầu này không?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Không'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _handleRejectRequest();
                      },
                      child: const Text('Có'),
                    ),
                  ],
                );
              },
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text('Từ chối yêu cầu'),
        ),
      ],
    );
  }

  Widget _buildSentActions() {
    return Column(
      children: [
        OutlinedButton(
          onPressed: () async {
            final shouldCancel = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Xác nhận'),
                content: const Text('Bạn có chắc muốn hủy lời mời này không?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Không'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Có'),
                  ),
                ],
              ),
            );

            if (shouldCancel == true) {
              _handleCancelRequest();
            }
          },
          // onPressed: () => _handleCancelRequest(),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text('Hủy lời mời'),
        ),
      ],
    );
  }

  Widget _buildNonGroupActions() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _sendJoinRequest(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text('Gửi lời mời tham gia nhóm'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text('Trở về'),
        ),
      ],
    );
  }

  Future<void> _handleAcceptRequest() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.put(
        Uri.parse(
            'https://api.diavan-valuation.asia/user-link-management/response-add-friend'),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
        body: json.encode({
          "requestUserId": widget.currentUserAccountID,
          "responseUserId": widget.user['accountId'],
          "responseStatus": "Accepted"
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          CherryToast.success(
            title: const Text('Đã chấp nhận yêu cầu'),
            actionHandler: () => Navigator.pop(context),
          ).show(context);
          Navigator.pop(context);
          widget.refreshCallback();
        } else {
          throw Exception(data['message'] ?? 'Failed to accept request');
        }
      } else {
        throw Exception('Failed to accept request: ${response.statusCode}');
      }
    } catch (e) {
      CherryToast.error(
        title: Text('Lỗi: ${e.toString()}'),
      ).show(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRejectRequest() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.put(
        Uri.parse(
            'https://api.diavan-valuation.asia/user-link-management/response-add-friend'),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
        body: json.encode({
          "requestUserId": widget.currentUserAccountID,
          "responseUserId": widget.user['accountId'],
          "responseStatus": "Rejected"
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          CherryToast.success(
            title: const Text('Đã từ chối yêu cầu'),
            actionHandler: () => Navigator.pop(context),
          ).show(context);
          Navigator.pop(context);
          widget.refreshCallback();
        } else {
          throw Exception(data['message'] ?? 'Failed to reject request');
        }
      } else {
        throw Exception('Failed to reject request: ${response.statusCode}');
      }
    } catch (e) {
      CherryToast.error(
        title: Text('Lỗi: ${e.toString()}'),
      ).show(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCancelRequest() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.put(
        Uri.parse(
            'https://api.diavan-valuation.asia/user-link-management/response-add-friend'),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
        body: json.encode({
          "requestUserId": widget.currentUserAccountID,
          "responseUserId": widget.user['accountId'],
          "responseStatus": "Cancelled"
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          CherryToast.success(
            title: const Text('Đã hủy lời mời'),
            actionHandler: () => Navigator.pop(context),
          ).show(context);
          Navigator.pop(context);
          widget.refreshCallback();
        } else {
          throw Exception(data['message'] ?? 'Failed to cancel request');
        }
      } else {
        throw Exception('Failed to cancel request: ${response.statusCode}');
      }
    } catch (e) {
      CherryToast.error(
        title: Text('Lỗi: ${e.toString()}'),
      ).show(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendJoinRequest() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('https://api.diavan-valuation.asia/groups/send-request'),
        body: {
          'senderId': widget.currentUserAccountID.toString(),
          'receiverId': widget.user['accountId'].toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          CherryToast.success(
            title: const Text('Đã gửi lời mời tham gia nhóm'),
            action: const Text('Đóng'),
            actionHandler: () => Navigator.pop(context),
          ).show(context);
          widget.refreshCallback();
        } else {
          throw Exception(data['message'] ?? 'Failed to send request');
        }
      } else {
        throw Exception('Failed to send request: ${response.statusCode}');
      }
    } catch (e) {
      CherryToast.error(
        title: Text('Lỗi: ${e.toString()}'),
      ).show(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
