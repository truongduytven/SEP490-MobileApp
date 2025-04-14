import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/controllers/doctor_controller.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/doctor_detail.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/filter_doctor.dart';
import 'package:sep490/theme/color.dart';

class DoctorList extends StatefulWidget {
  final bool isChoosePackage;
  final ComboData? comboData;
  const DoctorList({super.key, required this.isChoosePackage, this.comboData});

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  List<String> filterEnter = [];
  bool isLoading = false;
  // ignore: avoid_init_to_null
  List<FilteredDoctor>? listFilterDoctor = null;

  @override
  void initState() {
    super.initState();
    filterEnter = [];
    getFilterDoctor();
  }

  void getFilterDoctor() async {
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.getFilterDoctor(filterEnter);
    Timer(Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        listFilterDoctor = doctorController.listFilterDoctor;
        isLoading = false;
      });
    });
  }

  void handleDeleteFilter(String filter) {
    setState(() {
      filterEnter.remove(filter);
    });
    getFilterDoctor();
  }

  void handleClickFilter(BuildContext context) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FilterDoctor(listFilter: List<String>.from(filterEnter));
    }));
    // ignore: unnecessary_null_comparison
    if (result != null) {
      if (!listEquals(result, filterEnter)) {
        setState(() {
          filterEnter = List<String>.from(result);
        });
        getFilterDoctor();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Danh sách bác sĩ",
            style: TextStyle(
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 25)),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                handleClickFilter(context);
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                ...filterEnter.map(
                  (e) => GestureDetector(
                    onTap: () {
                      handleDeleteFilter(e);
                    },
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Chip(
                          label: Text("$e  x",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryColor,
                                  fontWeight: FontWeight.w600)),
                        )),
                  ),
                )
              ],
            ),
            Expanded(
              child: isLoading
                  ? Center(
                      child: GifView.asset(
                        'assets/gif/sos_loading.gif',
                        width: 100,
                        height: 100,
                        frameRate: 60,
                      ),
                    )
                  : listFilterDoctor != null
                      ? SingleChildScrollView(
                          child: Column(
                            children: [
                              ...listFilterDoctor!.map((doctor) {
                                return buildDoctorCard(doctor);
                              })
                            ],
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/img/no-data.png',
                                  width: 100, height: 100),
                              SizedBox(height: 10),
                              Text('Không có bác sĩ nào phù hợp với bộ lọc',
                                  style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDoctorCard(FilteredDoctor doctor) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) {
        return DoctorDetail(
            doctorId: doctor.professorId,
            isChoosePackage: widget.isChoosePackage,
            comboData: widget.isChoosePackage ? widget.comboData : null,
            );
      })),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        doctor.professorAvatar,
                        width: 90,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BS. ${doctor.professorName}',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor),
                          ),
                          Text(
                            doctor.major,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.grayColor3,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              Text('T2-T6 (07:00 - 19:00)',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.grayColor3,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(Icons.star, color: Colors.yellow.shade600),
                              SizedBox(width: 4),
                              Text(
                                doctor.rating.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.grayColor3,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "(${doctor.totalRating} đánh giá)",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.grayColor3,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Xem chi tiết',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.secondaryColor,
                                      fontWeight: FontWeight.w600)),
                              Icon(
                                Icons.arrow_forward,
                                color: AppColors.secondaryColor,
                                size: 15,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
