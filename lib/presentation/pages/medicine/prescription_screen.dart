import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/models/medicine/medicine.dart';
import 'package:sep490/presentation/pages/medicine/controller/medicine_controller.dart';
import 'package:sep490/presentation/pages/medicine/create_presciption/create_prescription_screen.dart';
import 'package:sep490/presentation/pages/medicine/create_presciption/create_title_prescription.dart';
import 'package:sep490/presentation/widgets/medicine/medicine_card.dart';
import 'package:sep490/theme/color.dart';

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  Prescription? prescription;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int userId = sharedPrefsHelper.getInt('accountId')!;

  @override
  void initState() {
    super.initState();
    getPrescription();
  }

  void getPrescription() async {
    MedicineController medicineController = MedicineController();
    await medicineController.getPresciption(userId);
    Timer(Duration(seconds: 2), () {
      setState(() {
        prescription = medicineController.prescription;
      });
    });
  }

  // void handlePressMedicineCard(int id) async {
  //   for (var medicine in prescription!.medicines) {
  //     if (medicine.id == id) {
  //       final updatedMedicine = await Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => DetailMedicine(
  //             medicineData: medicine,
  //           ),
  //         ),
  //       );
  //       if (updatedMedicine != null &&
  //           updatedMedicine is Map<String, dynamic>) {
  //         setState(() {
  //           medicine = updatedMedicine;
  //         });
  //       }
  //     }
  //   }
  // }

  // void handleAddMedicine() async {
  //   final newMedicine = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => DetailMedicine(
  //         medicineData: null,
  //       ),
  //     ),
  //   );

  //   if (newMedicine != null && newMedicine is Map<String, dynamic>) {
  //     if (newMedicine['id'] == null) {
  //       newMedicine['id'] = DateTime.now().millisecondsSinceEpoch;
  //     }
  //     setState(() {
  //       prescription.medicines.add(newMedicine);
  //     });
  //   }
  // }

  void handleCreatePrescription() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateTitlePrescription(),
                  ),
                );
              },
              child: Container(
                width: 250,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img/typing.png',
                      height: 100,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Nhập tay',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'LeagueSpartan',
                        color: AppColors.secondaryColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () async {
                final XFile? image = await ImagePicker().pickImage(
                source: ImageSource.camera, // Change to gallery if needed
              );
              if (image != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePrescriptionScreen(),
                  ),
                );
              }
              },
              child: Container(
                width: 250,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img/scan.png',
                      height: 100,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Quét toa thuốc',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'LeagueSpartan',
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[50],
        appBar: AppBar(
          title: Text(
            "Toa thuốc",
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
          child: prescription == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img3D/toathuocrong.png',
                      height: 150,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Không có toa thuốc',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: handleCreatePrescription,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Tạo toa thuốc mới',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            // height: MediaQuery.of(context).size.height * 0.77,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              // border: Border.all(color: AppColors.grayColor1, width: 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Text(
                                  'Toa thuốc ngày ${prescription!.startDate}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22),
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
                                        text: prescription!
                                            .startDate, // Chỉ phần ngày bắt đầu
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
                                        text: prescription!
                                            .treatment, // Chỉ phần ngày bắt đầu
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
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18),
                                ),
                                const SizedBox(height: 10),
                                prescription!.medicines.isNotEmpty
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            prescription!.medicines.length,
                                        itemBuilder: (context, index) {
                                          return buildMedicineCard(
                                            prescription!.medicines[index].name,
                                            prescription!
                                                .medicines[index].dosage,
                                            prescription!.medicines[index].form,
                                            prescription!
                                                .medicines[index].remaining,
                                            prescription!
                                                .medicines[index].typeFrequency,
                                            prescription!.medicines[index]
                                                .frequencyEvery,
                                            prescription!.medicines[index]
                                                .frequencySelect,
                                            prescription!
                                                .medicines[index].mealTime,
                                            prescription!
                                                .medicines[index].schedule,
                                            // () => handlePressMedicineCard(
                                            //     prescription!.medicines[index].id),
                                            () => {},
                                          );
                                        },
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/img3D/toathuocrong.png',
                                            height: 150,
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            'Không có thuốc',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.secondaryColor,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: handleCreatePrescription,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.secondaryColor,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: const Text(
                                              'Tạo toa thuốc mới',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  width: double.infinity,
                                  color: Colors.transparent,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      //handleAddMedicine();
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
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          side: BorderSide(
                                              color: AppColors.iconColor)),
                                      shadowColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        width: double.infinity,
                        color: Colors.transparent,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondaryColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
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
                      ),
                    ],
                  ),
                ),
        ));
  }
}
