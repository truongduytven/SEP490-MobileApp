import 'package:sep490/models/medicine/medicine.dart';
import 'package:sep490/presentation/pages/medicine/repository/medicine_repository.dart';

class MedicineController {
  Prescription? prescription;
  PrescriptionUpdate? prescriptionUpdate;
  final MedicineRepository _medicineRepository = MedicineRepository();
  bool isCreateSuccess = false;

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

  Future<void> createPrescriptionController (Map<String, dynamic> presciption) async {
    final response = await _medicineRepository.creatPresciption(presciption);
    if (response != null && response['isSuccess']) {
      isCreateSuccess = true;
    } else {
      isCreateSuccess = false;
    }
  }
}