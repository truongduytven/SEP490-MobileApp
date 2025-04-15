import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/controllers/doctor_controller.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/report_appointment.dart';
import 'package:sep490/presentation/widgets/appointment/buildAppointmentDoctor.dart';
import 'package:sep490/theme/color.dart';

class DoctorAdviseList extends StatefulWidget {
  const DoctorAdviseList({super.key});

  @override
  State<DoctorAdviseList> createState() => _DoctorAdviseListState();
}

class _DoctorAdviseListState extends State<DoctorAdviseList> {
  List<AppoimentElderly>? listAppoimentElderly;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int accountId = 0;
  late bool isLoading = false;

  @override
  void initState() {
    super.initState();
    accountId = sharedPrefsHelper.getInt('accountId') ?? 0;
    getAppointmentElderly();
  }

  Future<void> getAppointmentElderly() async {
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.getAppointmentElderly(accountId);
    Timer(Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        listAppoimentElderly = doctorController.appoimentElderly;
        isLoading = false;
      });
    });
  }

  void cancelAppointment(int appointmentId) async {
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.cancelAppointment(appointmentId);
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (doctorController.isCancelSuccess) {
        CherryToast.success(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Hủy cuộc hẹn thành công",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        getAppointmentElderly();
        setState(() {
          isLoading = false;
        });
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Hủy cuộc hẹn thất bại",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          title: const Text(
            'Danh sách tư vấn',
            style: TextStyle(
                color: AppColors.secondaryColor,
                fontSize: 25,
                fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: AppColors.bgColor,
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/background_app.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: isLoading
              ? Center(
                  child: GifView.asset(
                    'assets/gif/sos_loading.gif',
                    width: 100,
                    height: 100,
                    frameRate: 60,
                  ),
                )
              : (listAppoimentElderly != null &&
                      listAppoimentElderly!.isNotEmpty)
                  ? Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: listAppoimentElderly!
                              .map((item) => BuildAppointmentDoctor(
                                    appoimentDoctor: item,
                                    onCancel: () async =>
                                        {cancelAppointment(11)},
                                    onJoin: () => Future.value(),
                                    onReport: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ReportAppointment(
                                                  appoimentElderly: item,
                                                  isEdited: false,
                                                ))),
                                    isListCard: true,
                                  ))
                              .toList(),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/img/no-data.png',
                              width: 70, height: 70),
                          SizedBox(height: 10),
                          Text('Không có dữ liệu',
                              style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
        ));
  }
}
