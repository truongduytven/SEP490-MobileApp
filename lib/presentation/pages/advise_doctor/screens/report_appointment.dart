import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/controllers/doctor_controller.dart';
import 'package:sep490/presentation/widgets/appointment/buildAppointmentCard.dart';

class ReportAppointment extends StatefulWidget {
  final AppoimentDoctor? appoimentDoctor;
  const ReportAppointment({super.key, required this.appoimentDoctor});

  @override
  State<ReportAppointment> createState() => _ReportAppointmentState();
}

class _ReportAppointmentState extends State<ReportAppointment> {
  Report? _report;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _getReport();
  }

  Future<void> _getReport() async {
    setState(() {
      _isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController
        .getReportById(widget.appoimentDoctor!.professorAppointmentId);
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _report = doctorController.report!;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Báo cáo cuộc hẹn'),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Column(
          children: [
            BuildAppointmentCard(appoimentDoctor: widget.appoimentDoctor, onCancel: () => Future.value(), onJoin: () => Future.value(), onReport: () => Future.value(), isListCard: false,),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _report == null
                    ? const Center(child: Text('Không có báo cáo'))
                    : ListView(
                        children: [
                          ListTile(
                            title: const Text('Nội dung báo cáo'),
                            subtitle: Text(_report!.content),
                          ),
                          ListTile(
                            title: const Text('Giải pháp'),
                            subtitle: Text(_report!.solution),
                          ),
                        ],
                      ),
          ],
        ));
  }
}
