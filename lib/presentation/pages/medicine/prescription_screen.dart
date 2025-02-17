import 'package:flutter/material.dart';
import 'package:sep490/presentation/widgets/medicine/medicine_card.dart';
import 'package:sep490/theme/color.dart';

import 'detail_medicine.dart';

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  late Map<String, dynamic> prescription = {
    "id": 1,
    "name": "Toa thuốc 1",
    "treatment": "viêm họng",
    "start_date": "2022-10-10",
    "medicines": [
      {
        "id": 1,
        'name': 'Paracetamol 500mg Paracetamol 500mg',
        'dosage': '1 viên',
        'form': 'Viên',
        'remaining': '31',
        'typeFrequency': 'Every',
        'frequencyEvery': '2',
        'frequencySelect': [],
        'mealTime': 'Trước ăn',
        'schedule': ['8h', '12h', '18h'],
        'usedInDay': ['8h', '12h'],
      },
      {
        "id": 2,
        'name': 'Thuốc B',
        'dosage': '1 viên',
        'form': 'Viên',
        'remaining': '31',
        'typeFrequency': 'Every',
        'frequencyEvery': '2',
        'frequencySelect': [],
        'mealTime': 'Trước ăn',
        'schedule': ['8h', '12h', '18h'],
      },
      {
        "id": 3,
        'name': 'Thuốc C',
        'dosage': '1 viên',
        'form': 'Viên',
        'remaining': '31',
        'typeFrequency': 'Every',
        'frequencyEvery': '2',
        'frequencySelect': [],
        'mealTime': 'Trước ăn',
        'schedule': ['8h', '12h', '18h'],
      },
      {
        "id": 1,
        'name': 'Thuốc A',
        'dosage': '1 viên',
        'form': 'Viên nhộng',
        'remaining': '31',
        'typeFrequency': 'Every',
        'frequencyEvery': '2',
        'frequencySelect': [],
        'mealTime': 'Trước ăn',
        'schedule': ['8h', '12h', '18h'],
      },
      {
        "id": 2,
        'name': 'Thuốc B',
        'dosage': '1 viên',
        'form': 'Viên',
        'remaining': '31',
        'typeFrequency': 'Every',
        'frequencyEvery': '2',
        'frequencySelect': [],
        'mealTime': 'Trước ăn',
        'schedule': ['8h', '12h', '18h'],
      },
      {
        "id": 3,
        'name': 'Thuốc C',
        'dosage': '1 viên',
        'form': 'Viên',
        'remaining': '31',
        'typeFrequency': 'Every',
        'frequencyEvery': '2',
        'frequencySelect': [],
        'mealTime': 'Trước ăn',
        'schedule': ['8h', '12h', '18h'],
      },
      {
        "id": 1,
        'name': 'Thuốc A',
        'dosage': '1 viên',
        'form': 'Viên',
        'remaining': '31',
        'typeFrequency': 'Every',
        'frequencyEvery': '2',
        'frequencySelect': [],
        'mealTime': 'Trước ăn',
        'schedule': ['8h', '12h', '18h'],
      },
      {
        "id": 2,
        'name': 'Thuốc B',
        'dosage': '1 viên',
        'form': 'Viên',
        'remaining': '31',
        'typeFrequency': 'Every',
        'frequencyEvery': '2',
        'frequencySelect': [],
        'mealTime': 'Trước ăn',
        'schedule': ['8h', '12h', '18h'],
      },
      {
        "id": 3,
        'name': 'Thuốc C',
        'dosage': '1 viên',
        'form': 'Viên',
        'remaining': '31',
        'typeFrequency': 'Every',
        'frequencyEvery': '2',
        'frequencySelect': [],
        'mealTime': 'Trước ăn',
        'schedule': ['8h', '12h', '18h'],
      },
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[50],
        appBar: AppBar(
          title: Text(
            "Đơn thuốc",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/background_app.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.77,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.grayColor3.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    // border: Border.all(color: AppColors.grayColor1, width: 1),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Text(
                              prescription['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 22),
                            )),
                            const SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: AppColors.secondaryColor),
                                children: [
                                  const TextSpan(
                                    text:
                                        "Ngày bắt đầu: ", // Phần này giữ bình thường
                                  ),
                                  TextSpan(
                                    text: prescription[
                                        'start_date'], // Chỉ phần ngày bắt đầu
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18), // In đậm phần này
                                  ),
                                ],
                              ),
                            ),
                      
                            const SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: AppColors.secondaryColor),
                                children: [
                                  const TextSpan(
                                    text:
                                        "Điều trị: ", // Phần này giữ bình thường
                                  ),
                                  TextSpan(
                                    text: prescription['treatment'], // Chỉ phần ngày bắt đầu
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18), // In đậm phần này
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Chi tiết thuốc trong toa:",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 18),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: prescription['medicines'].length,
                                itemBuilder: (context, index) {
                                  return buildMedicineCard(
                                    prescription['medicines'][index]['id'],
                                    prescription['medicines'][index]['name'],
                                    prescription['medicines'][index]['dosage'],
                                    prescription['medicines'][index]['form'],
                                    prescription['medicines'][index]['remaining'],
                                    prescription['medicines'][index]
                                        ['typeFrequency'],
                                    prescription['medicines'][index]
                                        ['frequencyEvery'],
                                    prescription['medicines'][index]
                                        ['frequencySelect'],
                                    prescription['medicines'][index]['mealTime'],
                                    prescription['medicines'][index]['schedule'],
                                  );
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              width: double.infinity,
                              color: Colors.transparent,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailMedicine(),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.add_circle,
                                    size: 25, color: AppColors.iconColor),
                                label: Text('Thêm thuốc',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: AppColors.iconColor,
                                    )),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 25,
                                  ),
                                  backgroundColor: AppColors.bgColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: BorderSide(color: AppColors.iconColor)),
                                  shadowColor: Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 150, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                  child: const Text('Lưu',
                      style: TextStyle(
                        fontSize: 25,
                        color: AppColors.bgColor,
                        fontWeight: FontWeight.w400,
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}
