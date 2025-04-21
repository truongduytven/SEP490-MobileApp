import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/controllers/doctor_controller.dart';
import 'package:sep490/presentation/widgets/appointment/buildAppointmentCard.dart';
import 'package:sep490/presentation/widgets/appointment/buildAppointmentDoctor.dart';
import 'package:sep490/theme/color.dart';

class ReportAppointment extends StatefulWidget {
  final AppoimentDoctor? appoimentDoctor;
  final AppoimentElderly? appoimentElderly;
  final bool isEdited;
  const ReportAppointment(
      {super.key,
      this.appoimentDoctor,
      required this.isEdited,
      this.appoimentElderly});

  @override
  State<ReportAppointment> createState() => _ReportAppointmentState();
}

class _ReportAppointmentState extends State<ReportAppointment> {
  final TextEditingController summaryController = TextEditingController();
  final TextEditingController solutionController = TextEditingController();
  Report? _report;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    if (!widget.isEdited) {
      _getReport();
    }
  }

  Future<void> _getReport() async {
    setState(() {
      _isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController
        .getReportById(widget.appoimentDoctor!.professorAppointmentId);
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _report = doctorController.report!;
        _isLoading = false;
      });
    });
  }

  void handleSendReport() async {
    if (summaryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập báo cáo')),
      );
      return;
    }
    if (solutionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đề xuất giải pháp')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    DoctorController doctorController = DoctorController();

    await doctorController.reportDoctor(
        widget.appoimentElderly!.professorAppointmentId,
        summaryController.text,
        solutionController.text);

    Timer(const Duration(seconds: 1), () {
      if (doctorController.isRatingSuccess) {
        if (!mounted) return;
        CherryToast.success(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Gửi báo cáo thành công",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        Navigator.pop(context, true);
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Gửi báo cáo thất bại, vui lòng thử lại",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Báo cáo cuộc hẹn'),
            backgroundColor: Colors.white,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (widget.appoimentDoctor != null)
                  BuildAppointmentCard(
                    appoimentDoctor: widget.appoimentDoctor,
                    onCancel: () => Future.value(),
                    onJoin: () => Future.value(),
                    onReport: () => Future.value(),
                    isListCard: false,
                  ),
                if (widget.appoimentElderly != null)
                  BuildAppointmentDoctor(
                    appoimentDoctor: widget.appoimentElderly,
                    onCancel: () => Future.value(),
                    onJoin: () => Future.value(),
                    onReport: () => Future.value(),
                    isListCard: false,
                  ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (_report == null ||
                            (_report!.content.isEmpty &&
                                _report!.solution.isEmpty) ) && !widget.isEdited
                        ? Expanded(
                            child: Center(
                                child: Text(
                            'Hiện tại không có báo cáo',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600),
                          )))
                        : Expanded(
                            child: ListView(
                              children: [
                                Center(
                                    child: Text(
                                  'Báo cáo tổng kết',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                )),
                                _buildContentBox(summaryController,
                                    !widget.isEdited ? _report!.content : ''),
                                const SizedBox(height: 20),
                                Center(
                                    child: Text(
                                  'Đề xuất giải pháp',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                )),
                                _buildContentBox(
                                    solutionController,!widget.isEdited ? _report!.content : ''),
                                const SizedBox(height: 20),
                                if (widget.isEdited)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          handleSendReport();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.secondaryColor,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 30),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: Text('Gửi báo cáo',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
              ],
            ),
          )),
    );
  }

  Widget _buildContentBox(TextEditingController controller, String content) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grayColor1, width: 1),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        decoration: InputDecoration(
          hintText: content,
          hintStyle: TextStyle(
            color: AppColors.secondaryColor,
            fontSize: 22,
          ),
          enabled: widget.isEdited,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
