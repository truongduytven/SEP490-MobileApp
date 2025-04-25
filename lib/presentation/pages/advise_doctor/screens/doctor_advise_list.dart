import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:intl/intl.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/main.dart';
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

class _DoctorAdviseListState extends State<DoctorAdviseList>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver, RouteAware {
  List<AppoimentElderly>? listAppoimentElderly;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int accountId = 0;
  late bool isLoading = false;
  Map<String, String> statusOptions = {
    "Tất cả": "All",
    "Chưa tham gia": "NotYet",
    "Đã tham gia": "Joined",
    "Đã hủy": "Cancelled",
  };
  String selectedStatus = "All";
  @override
  void initState() {
    super.initState();
    accountId = sharedPrefsHelper.getInt('accountId') ?? 0;
    getAppointmentElderly(selectedStatus);
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> getAppointmentElderly(String status) async {
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.getAppointmentElderly(accountId, status);
    Timer(Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        listAppoimentElderly = doctorController.appoimentElderly;
        if (listAppoimentElderly != null) {
          listAppoimentElderly!.sort((a, b) {
            final dateA = DateFormat("dd/MM/yyyy HH:mm").parse(a.dateTime);
            final dateB = DateFormat("dd/MM/yyyy HH:mm").parse(b.dateTime);
            return dateA.compareTo(dateB); // ascending
          });
        }
        isLoading = false;
      });
    });
  }

  void cancelAppointment(int appointmentId) async {
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.cancelAppointment(appointmentId, accountId);
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
        getAppointmentElderly(selectedStatus);
        setState(() {
          isLoading = false;
        });
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            doctorController.errorMessage.isEmpty
                ? "Có lỗi xảy ra"
                : doctorController.errorMessage,
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Đăng ký RouteAware để theo dõi sự kiện navigation
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      // Kiểm tra xem route có phải là PageRoute không
      routeObserver.subscribe(
          this,
          // ignore: unnecessary_cast
          route as PageRoute<dynamic>); // Ép kiểu thành PageRoute<dynamic>
    }
  }

  @override
  void didPopNext() {
    getAppointmentElderly(selectedStatus); // Gọi lại API
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
                  ? Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0),
                            border: Border.all(
                                color: AppColors.grayColor1, width: 1),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedStatus,
                              onChanged: (String? newValue) {
                                if (selectedStatus == newValue) return;
                                setState(() {
                                  selectedStatus = newValue!;
                                  getAppointmentElderly(newValue);
                                });
                              },
                              items: statusOptions.entries
                                  .map<DropdownMenuItem<String>>((entry) {
                                return DropdownMenuItem<String>(
                                  value: entry.value,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        entry.key,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      if (selectedStatus == entry.value)
                                        Icon(
                                          Icons.check,
                                          color: AppColors.primaryColor,
                                          size: 30,
                                        ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              selectedItemBuilder: (context) {
                                return statusOptions.entries
                                    .map<Widget>((entry) => Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(entry.key,
                                                style: TextStyle(fontSize: 18)),
                                          ],
                                        ))
                                    .toList();
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ...listAppoimentElderly!
                                      .map((item) => BuildAppointmentDoctor(
                                            appoimentDoctor: item,
                                            onCancel: () async => {
                                              cancelAppointment(
                                                  item.professorAppointmentId)
                                            },
                                            onJoin: () => Future.value(),
                                            onReport: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReportAppointment(
                                                          appoimentElderly:
                                                              item,
                                                          isEdited: false,
                                                        ))),
                                            isListCard: true,
                                          ))
                                ]),
                          ),
                        ),
                      ],
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
