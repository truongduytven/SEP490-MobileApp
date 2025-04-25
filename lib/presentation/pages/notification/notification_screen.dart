import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/blood_glucose/screens/add_blood_glucose_screen.dart';
import 'package:sep490/features/blood_oxygen/screens/add_blood_oxygen.dart';
import 'package:sep490/features/blood_pressure/screens/add_blood_pressure_screen.dart';
import 'package:sep490/features/group_family/screens/group_family.dart';
import 'package:sep490/features/heart_beat/screens/add_heart_beat_screen.dart';
import 'package:sep490/features/kidney_function/screens/add_kidney_function_screen.dart';
import 'package:sep490/features/lipid_profile/screens/add_lipid_profile_screen.dart';
import 'package:sep490/features/liver_enzymes/screens/add_liver_enzymes_screen.dart';
import 'package:sep490/features/water_drinking/screens/water_drinking.dart';
import 'package:sep490/presentation/layout/mobile_layout_screen.dart';
import 'package:sep490/presentation/pages/medicine/home_medicine.dart';
import 'package:sep490/presentation/pages/navigation_menu.dart';
import 'package:sep490/presentation/pages/schedule/schedule_screen.dart';
import 'package:sep490/theme/color.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  List<dynamic> _notifications = [];
  String _errorMessage = '';
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int userId = sharedPrefsHelper.getInt('accountId')!;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchNotifications() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final response = await http.get(
        Uri.parse(
            'https://api.diavan-valuation.asia/notification-management?accountId=$userId'),
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
            _errorMessage = data['data'] ?? 'Failed to load notifications';
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

  List<dynamic> get _unreadNotifications => _notifications
      .where((notification) => notification['status'] == 'Chưa đọc')
      .toList();

  List<dynamic> get _readNotifications => _notifications
      .where((notification) => notification['status'] == 'Đã đọc')
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Thông báo",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.secondaryColor,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryColor,
          indicatorWeight: 3,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: Colors.grey[600],
          labelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          tabs: [
            Tab(
              text: "Tất cả (${_notifications.length})",
            ),
            Tab(
              text: "Chưa đọc (${_unreadNotifications.length})",
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 24),
            onPressed: _fetchNotifications,
            tooltip: 'Làm mới',
            color: AppColors.primaryColor,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsTab(_notifications),
          _buildNotificationsTab(_unreadNotifications),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab(List<dynamic> notifications) {
    if (_isLoading) {
      return _buildLoadingView();
    }

    if (_errorMessage.isNotEmpty) {
      return _buildErrorView();
    }

    if (notifications.isEmpty) {
      return _buildEmptyView();
    }

    return RefreshIndicator(
      color: AppColors.primaryColor,
      onRefresh: _fetchNotifications,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          final isUnread = notification['status'] == 'Chưa đọc';
          return _buildNotificationCard(notification, isUnread, index);
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return Shimmer.fromColors(
      baseColor: Color.fromARGB(255, 243, 240, 248),
      highlightColor: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 120,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 56,
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
          const SizedBox(height: 32),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              elevation: 0,
            ),
            onPressed: _fetchNotifications,
            icon: const Icon(
              Icons.refresh,
              size: 20,
            ),
            label: const Text(
              'Thử lại',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img3D/empty_notification.webp', // Đảm bảo bạn có ảnh này hoặc thay thế bằng một Icon
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          Text(
            'Không có thông báo',
            style: TextStyle(
                fontSize: 20,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Tất cả thông báo của bạn sẽ hiển thị tại đây',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[500],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
      Map<String, dynamic> notification, bool isUnread, int index) {
    final createdDate = DateTime.parse(notification['createdDate']);
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd/MM/yyyy');
    final notificationType = notification['notificationType'];
    void handleNavigation() async {
      // Xử lý đánh dấu đọc trước
      if (isUnread) {
        setState(() {
          _notifications[_notifications.indexWhere((element) =>
                  element['notificationId'] == notification['notificationId'])]
              ['status'] = 'Đã đọc';
        });
        try {
          await _markAsRead(notification['notificationId']);
        } catch (e) {
          setState(() {
            _notifications[_notifications.indexWhere((element) =>
                element['notificationId'] ==
                notification['notificationId'])]['status'] = 'Chưa đọc';
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đánh dấu đọc thất bại: ${e.toString()}'),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.red[700],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
          return;
        }
      }

      // Xử lý điều hướng dựa trên loại thông báo
      switch (notificationType.toLowerCase()) {
        case 'lịch gặp bác sĩ':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationMenu(
                keyIndex: 3,
              ),
            ),
          );
          break;

        case 'hủy lịch khám':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationMenu(
                keyIndex: 3,
              ),
            ),
          );
          break;

        case 'nhắc nhở uống thuốc':
          String data = notification['data'] ?? "";
          if (data.isEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeMedicine(),
              ),
            );
          } else {
            List<String> dataList = data.split("-");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeMedicine(
                  selectedYear: int.tryParse(dataList[0]),
                  selectedMonth: int.tryParse(dataList[1]),
                  selectedDay: int.tryParse(dataList[2]),
                ),
              ),
            );
          }
          break;

        case 'nhắc nhở uống nước':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WaterDrinking(),
            ),
          );
          break;

        case 'lịch trình hàng ngày':
          String data = notification['data'] ?? "";
          if (data.isEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScheduleScreen(),
              ),
            );
          } else {
            List<String> dataList = data.split("-");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScheduleScreen(
                  selectedYear: int.tryParse(dataList[0]),
                  selectedMonth: int.tryParse(dataList[1]),
                  selectedDay: int.tryParse(dataList[2]),
                ),
              ),
            );
          }
          break;

        case 'mua gói dịch vụ':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationMenu(
                keyIndex: 3,
              ),
            ),
          );
          break;

        case 'gửi yêu cầu hỗ trợ':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupFamily(),
            ),
          );
          break;

        case 'xác nhận hỗ trợ':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupFamily(),
            ),
          );
          break;

        case 'thêm vào gia đình':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupFamily(),
            ),
          );
          break;

        case 'thêm vào nhóm chat':
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationMenu(
                  keyIndex: 2,
                ),
              ));
          break;

        case 'kết bạn mới':
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationMenu(
                  keyIndex: 2,
                ),
              ));
          break;

        case 'cảnh báo sức khỏe':
          print(
              'Kiểu dữ liệu của notification["data"]: ${notification['data'].runtimeType}');

          Map<String, dynamic>? dataMap;

          // Nếu là String (chuỗi JSON)
          if (notification['data'] is String) {
            try {
              dataMap = json.decode(notification['data'] as String)
                  as Map<String, dynamic>;
            } catch (e) {
              print('Lỗi khi parse JSON: $e');
            }
          }
          // Nếu đã là Map
          else if (notification['data'] is Map) {
            dataMap = Map<String, dynamic>.from(notification['data'] as Map);
          }

          if (dataMap != null) {
            print('Giá trị Tabs: ${dataMap['Tabs']}');
            print('Giá trị Tabs: ${dataMap['Id']}');

            switch (dataMap['Tabs']) {
              case "HeartRate":
                // Navigate to NhịpTimCard
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddHeartBeatScreen(
                      id: dataMap?["Id"].toString(),
                      dataType: dataMap?["DataType"],
                      date: dataMap?['DateRecorded'],
                      currentValue:
                          num.tryParse(dataMap?["Indicator"] ?? "") ?? 0,
                      showHeartBeatWidget: true,
                      isDraft: false,
                      canEdit: false,
                    ),
                  ),
                );
                break;

              case "BloodPressure":
                String? data = dataMap['Indicator']; // Get the data
                String systolic = "N/A"; // Default value
                String diastolic = "N/A"; // Default value

                if (data != null && data.contains("/")) {
                  // Safely split the string
                  List<String> parts = data.split("/");
                  if (parts.length == 2) {
                    systolic = parts[0]; // First part
                    diastolic = parts[1]; // Second part
                  }
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBloodPressureScreen(
                      id: dataMap?["Id"].toString(),
                      dataType: dataMap?["DataType"],
                      date: dataMap?['DateRecorded'],
                      currentValueSystolic: num.tryParse(systolic) ?? 0,
                      currentValueDiastolic: num.tryParse(diastolic) ?? 0,
                      showBloodPressuretWidget: true,
                      isDraft: false,
                      canEdit: false,
                    ),
                  ),
                );
                break;

              case "BloodGlucose":
                String? data = dataMap['Indicator'];
                String bloodGlucoseValue = "N/A";
                String period = "N/A";
                if (data != null && data.contains("/")) {
                  // Safely split the string
                  List<String> parts = data.split("/");
                  if (parts.length == 2) {
                    bloodGlucoseValue = parts[0];
                    period = parts[1];
                  }
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBloodGlucoseScreen(
                      id: dataMap?["Id"].toString(),
                      dataType: dataMap?["DataType"],
                      date: dataMap?['DateRecorded'],
                      period: period,
                      currentBloodGlucoseValue:
                          double.tryParse(bloodGlucoseValue) ?? 0,
                      showBloodGlucoseWidget: true,
                      isDraft: false,
                      canEdit: false,
                    ),
                  ),
                );
                break;
              case "KidneyFunction":
                String? data = dataMap['Indicator'];
                String egfrValue = "N/A";
                String bunValue = "N/A";
                String gfrValue = "N/A";
                if (data != null && data.contains("/")) {
                  // Safely split the string
                  List<String> parts = data.split("/");
                  if (parts.length == 3) {
                    egfrValue = parts[0];
                    bunValue = parts[1];
                    gfrValue = parts[2];
                  }
                }
                // Navigate to ChieuCaoCard
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddKidneyFunctionScreen(
                      id: dataMap?["Id"].toString(),
                      dataType: dataMap?["DataType"],
                      date: dataMap?['DateRecorded'],
                      currentBUNValue: double.tryParse(bunValue) ?? 0,
                      currenteGFRValue: double.tryParse(egfrValue) ?? 0,
                      currentGFRValue: double.tryParse(gfrValue) ?? 0,
                      showKidneyFunctionWidget: true,
                      isDraft: false,
                      canEdit: false,
                    ),
                  ),
                );
                break;
              case "LipidProfile":
                String? data = dataMap['Indicator'];
                String total = "N/A";
                String hdl = "N/A";
                String ldl = "N/A";
                String tg = "N/A";
                if (data != null && data.contains("/")) {
                  // Safely split the string
                  List<String> parts = data.split("/");
                  if (parts.length == 4) {
                    total = parts[0];
                    ldl = parts[1];
                    hdl = parts[2];
                    tg = parts[3];
                  }
                }
                // Navigate to ChieuCaoCard
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddLipidProfileScreen(
                      id: dataMap?["Id"].toString(),
                      dataType: dataMap?["DataType"],
                      date: dataMap?['DateRecorded'],
                      currentHDLValue: double.tryParse(hdl) ?? 0,
                      currentLDLValue: double.tryParse(ldl) ?? 0,
                      currentTGValue: double.tryParse(tg) ?? 0,
                      currentTCValue: double.tryParse(total) ?? 0,
                      showLipidProfileWidget: true,
                      isDraft: false,
                      canEdit: false,
                    ),
                  ),
                );
                break;
              case "LiverEnzyme":
                String? data = dataMap['Indicator'];
                String alt = "N/A";
                String alp = "N/A";
                String ast = "N/A";
                String ggt = "N/A";
                if (data != null && data.contains("/")) {
                  // Safely split the string
                  List<String> parts = data.split("/");
                  if (parts.length == 4) {
                    alt = parts[0];
                    ast = parts[1];
                    alp = parts[2];
                    ggt = parts[3];
                  }
                }
                // Navigate to ChieuCaoCard
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddLiverEnzymesScreen(
                      id: dataMap?["Id"].toString(),
                      dataType: dataMap?["DataType"],
                      date: dataMap?['DateRecorded'],
                      currentALTValue: double.tryParse(alt) ?? 0,
                      currentALPValue: double.tryParse(alp) ?? 0,
                      currentASTValue: double.tryParse(ast) ?? 0,
                      currentGGTValue: double.tryParse(ggt) ?? 0,
                      showLiverEnzymesWidget: true,
                      isDraft: false,
                      canEdit: false,
                    ),
                  ),
                );
                break;
              case "BloodOxygen":
                // Navigate to NhịpTimCard
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBloodOxygen(
                      id: dataMap?["Id"].toString(),
                      dataType: dataMap?["DataType"],
                      date: dataMap?['DateRecorded'],
                      currentValue:
                          num.tryParse(dataMap?["Indicator"] ?? "") ?? 0,
                      showHeartBeatWidget: true,
                      isDraft: false,
                      canEdit: false,
                    ),
                  ),
                );
                break;
              // case "Buớc chân":
              //   // Navigate to NhịpTimCard
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => AddSteps(
              //             id: item["id"],
              //             dataType: item["dataType"],
              //             date: item['date'],
              //             currentValue: num.tryParse(item["data"] ?? "") ?? 0,
              //             showHeartBeatWidget: true,
              //             isDraft: false)),
              //   );
              //   break;
              // case "Thời gian ngủ":
              //   // Navigate to NhịpTimCard
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => AddSleep(
              //             id: item["id"],
              //             dataType: item["dataType"],
              //             date: item['date'],
              //             currentValue: num.tryParse(item["data"] ?? "") ?? 0,
              //             showHeartBeatWidget: true,
              //             isDraft: false)),
              //   );
              //   break;
              // case "Tiêu thụ calories":
              //   // Navigate to NhịpTimCard
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => AddCaloriesBurned(
              //             id: item["id"],
              //             dataType: item["dataType"],
              //             date: item['date'],
              //             currentValue: num.tryParse(item["data"] ?? "") ?? 0,
              //             showHeartBeatWidget: true,
              //             isDraft: false)),
              //   );
              //   break;

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => HealthAlertDetailScreen(
              //       alertId: notification['relatedId'],
              //     ),
              //   ),
              // );
              default:
                print("No card detail screen for ${notification['data']}");
                print("data ${notification['data']}");
                break;

              // case 'sos':
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => EmergencyDetailScreen(
              //         emergencyId: notification['relatedId'],
              //       ),
              //     ),
              //   );
              //   break;

              // Thêm các trường hợp khác tùy theo loại thông báo
            }
          } else {
            print('Dữ liệu không hợp lệ hoặc không thể phân tích');
          }
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isUnread ? Color.fromRGBO(246, 249, 255, 1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isUnread
                ? AppColors.textPrimary.withOpacity(0.15)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: handleNavigation,
          borderRadius: BorderRadius.circular(16),
          // onTap: () async {
          //   if (isUnread) {
          //     setState(() {
          //       _notifications[_notifications.indexWhere((element) =>
          //           element['notificationId'] ==
          //           notification['notificationId'])]['status'] = 'Đã đọc';
          //     });
          //     try {
          //       await _markAsRead(notification['notificationId']);
          //     } catch (e) {
          //       setState(() {
          //         _notifications[_notifications.indexWhere((element) =>
          //             element['notificationId'] ==
          //             notification['notificationId'])]['status'] = 'Chưa đọc';
          //       });
          //       if (mounted) {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(
          //             content: Text('Đánh dấu đọc thất bại: ${e.toString()}'),
          //             duration: const Duration(seconds: 2),
          //             backgroundColor: Colors.red[700],
          //             behavior: SnackBarBehavior.floating,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(10),
          //             ),
          //           ),
          //         );
          //       }
          //     }
          //   }
          // },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Icon
                _buildNotificationIcon(notificationType, isUnread),

                const SizedBox(width: 16),

                // Notification Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and unread indicator
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isUnread
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color:
                                    isUnread ? Colors.black : Colors.grey[800],
                                height: 1.4,
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Message
                      Text(
                        notification['message'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 10),

                      // Time and Date
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${timeFormat.format(createdDate)} • ${dateFormat.format(createdDate)}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String notificationType, bool isUnread) {
    final Color activeColor = isUnread
        ? AppColors.primaryColor
        : Colors.grey[400] ?? AppColors.primaryColor;
    final Color emergencyColor =
        isUnread ? Colors.red : Colors.grey[400] ?? AppColors.primaryColor;

    Color iconBgColor;
    Color iconColor;
    IconData iconData;

    switch (notificationType.toLowerCase()) {
      case 'lịch gặp bác sĩ':
        iconData = HugeIcons.strokeRoundedCalendar01;
        iconBgColor = Colors.blue[50]!;
        iconColor = Colors.blue[600]!;
        break;

      case 'nhắc nhở uống thuốc':
        iconData = HugeIcons.strokeRoundedGivePill;
        iconBgColor = Colors.purple[50]!;
        iconColor = Colors.purple[600]!;
        break;

      case 'nhắc nhở uống nước':
        iconData = HugeIcons.strokeRoundedWaterEnergy;
        iconBgColor = Colors.blue[50]!;
        iconColor = Colors.blue[600]!;
        break;

      case 'lịch trình hàng ngày':
        iconData = HugeIcons.strokeRoundedCalendar02;
        iconBgColor = Colors.green[50]!;
        iconColor = Colors.green[600]!;
        break;

      case 'hủy lịch khám':
        iconData = HugeIcons.strokeRoundedCalendarRemove01;
        iconBgColor = Colors.red[50]!;
        iconColor = Colors.red[600]!;
        break;

      case 'mua gói dịch vụ':
        iconData = HugeIcons.strokeRoundedPackage03;
        iconBgColor = Colors.orange[50]!;
        iconColor = Colors.orange[600]!;
        break;

      case 'gửi yêu cầu hỗ trợ':
        iconData = HugeIcons.strokeRoundedHelpCircle;
        iconBgColor = Colors.purple[50]!;
        iconColor = Colors.purple[600]!;
        break;

      case 'xác nhận hỗ trợ':
        iconData = HugeIcons.strokeRoundedCheckmarkCircle01;
        iconBgColor = Colors.green[50]!;
        iconColor = Colors.green[600]!;
        break;

      case 'thêm vào gia đình':
        iconData = HugeIcons.strokeRoundedUserGroup;
        iconBgColor = Colors.blue[50]!;
        iconColor = Colors.blue[600]!;
        break;

      case 'thêm vào nhóm chat':
        iconData = HugeIcons.strokeRoundedBubbleChatAdd;
        iconBgColor = Colors.teal[50]!;
        iconColor = Colors.teal[600]!;
        break;

      case 'kết bạn mới':
        iconData = HugeIcons.strokeRoundedUserAdd01;
        iconBgColor = Colors.indigo[50]!;
        iconColor = Colors.indigo[600]!;
        break;

      case 'cảnh báo sức khỏe':
        iconData = HugeIcons.strokeRoundedHealth;
        iconBgColor = Colors.red[50]!;
        iconColor = Colors.red[600]!;
        break;

      case 'sos':
        iconData = HugeIcons.strokeRoundedAmbulance;
        iconBgColor = Colors.red[50]!;
        iconColor = Colors.red[600]!;
        break;

      default:
        iconData = isUnread
            ? HugeIcons.strokeRoundedNotification01
            : HugeIcons.strokeRoundedNotification02;
        iconBgColor = AppColors.primaryColor.withOpacity(0.1);
        iconColor = AppColors.primaryColor;
        break;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: iconBgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: HugeIcon(
          icon: iconData,
          color: iconColor,
          size: 24,
        ),
      ),
    );
  }
}
