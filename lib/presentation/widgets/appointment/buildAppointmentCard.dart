import 'package:flutter/material.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/video_conference/screens/video_conference_page.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/rating_doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/report_appointment.dart';
import 'package:sep490/theme/color.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class BuildAppointmentCard extends StatefulWidget {
  final AppoimentDoctor? appoimentDoctor;
  final Future<void> Function() onCancel;
  final Future<void> Function() onJoin;
  final Future<void> Function() onReport;
  final bool isListCard;

  const BuildAppointmentCard(
      {super.key,
      required this.appoimentDoctor,
      required this.onCancel,
      required this.onJoin,
      required this.onReport,
      this.isListCard = false});

  @override
  State<BuildAppointmentCard> createState() => BuildAppointmentCardState();
}

class BuildAppointmentCardState extends State<BuildAppointmentCard> {
  late String time;
  late String date;
  late bool isAllowed;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int roleId;

  @override
  void initState() {
    super.initState();
    time = widget.appoimentDoctor!.dateTime.split(' ')[1];
    date = widget.appoimentDoctor!.dateTime.split(' ')[0];
    isAllowed = isJoinAllowed;
    roleId = sharedPrefsHelper.getInt('roleId') ?? 0;
    if (isJoinAllowed) {
      sharedPrefsHelper.setString('appoinmentId',
          widget.appoimentDoctor!.professorAppointmentId.toString());
    }
  }

  String _formatDateTime(String input) {
    // From: "09/04/2025 15:00"
    final parts = input.split(' ');
    final dateParts = parts[0].split('/');
    final timePart = parts[1];

    // Format to ISO string: "2025-04-09T15:00:00"
    return "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}T$timePart:00";
  }

  bool get isJoinAllowed {
    // Combine date and time into full string like "09/04/2025 15:00"
    final fullDateTimeStr = "${date.trim()} ${time.trim()}";

    // Parse the string into DateTime
    final appointmentTime = DateTime.parse(
      _formatDateTime(fullDateTimeStr),
    );

    // Get current time
    final now = DateTime.now();

    // Check if current time is within 5 minutes before or later
    return now.isAfter(appointmentTime.subtract(Duration(minutes: 5)));
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
                      '📅 $date',
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
                    widget.appoimentDoctor!.professorAvatar,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Bác sĩ: ",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          widget.appoimentDoctor!.professorName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "Hình thức: ",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                        Text(
                          widget.appoimentDoctor!.isOnline
                              ? "Online"
                              : "Offline",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
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
            if (widget.isListCard)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  children: [
                    // Button 1: Cancel Appointment
                    if (widget.appoimentDoctor!.status == 'NotYet')
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: widget.onCancel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.bgColor,
                            side: BorderSide(color: AppColors.secondaryColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Hủy lịch',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.secondaryColor)),
                              const SizedBox(width: 4),
                              Icon(Icons.cancel,
                                  size: 20, color: AppColors.secondaryColor),
                            ],
                          ),
                        ),
                      ),

                    // Button 2: Join Call
                    if (widget.appoimentDoctor!.status == 'NotYet')
                      SizedBox(
                        width: 150,
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
                            backgroundColor: AppColors.bgColor,
                            side: BorderSide(color: AppColors.primaryColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Tham gia',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.primaryColor)),
                              const SizedBox(width: 4),
                              Icon(Icons.video_call,
                                  size: 20, color: AppColors.primaryColor),
                            ],
                          ),
                        ),
                      ),

                    // Button 3: Rate Doctor
                    if (widget.appoimentDoctor!.status == 'NotYet' &&
                        !widget.appoimentDoctor!.isFeedback)
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RatingDoctor(
                                  appoimentDoctor: widget.appoimentDoctor,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.bgColor,
                            side: BorderSide(color: AppColors.primaryColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Đánh giá',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.primaryColor)),
                              const SizedBox(width: 4),
                              Icon(Icons.star,
                                  size: 20, color: AppColors.primaryColor),
                            ],
                          ),
                        ),
                      ),

                    // Button 4: View Report
                    if (widget.appoimentDoctor!.status == 'Joined' &&
                        widget.appoimentDoctor!.isReport)
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: widget.onReport,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Báo cáo',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              const SizedBox(width: 4),
                              Icon(Icons.assignment,
                                  size: 20, color: Colors.white),
                            ],
                          ),
                        ),
                      ),

                    // Button 5: Create Report (for doctors)
                    if (widget.appoimentDoctor!.status == 'Joined' &&
                        widget.appoimentDoctor!.isReport &&
                        roleId == 4)
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportAppointment(
                                    appoimentDoctor: widget.appoimentDoctor,
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
                                      fontSize: 16, color: Colors.white)),
                              const SizedBox(width: 4),
                              Icon(Icons.edit, size: 20, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                  ],
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
