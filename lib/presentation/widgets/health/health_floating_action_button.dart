import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sep490/theme/color.dart';

class HealthFloatingActionButton extends StatelessWidget {
  final ValueNotifier<bool> isDialOpen;

  const HealthFloatingActionButton({Key? key, required this.isDialOpen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      elevation: 0,
      buttonSize: const Size(48, 48),
      animatedIcon: AnimatedIcons.menu_close,
      openCloseDial: isDialOpen,
      backgroundColor: AppColors.grayColor2,
      overlayColor: const Color.fromARGB(255, 73, 71, 71),
      overlayOpacity: 0.5,
      spacing: 5,
      foregroundColor: AppColors.secondaryColor,
      spaceBetweenChildren: 10,
      closeManually: true,
      direction: SpeedDialDirection.down,
      children: [
        _buildSpeedDialChild(
          'assets/img3D/nhiptim.png',
          'Nhịp tim',
          'Thêm chỉ số đo',
        ),
        _buildSpeedDialChild(
          'assets/img3D/huyetap.png',
          'Huyết áp',
          'Thêm chỉ số đo',
        ),
        _buildSpeedDialChild(
          'assets/img3D/thuoc.png',
          'Thuốc',
          'Thêm/Sửa thuốc',
        ),
        _buildSpeedDialChild(
          'assets/img3D/cannang.png',
          'Cân nặng',
          'Thêm chỉ số đo',
        ),
        _buildSpeedDialChild(
          'assets/img3D/chieucao.png',
          'Chiều cao',
          'Thêm chỉ số đo',
        ),
        _buildSpeedDialChild(
          'assets/img3D/ongnghe.png',
          'Lịch hẹn với bác sĩ',
          'Thêm/Sửa lịch hẹn',
        ),
      ],
    );
  }

  SpeedDialChild _buildSpeedDialChild(
      String imagePath, String title, String subtitle) {
    return SpeedDialChild(
      labelWidget: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, minWidth: 270),
        child: IntrinsicWidth(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    imagePath,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Text(subtitle),
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
}
