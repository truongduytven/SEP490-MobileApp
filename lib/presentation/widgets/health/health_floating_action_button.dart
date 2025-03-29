import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sep490/presentation/pages/health/add_blood_pressure_screen.dart';
import 'package:sep490/presentation/pages/health/add_heart_beat_screen.dart';
import 'package:sep490/presentation/pages/health/add_height_screen.dart';
import 'package:sep490/presentation/pages/health/add_weight_screen.dart';
import 'package:sep490/presentation/pages/medicine/home_medicine.dart';
import 'package:sep490/theme/color.dart';

class HealthFloatingActionButton extends StatelessWidget {
  final ValueNotifier<bool> isDialOpen;

  const HealthFloatingActionButton({Key? key, required this.isDialOpen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      elevation: 0,
      buttonSize: const Size(40, 40),
      icon: Icons.add,
      activeIcon: Icons.close,
      // animatedIcon: AnimatedIcons.menu_close,
      openCloseDial: isDialOpen,
      backgroundColor: AppColors.grayColor2,
      overlayColor: AppColors.secondaryColor,
      overlayOpacity: 0.95,
      spacing: 5,
      foregroundColor: AppColors.secondaryColor,
      spaceBetweenChildren: 10,
      closeManually: true,
      direction: SpeedDialDirection.down,
      children: [
        // Manually create each SpeedDialChild
        SpeedDialChild(
          onTap: () {
            isDialOpen.value = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddHeartBeatScreen(
                        isDraft: true,
                        currentValue: 0,
                        showHeartBeatWidget: false,
                      )),
            );
          },
          labelWidget: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, minWidth: 270),
            child: IntrinsicWidth(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        'assets/img3D/nhiptim.png',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Nhịp tim',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Text('Thêm chỉ số đo'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SpeedDialChild(
          onTap: () {
            isDialOpen.value = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddBloodPressureScreen(
                        isDraft: true,
                        currentValueSystolic: 0,
                        currentValueDiastolic: 0,
                        showBloodPressuretWidget: false,
                      )),
            );
          },
          labelWidget: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, minWidth: 270),
            child: IntrinsicWidth(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        'assets/img3D/huyetap.png',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Huyết áp',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Text('Thêm chỉ số đo'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SpeedDialChild(
          onTap: () {
            isDialOpen.value = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeMedicine()),
            );
          },
          labelWidget: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, minWidth: 270),
            child: IntrinsicWidth(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        'assets/img3D/thuoc.png',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Thuốc',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Text('Thêm/Sửa thuốc'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SpeedDialChild(
          onTap: () {
            isDialOpen.value = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddWeight(
                        isDraft: true,
                        currentValue: 40,
                        showWeightWidget: false,
                      )),
            );
          },
          labelWidget: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, minWidth: 270),
            child: IntrinsicWidth(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        'assets/img3D/cannang.png',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Cân nặng',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Text('Thêm chỉ số đo'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SpeedDialChild(
          onTap: () {
            isDialOpen.value = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddHeightScreen(
                        isDraft: true,
                        currentValue: 170.0,
                        showHeightWidget: false,
                      )),
            );
          },
          labelWidget: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, minWidth: 270),
            child: IntrinsicWidth(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        'assets/img3D/chieucao.png',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Chiều cao',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Text('Thêm chỉ số đo'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SpeedDialChild(
          labelWidget: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, minWidth: 270),
            child: IntrinsicWidth(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        'assets/img3D/ongnghe.png',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Lịch hẹn với bác sĩ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Text('Thêm/Sửa lịch hẹn'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
