import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/presentation/pages/medicine/controller/medicine_controller.dart';
import 'package:sep490/presentation/pages/medicine/view_detail_medicine.dart';
import 'package:sep490/presentation/widgets/medicine/medicine_card.dart';
import 'package:sep490/theme/color.dart';

class HistoryPrescription extends StatefulWidget {
  const HistoryPrescription({super.key});

  @override
  State<HistoryPrescription> createState() => _HistoryPrescriptionState();
}

class _HistoryPrescriptionState extends State<HistoryPrescription> {
  List<Map<String, dynamic>>? prescriptions;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int userId = sharedPrefsHelper.getInt('accountId')!;
  late int selectedElderlyUserId =
      sharedPrefsHelper.getInt('selectedElderlyUserId') ?? 0;
  late int roleId = sharedPrefsHelper.getInt('roleId') ?? 0;
  bool isLoading = false;
  bool isEdited = false;

  @override
  void initState() {
    super.initState();
    getPrescription();
  }

  void getPrescription() async {
    isLoading = true;
    MedicineController medicineController = MedicineController();
    await medicineController.getHistoryPrescription(
        selectedElderlyUserId == 0 ? userId : selectedElderlyUserId);
    Timer(Duration(seconds: 2), () {
      if (!mounted) return;
      if (medicineController.message.isNotEmpty) {
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            medicineController.message,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ).show(context);
        setState(() {
          isLoading = false;
        });
        return;
      }
      setState(() {
        prescriptions =
            medicineController.prescriptions?.map((e) => e.toJson()).toList();
        isLoading = false;
      });
    });
  }

  void handlePressMedicineCard(Map<String, dynamic> medicine, int index) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewDetailMedicine(
          medicineData: medicine,
          isEdited: false,
        ),
      ),
    );
  }

  void handleShowImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
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
            "Lịch sử toa thuốc",
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
          child: isLoading
              ? Center(
                  child: GifView.asset(
                    'assets/gif/prescription1.gif',
                    width: 100,
                    height: 100,
                    frameRate: 90,
                  ),
                )
              : prescriptions == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/img3D/toathuocrong.png',
                          height: 150,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Không có toa thuốc nào đã sử dụng',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondaryColor,
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
                              child: Column(
                                children: [
                                  for (var prescription
                                      in (prescriptions!
                                        ..sort((a, b) => a['id'] - b['id'])))
                                    if (prescription['medicines'].isNotEmpty)
                                      Container(
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
                                              color: AppColors.grayColor3
                                                  .withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 7,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          // border: Border.all(color: AppColors.grayColor1, width: 1),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: AppColors
                                                            .secondaryColor),
                                                    children: [
                                                      const TextSpan(
                                                        text: "Ngày bắt đầu: ",
                                                      ),
                                                      TextSpan(
                                                        text: convertDate(
                                                            prescription[
                                                                'startDate']),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    handleShowImage(
                                                        context,
                                                        prescription[
                                                            'medicationImage']);
                                                  },
                                                  child: Icon(Icons.image,
                                                      color: AppColors
                                                          .secondaryColor),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    color: AppColors
                                                        .secondaryColor),
                                                children: [
                                                  const TextSpan(
                                                    text: "Ngày kết thúc: ",
                                                  ),
                                                  TextSpan(
                                                    text: convertDate(
                                                        prescription[
                                                            'endDate']),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18),
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
                                                    color: AppColors
                                                        .secondaryColor),
                                                children: [
                                                  const TextSpan(
                                                    text:
                                                        "Điều trị: ", // Phần này giữ bình thường
                                                  ),
                                                  TextSpan(
                                                    text: prescription[
                                                        'treatment'], // Chỉ phần ngày bắt đầu
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            18), // In đậm phần này
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
                                            prescription['medicines'].isNotEmpty
                                                ? ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: prescription[
                                                            'medicines']
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return buildMedicineCard(
                                                        prescription[
                                                                    'medicines']
                                                                [index]
                                                            ['medicationName'],
                                                        prescription[
                                                                'medicines']
                                                            [index]['dosage'],
                                                        prescription[
                                                                'medicines']
                                                            [index]['shape'],
                                                        prescription[
                                                                    'medicines']
                                                                [index]
                                                            ['remaining'],
                                                        prescription[
                                                                    'medicines']
                                                                [index]
                                                            ['frequencyType'],
                                                        prescription[
                                                                    'medicines']
                                                                [index]
                                                            ['frequencySelect'],
                                                        prescription[
                                                                    'medicines']
                                                                [index]
                                                            ['isBeforeMeal'],
                                                        prescription[
                                                                'medicines']
                                                            [index]['schedule'],
                                                        () => {
                                                          handlePressMedicineCard(
                                                              prescription[
                                                                      'medicines']
                                                                  [index],
                                                              index)
                                                        },
                                                      );
                                                    },
                                                  )
                                                : Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/img3D/toathuocrong.png',
                                                          height: 150,
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        Text(
                                                          'Không có thuốc',
                                                          style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColors
                                                                .secondaryColor,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                      ],
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ));
  }
}
