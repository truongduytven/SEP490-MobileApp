import 'package:flutter/material.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/widgets/appointment/_infoChip.dart';
import 'package:sep490/theme/color.dart';
import 'package:sep490/theme/colors_game.dart';

class BuildAppointmentCard extends StatefulWidget {
  final AppoimentDoctor? appoimentDoctor;
  final Future<void> Function() onCancel;
  final Future<void> Function() onJoin;
  final Future<void> Function() onReport;
  final bool isListCard;
  
  const BuildAppointmentCard({super.key, required this.appoimentDoctor, required this.onCancel, required this.onJoin, required this.onReport, this.isListCard = false});

  @override
  State<BuildAppointmentCard> createState() => BuildAppointmentCardState();
}

class BuildAppointmentCardState extends State<BuildAppointmentCard> {
  late String time;
  late String date;

  @override
  void initState() {
    super.initState();
    time = widget.appoimentDoctor!.dateTime.split(' ')[1];
    date = widget.appoimentDoctor!.dateTime.split(' ')[0];
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
                    Text('⏰ $time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.secondaryColor),),
                    const SizedBox(width: 8),
                    Text('📅 $date', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.secondaryColor),),
                  ],
                ),
                Text(
                  widget.appoimentDoctor!.status == 'NotYet' ? '• Chưa tham gia' : widget.appoimentDoctor!.status == 'Joined' ? '• Đã tham gia' : '• Đã hủy',
                  style: TextStyle(
                    fontSize: 18,
                    color: widget.appoimentDoctor!.status == 'NotYet' ? AppColors.primaryColor : widget.appoimentDoctor!.status == 'Joined' ? Colors.green : Colors.red,
                  ),
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
                          widget.appoimentDoctor!.isOnline ? "Online" : "Offline",
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
            if(widget.isListCard)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.appoimentDoctor!.status == 'NotYet')
                  ElevatedButton(onPressed: () {}, child: Text('Hủy lịch hẹn')),
                if (widget.appoimentDoctor!.status == 'Joined')
                  ElevatedButton(onPressed: widget.onReport, child: Text('Báo cáo')),
                if (widget.appoimentDoctor!.status == 'Cancelled')
                  ElevatedButton(onPressed: () {}, child: Text('Đặt lịch hẹn'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
