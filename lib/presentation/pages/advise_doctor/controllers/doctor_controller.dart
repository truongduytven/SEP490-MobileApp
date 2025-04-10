import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/repositories/doctor_repository.dart';

class DoctorController {
  final DoctorRepository _doctorRepository = DoctorRepository();
  DoctorData? doctorData;
  PackageData? packageData;
  List<AppoimentDoctor>? appoimentDoctor;
  List<TimeSlots>? listAppoimentDoctor;
  Report? report;
  List<FilteredDoctor>? listFilterDoctor;
  List<ComboData>? comboData;
  CheckoutResponse? checkoutResponse;
  List<FeedBackDoctor>? feedbackDoctor;
  bool isOrderSuccess = false;
  bool isConfirmedSuccess = false;
  bool isSelectDoctorSuccess = false;
  bool isBookingAppointmentSuccess = false;
  bool isCancelSuccess = false;
  bool isRatingSuccess = false;
  bool isSendReportSuccess = false;

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

  Future<void> getPackageUser(int accountId) async {
    final response = await _doctorRepository.getPackageUser(accountId);
    if (response != null && response['isSuccess']) {
      packageData = PackageData.fromJson(response['data']['data']);
    } else {
      packageData = null;
    }
  }

  Future<void> getComboData() async {
    final response = await _doctorRepository.getComboData();
    if (response != null && response['isSuccess']) {
      List<dynamic> data = response['data']['data'];
      print(data);
      if (data.isEmpty) {
        comboData = null;
        return;
      }
      comboData = data.map((item) => ComboData.fromJson(item)).toList();
    } else {
      comboData = null;
    }
  }

  Future<void> getAppointmentByID(int accountId, String type) async {
    final response =
        await _doctorRepository.getAppointmentByID(accountId, type);
    if (response != null && response['isSuccess']) {
      List<dynamic> data = response['data']['data'];
      appoimentDoctor =
          data.map((item) => AppoimentDoctor.fromJson(item)).toList();
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
      if (data.isEmpty) {
        listAppoimentDoctor = null;
        return;
      }
      listAppoimentDoctor =
          data.map((item) => TimeSlots.fromJson(item)).toList();
    } else {
      listAppoimentDoctor = null;
    }
  }

  Future<void> getFilterDoctor(List<String> filterEnter) async {
    final response = await _doctorRepository.getFilterDoctor(filterEnter);
    if (response != null && response['isSuccess']) {
      List<dynamic> data = response['data']['data'];
      if (data.isEmpty) {
        listFilterDoctor = null;
        return;
      }
      listFilterDoctor =
          data.map((item) => FilteredDoctor.fromJson(item)).toList();
    } else {
      listFilterDoctor = null;
    }
  }

  Future<void> checkout(
      int accountId, int elderlyId, int subscriptionId) async {
    final response =
        await _doctorRepository.checkout(accountId, elderlyId, subscriptionId);
    if (response != null && response['isSuccess']) {
      checkoutResponse = CheckoutResponse.fromJson(response['data']['data']);
    } else {
      checkoutResponse = null;
    }
  }

  Future<void> checkOrderStatus(String transId) async {
    final response = await _doctorRepository.checkOrderStatus(transId);
    if (response != null && response['isSuccess']) {
      isOrderSuccess = response['data']['data']['return_code'] == 1;
    } else {
      isOrderSuccess = false;
    }
  }

  Future<void> confirmCheckout(String transId) async {
    final response = await _doctorRepository.confirmCheckout(transId);
    if (response != null && response['isSuccess']) {
      isConfirmedSuccess = response['data']['status'] == 1;
    } else {
      isConfirmedSuccess = false;
    }
  }

  Future<void> selectDoctor(int professorId, int elderlyId) async {
    final response =
        await _doctorRepository.selectDoctor(professorId, elderlyId);
    if (response != null && response['isSuccess']) {
      isSelectDoctorSuccess = response['data']['status'] == 1;
    } else {
      isSelectDoctorSuccess = false;
    }
  }

  Future<void> bookingAppointment(
      int elderlyId, int timeSlotId, String day, String description) async {
    final response = await _doctorRepository.bookingAppointment(
        elderlyId, timeSlotId, day, description);
    if (response != null && response['isSuccess']) {
      isBookingAppointmentSuccess = response['data']['status'] == 1;
    } else {
      isBookingAppointmentSuccess = false;
    }
  }

  Future<void> cancelAppointment(int appointmentId) async {
    final response = await _doctorRepository.cancelAppointment(appointmentId);
    if (response != null && response['isSuccess']) {
      isCancelSuccess = response['data']['status'] == 1;
    } else {
      isCancelSuccess = false;
    }
  }

  Future<void> ratingDoctor(
      int appointmentId, String content, int star, String createdBy) async {
    final response = await _doctorRepository.ratingDoctor(
        appointmentId, content, star, createdBy);
    if (response != null && response['isSuccess']) {
      isRatingSuccess = response['data']['status'] == 1;
    } else {
      isRatingSuccess = false;
    }
  }

  Future<void> reportDoctor(
      int appointmentId, String content, String solution) async {
    final response =
        await _doctorRepository.reportDoctor(appointmentId, content, solution);
    if (response != null && response['isSuccess']) {
      isSendReportSuccess = response['data']['status'] == 1;
    } else {
      isSendReportSuccess = false;
    }
  }

  Future<void> getFeedbackDoctor(int professorId) async {
    final response = await _doctorRepository.getFeedbackDoctor(professorId);
    if (response != null && response['isSuccess']) {
      List<dynamic> data = response['data']['data'];
      feedbackDoctor =
          data.map((item) => FeedBackDoctor.fromJson(item)).toList();
    } else {
      feedbackDoctor = [];
    }
  }
}
