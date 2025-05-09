import 'package:flutter/material.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/health/screens/health_screen.dart';
import 'package:sep490/features/video_conference/screens/video_conference_page.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/report_appointment.dart';
import 'package:sep490/presentation/pages/home/view_detail_elderly.dart';
import 'package:sep490/theme/color.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class BuildAppointmentDoctor extends StatefulWidget {
  final AppoimentElderly? appoimentDoctor;
  final Future<void> Function() onCancel;
  final Future<void> Function() onJoin;
  final Future<void> Function() onReport;
  final bool isListCard;

  const BuildAppointmentDoctor(
      {super.key,
      required this.appoimentDoctor,
      required this.onCancel,
      required this.onJoin,
      required this.onReport,
      this.isListCard = false});

  @override
  State<BuildAppointmentDoctor> createState() => BuildAppointmentDoctorState();
}

class BuildAppointmentDoctorState extends State<BuildAppointmentDoctor> {
  late String time;
  late String date;
  late bool isAllowed;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int roleId;

  @override
  void initState() {
    super.initState();
    print(widget.appoimentDoctor);
    time = widget.appoimentDoctor!.dateTime.split(' ')[1];
    date = widget.appoimentDoctor!.dateTime.split(' ')[0];
    roleId = sharedPrefsHelper.getInt('roleId') ?? 0;
  }

  String _formatDateTime(String input) {
    // From: "09/04/2025 15:00"
    final parts = input.split(' ');
    final dateParts = parts[0].split('/');
    final timePart = parts[1];
    final hourPart = timePart.split(':')[0];
    final minutePart = timePart.split(':')[1];
    String hourData = (int.tryParse(hourPart) ?? 0 + 1).toString();
    if ((int.tryParse(hourPart) ?? 0 + 1) < 10) {
      hourData = '0$hourData';
    }

    // Format to ISO string: "2025-04-09T15:00:00"
    return "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}T$hourData:$minutePart:00";
  }

  bool get isCancelAllowed {
    final fullDateTimeStr = "${date.trim()} ${time.trim()}";
    final appointmentTime = DateTime.parse(_formatDateTime(fullDateTimeStr));
    final now = DateTime.now();

    // Check if current time is at least 6 hours before appointment
    return now.isBefore(appointmentTime.subtract(const Duration(hours: 6)));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.grayColor2)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '⏰ $time',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryColor),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      date,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryColor),
                    ),
                  ],
                ),
                Text(
                  widget.appoimentDoctor!.status == 'NotYet'
                      ? '• Chưa tham gia'
                      : widget.appoimentDoctor!.status == 'Joined'
                          ? '• Đã tham gia'
                          : '• Đã hủy',
                  style: TextStyle(
                      fontSize: 18,
                      color: widget.appoimentDoctor!.status == 'NotYet'
                          ? Colors.blue
                          : widget.appoimentDoctor!.status == 'Joined'
                              ? Colors.green
                              : Colors.red,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.appoimentDoctor!.avatar,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        widget.appoimentDoctor!.elderlyName,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        widget.appoimentDoctor!.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    sharedPrefsHelper.setInt("selectedElderlyUserId",
                        widget.appoimentDoctor!.accountId);
                    sharedPrefsHelper.setString("selectedElderlyUserName",
                        widget.appoimentDoctor!.elderlyName);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewDetailElderly(elderlyId: widget.appoimentDoctor!.accountId,),
                      ),
                    );
                  },
                  child: Icon(Icons.info_outline,
                      color: AppColors.primaryColor, size: 30),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (widget.appoimentDoctor!.status == 'NotYet')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Bạn có thể tham gia khi đúng thời gian buổi hẹn",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoConferencePage(
                        conferenceID: widget
                            .appoimentDoctor!.professorAppointmentId
                            .toString(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  side: BorderSide(color: AppColors.primaryColor),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Tham gia',
                        style:
                            TextStyle(fontSize: 22, color: AppColors.bgColor)),
                    const SizedBox(width: 4),
                    Icon(Icons.video_call, size: 25, color: AppColors.bgColor),
                  ],
                ),
              ),
            ),
            if (widget.isListCard)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 10),
                child: Container(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 8,
                    alignment: WrapAlignment.start,
                    children: [
                      if (widget.appoimentDoctor!.status == 'NotYet' &&
                          isCancelAllowed)
                        ElevatedButton(
                          onPressed: widget.onCancel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.bgColor,
                            side: BorderSide(color: AppColors.secondaryColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Hủy lịch hẹn',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.secondaryColor)),
                              const SizedBox(width: 8),
                              Icon(Icons.cancel,
                                  color: AppColors.secondaryColor),
                            ],
                          ),
                        ),
                      if (widget.appoimentDoctor!.status == 'Joined' &&
                          !widget.appoimentDoctor!.isReport &&
                          roleId == 4)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportAppointment(
                                    appoimentElderly: widget.appoimentDoctor,
                                    isEdited: true),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Tạo báo cáo',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                              const SizedBox(width: 8),
                              Icon(Icons.assignment, color: Colors.white),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget sendCallButton({
    required bool isVideoCall,
    required List<Account> inviteeUsers,
    void Function(String code, String message, List<String>)? onCallFinished,
  }) {
    // Convert List<User> to List<ZegoUIKitUser>
    List<ZegoUIKitUser> invitees = inviteeUsers.map((user) {
      return ZegoUIKitUser(
        id: user.id.toString(), // Ensure ID is a string
        name: user.name,
      );
    }).toList();

    return ZegoSendCallInvitationButton(
      isVideoCall: isVideoCall,
      invitees: invitees,
      resourceID: 'zego_data',
      iconSize: const Size(20, 20),
      buttonSize: const Size(30, 30),
      onPressed: isAllowed ? onCallFinished : null,
      icon: ButtonIcon(
        icon: isVideoCall
            ? Icon(Icons.video_call, color: AppColors.primaryColor)
            : Icon(Icons.phone, color: AppColors.primaryColor),
      ),
    );
  }

  void onSendCallInvitationFinished(
    String code,
    String message,
    List<String> errorInvitees,
  ) {
    if (errorInvitees.isNotEmpty) {
      var userIDs = errorInvitees.take(5).join(' ');
      var errorMessage = "User doesn't exist or is offline: $userIDs";

      if (code.isNotEmpty) {
        errorMessage += ', code: $code, message:$message';
      }

      debugPrint(errorMessage);
    } else if (code.isNotEmpty) {
      debugPrint('Call failed: code: $code, message:$message');
    }
  }
}
