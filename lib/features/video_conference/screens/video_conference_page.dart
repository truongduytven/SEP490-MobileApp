import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:sep490/common/constants/common.dart';
import 'package:sep490/common/constants/secrets.example.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoConferencePage extends StatefulWidget {
  final String conferenceID;

  const VideoConferencePage({
    Key? key,
    required this.conferenceID,
  }) : super(key: key);

  @override
  State<VideoConferencePage> createState() => _VideoConferencePageState();
}

class _VideoConferencePageState extends State<VideoConferencePage> {
  void _setupUserListener() {
    ZegoUIKit().getUserListStream().listen((users) {
      // Lấy danh sách ID người dùng từ Zego và chuyển sang int
      final participantIds =
          users.map((user) => int.tryParse(user.id) ?? -1).toList();
      print('Danh sách ID người tham gia: $participantIds');

      // Gọi API với danh sách ID
      _checkMeetingConfirmation(participantIds);
    });
  }

  bool _isMounted = false; // Thêm biến cờ kiểm tra mounted state

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _setupUserListener();
  }

  @override
  void dispose() {
    _isMounted = false; // Đánh dấu widget đã bị dispose
    super.dispose();
  }

  Future<void> _checkMeetingConfirmation(List<int> participantIds) async {
    try {
      final response = await http.put(
        Uri.parse(
            'https://api.diavan-valuation.asia/api/Professor/confirmation?appoinmentId=${widget.conferenceID}'),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(participantIds),
      );

      final result = jsonDecode(response.body);

      // Kiểm tra mounted trước khi show toast
      if (!_isMounted) return;

      if (result['status'] == 1) {
        _showSuccessToast();
      } else if (result['status'] == 2) {
        _showWaitingToast();
      } else {
        _showErrorToast(result['message'] ?? 'Có lỗi xảy ra');
      }
    } catch (e) {
      if (_isMounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi kết nối: $e')),
        );
      }
    }
  }

  void _showSuccessToast() {
    if (!_isMounted) return;

    CherryToast.success(
      toastDuration: const Duration(seconds: 5),
      title: Text(
        "Cuộc tư vấn đã sẵn sàng!",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
      ),
      description: Text(
        "Tất cả thành viên đã tham gia. Chúc buổi tư vấn đạt hiệu quả tốt nhất!",
        style: TextStyle(
          fontSize: 15,
          height: 1.4,
        ),
      ),
    ).show(context);
  }

  void _showWaitingToast() {
    if (!_isMounted) return;

    CherryToast.info(
      toastDuration: const Duration(seconds: 5),
      title: Text(
        "Đang chờ thành viên...",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
      ),
      description: Text(
        "Hệ thống đang chờ các thành viên khác tham gia.\nChúng tôi sẽ thông báo ngay khi cuộc tư vấn bắt đầu!",
        style: TextStyle(
          fontSize: 15,
          height: 1.4,
        ),
      ),
    ).show(context);
  }

  void _showErrorToast(String message) {
    if (!_isMounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
    final currentUserAccountID = sharedPrefsHelper.getInt("accountId") ?? 0;
    final currentUserName =
        sharedPrefsHelper.getString('fullName') ?? "Không xác định";
    final avatar = sharedPrefsHelper.getString('avatar') ?? "Không xác định";

    // ZegoUIKit().getUserListStream().listen((users) {
    //   final count = users.length;
    //   print('==== DANH SÁCH NGƯỜI THAM GIA ====');
    //   print('Tổng số: $count người');
    //   for (var user in users) {
    //     print('ID: ${user.id} | Tên: ${user.name}');
    //   }
    //   print('===============================');
    // });
    return SafeArea(
      child: SafeArea(
        child: ZegoUIKitPrebuiltVideoConference(
          appID: AppSecretsVideoConference.appId,
          appSign: AppSecretsVideoConference.appSign,
          userID: currentUserAccountID.toString(),
          userName: currentUserName,
          conferenceID: widget.conferenceID,
          events: ZegoUIKitPrebuiltVideoConferenceEvents(
            duration: ZegoVideoConferenceDurationEvents(
              onUpdated: (Duration d) {
                if (d.inSeconds == 60 * 60) {
                  ZegoUIKitPrebuiltVideoConferenceController()
                      .room
                      .leave(context);
                }
              },
            ),
          ),
          config: ZegoUIKitPrebuiltVideoConferenceConfig(
            avatarBuilder: (context, size, user, extraInfo) {
              return customAvatarBuilder(
                context,
                size,
                user,
                {'avatar': avatar},
              );
            },
            topMenuBarConfig: ZegoTopMenuBarConfig(
              title: "Cuộc họp của bạn",
            ),
            onLeaveConfirmation: (BuildContext context) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Rời khỏi cuộc họp"),
                    content:
                        const Text("Bạn có chắc chắn muốn rời khỏi cuộc họp?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Hủy"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Rời khỏi"),
                      ),
                    ],
                  );
                },
              );
            },
            onLeave: () {
              Navigator.of(context).pop();
            },
            memberListConfig: ZegoMemberListConfig(
              showMicrophoneState: true,
              showCameraState: true,
            ),
          ),
        ),
      ),
    );
  }
}
