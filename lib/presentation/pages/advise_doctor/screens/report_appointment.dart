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
  final TextEditingController summaryController = TextEditingController();
  final TextEditingController solutionController = TextEditingController();
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
      if(!mounted) return;
      setState(() {
        _report = doctorController.report!;
        _isLoading = false;
      });
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
                BuildAppointmentCard(
                  appoimentDoctor: widget.appoimentDoctor,
                  onCancel: () => Future.value(),
                  onJoin: () => Future.value(),
                  onReport: () => Future.value(),
                  isListCard: false,
                ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _report == null
                        ? const Center(child: Text('Không có báo cáo'))
                        : Expanded(
                            child: ListView(
                              children: [
                                Center(child: Text('Báo cáo tổng kết', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),)),
                                _buildContentBox(summaryController, _report!.content),
                                const SizedBox(height: 20),
                                Center(child: Text('Đề xuất giải pháp', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),)),
                                _buildContentBox(solutionController, _report!.solution),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        decoration: InputDecoration(
          hintText: content,
          enabled: false,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
