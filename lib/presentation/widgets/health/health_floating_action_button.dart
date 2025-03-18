import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sep490/presentation/pages/health/add_blood_glucose_screen.dart';
import 'package:sep490/presentation/pages/health/add_blood_pressure_screen.dart';
import 'package:sep490/features/heart_beat/screens/add_heart_beat_screen.dart';
import 'package:sep490/presentation/pages/health/add_height_screen.dart';
import 'package:sep490/presentation/pages/health/add_kidney_function_screen.dart';
import 'package:sep490/presentation/pages/health/add_lipid_profile_screen.dart';
import 'package:sep490/presentation/pages/health/add_liver_enzymes_screen.dart';
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
      spaceBetweenChildren: 0,
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
                  builder: (context) => AddBloodGlucoseScreen(
                        isDraft: true,
                        showBloodGlucoseWidget: false,
                        currentBloodGlucoseValue: 0,
                        period: "Thức dậy",
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
                        'assets/img3D/treatment_medical/tieuduong.png',
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
                            'Đường huyết',
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
                  builder: (context) => AddKidneyFunctionScreen(
                        isDraft: true,
                        showKidneyFunctionWidget: false,
                        currentBUNValue: 0,
                        currenteGFRValue: 0,
                        currentGFRValue: 0,
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
                        'assets/img3D/treatment_medical/than.png',
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
                            'Chức năng thận',
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
                  builder: (context) => AddLipidProfileScreen(
                        isDraft: true,
                        showLipidProfileWidget: false,
                        currentTCValue: 0,
                        currentTGValue: 0,
                        currentLDLValue: 0,
                        currentHDLValue: 0,
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
                        'assets/img3D/treatment_medical/momau.webp',
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
                            'Mỡ máu',
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
                  builder: (context) => AddLiverEnzymesScreen(
                        isDraft: true,
                        showLiverEnzymesWidget: false,
                        currentALTValue: 0,
                        currentALPValue: 0,
                        currentASTValue: 0,
                        currentGGTValue: 0,
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
                        'assets/img3D/treatment_medical/gan.png',
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
                            'Men gan',
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
      ],
    );
  }
}
