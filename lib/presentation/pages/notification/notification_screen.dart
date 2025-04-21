import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/theme/color.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isLoading = true;
  List<dynamic> _notifications = [];
  String _errorMessage = '';
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int userId = sharedPrefsHelper.getInt('accountId')!;
  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final response = await http.get(
        Uri.parse(
            'https://api.diavan-valuation.asia/notification-management?accountId=${userId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          setState(() {
            _notifications = data['data'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = data['message'] ?? 'Failed to load notifications';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage =
              'Failed to load notifications. Status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(int notificationId) async {
    try {
      final response = await http.put(
        Uri.parse(
            'https://api.diavan-valuation.asia/notification-management/update?notiId=$notificationId&status=Đã%20đọc'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] != 1) {
          // Show error if needed
          debugPrint('Failed to mark as read: ${data['message']}');
        }
      } else {
        debugPrint(
            'Failed to mark as read. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error marking as read: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thông báo",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.secondaryColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 24),
            onPressed: _fetchNotifications,
            tooltip: 'Làm mới',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: _fetchNotifications,
              child: const Text(
                'Thử lại',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Không có thông báo mới',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryColor,
      onRefresh: _fetchNotifications,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 72),
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          final isUnread = notification['status'] == 'Chưa đọc';

          return _buildNotificationItem(notification, isUnread, index);
        },
      ),
    );
  }

  Widget _buildNotificationItem(
      Map<String, dynamic> notification, bool isUnread, int index) {
    final createdDate = DateTime.parse(notification['createdDate']);
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd/MM');
    Icon getNotificationIcon(String notificationType, bool isUnread) {
      // Màu sắc mặc định
      final Color activeColor = isUnread
          ? AppColors.primaryColor
          : Colors.grey[400] ?? AppColors.primaryColor;
      final Color emergencyColor =
          isUnread ? Colors.red : Colors.grey[400] ?? AppColors.primaryColor;

      switch (notificationType) {
        // Thuốc/Medication
        case 'Medication':
          return Icon(
            isUnread ? Icons.medication : Icons.medication_outlined,
            color: activeColor,
            size: 24,
          );

        // Cảnh báo sức khỏe
        case 'Cảnh báo sức khỏe':
          return Icon(
            isUnread
                ? Icons.health_and_safety
                : Icons.health_and_safety_outlined,
            color: emergencyColor,
            size: 24,
          );

        // Kết bạn mới
        case 'Kết Bạn Mới':
          return Icon(
            isUnread ? Icons.person_add : Icons.person_add_outlined,
            color: activeColor,
            size: 24,
          );

        // Chấp nhận kết bạn
        case 'Chấp nhận kết bạn':
          return Icon(
            isUnread ? Icons.person_2 : Icons.person_2_outlined,
            color: Colors.green,
            size: 24,
          );

        // SOS/Khẩn cấp
        case 'SOS':
          return Icon(
            isUnread ? Icons.emergency : Icons.emergency_outlined,
            color: emergencyColor,
            size: 24,
          );

        // Mua gói dịch vụ
        case 'Mua Gói Dịch Vụ':
          return Icon(
            isUnread ? Icons.card_membership : Icons.card_membership_outlined,
            color: Colors.blue,
            size: 24,
          );

        // Gửi yêu cầu hỗ trợ
        case 'Gửi Yêu Cầu Hỗ Trợ':
          return Icon(
            isUnread ? Icons.help : Icons.help_outline,
            color: activeColor,
            size: 24,
          );

        // Xác nhận hỗ trợ
        case 'Xác Nhận Hỗ Trợ':
          return Icon(
            isUnread ? Icons.thumb_up : Icons.thumb_up_outlined,
            color: Colors.green,
            size: 24,
          );

        // Thêm vào gia đình
        case 'Thêm Vào Gia Đình':
          return Icon(
            isUnread ? Icons.family_restroom : Icons.group_add,
            color: activeColor,
            size: 24,
          );

        // Nhắc nhở uống nước
        case 'Nhắc nhở uống nước':
          return Icon(
            isUnread ? Icons.local_drink : Icons.local_drink_outlined,
            color: Colors.blue[300],
            size: 24,
          );

        // Mặc định
        default:
          return Icon(
            isUnread ? Icons.notifications_active : Icons.notifications_none,
            color: activeColor,
            size: 24,
          );
      }
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        // child: Icon(
        //   isUnread ? Icons.notifications_active : Icons.notifications_none,
        //   color: isUnread ? AppColors.primaryColor : Colors.grey[400],
        //   size: 24,
        // ),
        child: getNotificationIcon(notification['notificationType'], isUnread),
      ),
      title: Text(
        notification['title'],
        style: TextStyle(
          fontSize: 16,
          fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
          color: isUnread ? Colors.black : Colors.grey[700],
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            notification['message'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${timeFormat.format(createdDate)} - ${dateFormat.format(createdDate)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
      trailing: isUnread
          ? Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
            )
          : null,
      onTap: () async {
        if (isUnread) {
          // Optimistically update UI first
          setState(() {
            _notifications[index]['status'] = 'Đã đọc';
          });

          // Then call API
          try {
            await _markAsRead(notification['notificationId']);

            // Refresh to ensure sync with server
            await _fetchNotifications();
          } catch (e) {
            // Revert if API call fails
            setState(() {
              _notifications[index]['status'] = 'Chưa đọc';
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đánh dấu đọc thất bại: ${e.toString()}'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      },
    );
  }
}
