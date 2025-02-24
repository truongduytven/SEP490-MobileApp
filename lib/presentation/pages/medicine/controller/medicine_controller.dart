import 'package:sep490/models/medicine/medicine.dart';
import 'package:sep490/presentation/pages/medicine/repository/medicine_repository.dart';

class MedicineController {
  Prescription? prescription;
  final MedicineRepository _medicineRepository = MedicineRepository();

  Future<void> getMedicines(int userId, String day) async {
    final response = await _medicineRepository.getMedicines(userId, day);
    if (response != null && response['isSuccess']) {
      prescription = Prescription.fromJson(response['data']['data']);
    } else {
      prescription = null;
    }
  }
}