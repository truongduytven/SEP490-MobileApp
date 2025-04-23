import 'package:flutter/material.dart';
import 'package:sep490/common/constants/common.dart';
import 'package:sep490/common/constants/secrets.example.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

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
  @override
  Widget build(BuildContext context) {
    SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
    final currentUserAccountID = sharedPrefsHelper.getInt("accountId") ?? 0;
    final currentUserName =
        sharedPrefsHelper.getString('fullName') ?? "Không xác định";
    final avatar = sharedPrefsHelper.getString('avatar') ?? "Không xác định";

    ZegoUIKit().getUserListStream().listen((users) {
      final count = users.length;
      print('==== DANH SÁCH NGƯỜI THAM GIA ====');
      print('Tổng số: $count người');
      for (var user in users) {
        print('ID: ${user.id} | Tên: ${user.name}');
      }
      print('===============================');
    });
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
