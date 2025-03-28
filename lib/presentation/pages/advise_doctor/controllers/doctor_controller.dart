import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/repositories/doctor_repository.dart';

class DoctorController {
  final DoctorRepository _doctorRepository = DoctorRepository();
  DoctorData? doctorData;
  List<AppoimentDoctor>? appoimentDoctor;
  List<TimeSlots>? listAppoimentDoctor;
  Report? report;
  List<FilteredDoctor>? listFilterDoctor;

  Future<void> getDoctorData(int accountId) async {
    final response = await _doctorRepository.getDoctorDataById(accountId);
    if (response != null && response['isSuccess']) {
      doctorData = DoctorData.fromJson(response['data']['data']);
    } else {
      doctorData = null;
    }
  }

  Future<void> getDoctorDetails(int accountId) async {
    final response = await _doctorRepository.getDoctorDetails(accountId);
    if (response != null && response['isSuccess']) {
      doctorData = DoctorData.fromJson(response['data']['data']);
    } else {
      doctorData = null;
    }
  }

  Future<void> getAppointmentByID(int accountId, String type) async {
    final response = await _doctorRepository.getAppointmentByID(accountId, type);
    if (response != null && response['isSuccess']) {
      List<dynamic> data = response['data']['data'];
      appoimentDoctor = data.map((item) => AppoimentDoctor.fromJson(item)).toList();
    } else {
      appoimentDoctor = null;
    }
  }

  Future<void> getReportById(int appointmentId) async {
    final response = await _doctorRepository.getReportById(appointmentId);
    if (response != null && response['isSuccess']) {
      report = Report.fromJson(response['data']['data']);
    } else {
      report = null;
    }
  }

  Future<void> getTimeSlot(int accountId, String date) async {
    final response = await _doctorRepository.getTimeSlotById(accountId, date);
    if (response != null && response['isSuccess']) {
      List<dynamic> data = response['data']['data']['timeEachSlots'];
      if(data.isEmpty) {
        listAppoimentDoctor = null;
        return;
      }
      listAppoimentDoctor = data.map((item) => TimeSlots.fromJson(item)).toList();
    } else {
      listAppoimentDoctor = null;
    }
  }

  Future<void> getFilterDoctor(List<String> filterEnter) async {
    final response = await _doctorRepository.getFilterDoctor(filterEnter);
    if (response != null && response['isSuccess']) {
      List<dynamic> data = response['data']['data'];
      if(data.isEmpty) {
        listFilterDoctor = null;
        return;
      }
      listFilterDoctor = data.map((item) => FilteredDoctor.fromJson(item)).toList();
    } else {
      listFilterDoctor = null;
    }
  }
}
