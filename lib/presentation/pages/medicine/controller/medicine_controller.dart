import 'package:sep490/models/medicine/medicine.dart';
import 'package:sep490/presentation/pages/medicine/repository/medicine_repository.dart';

class MedicineController {
  Prescription? prescription;
  PrescriptionUpdate? prescriptionUpdate;
  Map<String, dynamic>? medicines;
  final MedicineRepository _medicineRepository = MedicineRepository();
  bool isCreateSuccess = false;
  bool isUpdateSuccess = false;
  bool isCancelSuccess = false;
  bool isConfirmSuccess = false;

  Future<void> getMedicines(int userId, String day) async {
    final response = await _medicineRepository.getMedicines(userId, day);
    if (response != null && response['isSuccess']) {
      prescription = Prescription.fromJson(response['data']['data']);
    } else {
      prescription = null;
    }
  }

  Future<void> getPresciption (int userId) async {
    final response = await _medicineRepository.getPresciption(userId);
    if (response != null && response['isSuccess']) {
      prescriptionUpdate = PrescriptionUpdate.fromJson(response['data']['data']);
    } else {
      prescriptionUpdate = null;
    }
  }

  Future<void> createPrescriptionController (Map<String, dynamic> presciption, String imgPath) async {
    final response = await _medicineRepository.creatPresciption(presciption, imgPath);
    if (response != null && response['isSuccess']) {
      isCreateSuccess = true;
    } else {
      isCreateSuccess = false;
    }
  }

  Future<void> updatePrescriptionController (Map<String, dynamic>? presciption, int prescriptionId) async {
    final response = await _medicineRepository.updatedMedicine(presciption, prescriptionId);
    if (response != null && response['isSuccess']) {
      isUpdateSuccess = true;
    } else {
      isUpdateSuccess = false;
    }
  }

  Future<void> cancelPrescriptionController (int prescriptionId) async {
    final response = await _medicineRepository.cancelMedicine(prescriptionId);
    if (response != null && response['isSuccess']) {
      isCancelSuccess = true;
    } else {
      isCancelSuccess = false;
    }
  }

  Future<void> confirmMedicine (Map<String, dynamic> medicines) async {
    final response = await _medicineRepository.confirmMedicine(medicines);
    if (response != null && response['isSuccess']) {
      isConfirmSuccess = true;
    } else {
      isConfirmSuccess = false;
    }
  }

  Future<void> scanMedicine (String imgPath, int userId) async {
    final response = await _medicineRepository.scanMedicine(imgPath, userId);
    if (response != null && response['isSuccess']) {
      medicines = response['data']['data'];
    } else {
      medicines = null;
    }
  }
}