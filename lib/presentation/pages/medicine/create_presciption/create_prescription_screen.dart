import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/presentation/pages/medicine/controller/medicine_controller.dart';
import 'package:sep490/presentation/pages/medicine/detail_medicine.dart';
import 'package:sep490/presentation/pages/medicine/prescription_screen.dart';
import 'package:sep490/presentation/widgets/loading/loadingImgPath.dart';
import 'package:sep490/presentation/widgets/medicine/medicine_prescription_card.dart';
import 'package:sep490/theme/color.dart';

class CreatePrescriptionScreen extends StatefulWidget {
  final String? endDate;
  final String? treatment;
  final String? imagePath;
  const CreatePrescriptionScreen(
      {super.key, this.endDate, this.treatment, this.imagePath});

  @override
  State<CreatePrescriptionScreen> createState() =>
      _CreatePrescriptionScreenState();
}

class _CreatePrescriptionScreenState extends State<CreatePrescriptionScreen> {
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  Map<String, dynamic> listMedicine = {
    'accountId': 0,
    'treatment': '',
    'endDate': '',
    'medication': <List<Map<String, dynamic>>>[],
    'createdBy': "",
  };

  @override
  void initState() {
    super.initState();
    listMedicine['accountId'] = sharedPrefsHelper.getInt('accountId');
    listMedicine['endDate'] = widget.endDate ?? '';
    listMedicine['treatment'] = widget.treatment ?? '';
    listMedicine['createdBy'] = sharedPrefsHelper.getString('fullName');
    listMedicine['medication'] = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getScanMedicine();
    });
  }

  void getScanMedicine() async {
    if (widget.imagePath != null) {
      LoadingDialog.show(
          context, 'assets/gif/opd.gif', 'Đang quét toa thuốc...');
      MedicineController medicineController = MedicineController();
      await medicineController.scanMedicine(
          widget.imagePath!, listMedicine['accountId']);
      Timer(const Duration(seconds: 1), () {
        if (medicineController.medicines != null) {
          Navigator.pop(context);
          LoadingDialog.show(context, 'assets/gif/create_success.gif',
              'Quét toa thuốc thành công!');
          setState(() {
            listMedicine['treatment'] =
                medicineController.medicines!['treatment'];
            listMedicine['endDate'] =
                convertDate(medicineController.medicines!['endDate']);
            medicineController.medicines!['medicines'].forEach((element) {
              Map<String, dynamic> medicine = {
                'medicationName': element['medicationName'],
                'dosage': element['dosage'],
                'shape': element['shape'],
                'remaining': element['remaining'],
                'frequencyType': element['frequencyType'],
                'frequencySelect': element['frequencySelect'] ?? [],
                'isBeforeMeal': element['isBeforeMeal'],
                'schedule': element['schedule'],
              };
              listMedicine['medication'].add(medicine);
            });
          });
          Timer(const Duration(seconds: 2), () {
            Navigator.pop(context);
          });
        } else {
          Navigator.pop(context);
          Navigator.pop(context, false);
        }
      });
    }
  }

  void handleAddMedicine() async {
    final newMedicine = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailMedicine(
          medicineData: null,
        ),
      ),
    );

    if (newMedicine != null && newMedicine is Map<String, dynamic>) {
      setState(() {
        listMedicine['medication'] ??= [];
        listMedicine['medication'].add(newMedicine);
      });
    }
  }

  void handlePressMedicineCard(Map<String, dynamic> medicine, int index) async {
    final updatedMedicine = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailMedicine(
          medicineData: medicine,
        ),
      ),
    );

    if (updatedMedicine != null && updatedMedicine is Map<String, dynamic>) {
      setState(() {
        listMedicine['medication'] = listMedicine['medication']
            .asMap()
            .entries
            .map((entry) => entry.key == index ? updatedMedicine : entry.value)
            .toList();
      });
    }
  }

  void handleSavePrescription() async {
    LoadingDialog.show(context, 'assets/gif/opd.gif', 'Đang tạo toa thuốc...');
    if (listMedicine['medication'].length == 0) {
      Navigator.pop(context);
      CherryToast.error(
        toastDuration: Duration(seconds: 3),
        title: Text(
          "Vui lòng nhập thuốc trước khi tạo toa!",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ).show(context);
      return;
    }
    String dateData = listMedicine['endDate'];
    listMedicine['endDate'] = convertDateTime(listMedicine['endDate']);
    MedicineController medicineController = MedicineController();
    await medicineController.createPrescriptionController(
        listMedicine, widget.imagePath != null ? widget.imagePath! : '');
    Timer(const Duration(seconds: 1), () {
      if (medicineController.isCreateSuccess) {
        listMedicine['endDate'] = dateData;
        Navigator.pop(context);
        LoadingDialog.show(context, 'assets/gif/create_success.gif',
            'Tạo toa thuốc thành công!');
        Timer(const Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => PrescriptionScreen()));
        });
      } else {
        listMedicine['endDate'] = dateData;
        Fluttertoast.showToast(
          msg: "Có lỗi trong quá trình xử lý!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
      }
    });
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      // border: Border.all(color: AppColors.grayColor1, width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: AppColors.secondaryColor),
                            children: [
                              const TextSpan(
                                text:
                                    "Ngày kết thúc: ", // Phần này giữ bình thường
                              ),
                              TextSpan(
                                text: listMedicine[
                                    'endDate'], // Chỉ phần ngày bắt đầu // Chỉ phần ngày bắt đầu
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
                                text: "Điều trị: ", // Phần này giữ bình thường
                              ),
                              TextSpan(
                                text: listMedicine[
                                    'treatment'], // Chỉ phần ngày bắt đầu
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
                        listMedicine['medication'].length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    listMedicine['medication'].length != 0
                                        ? listMedicine['medication'].length
                                        : 0,
                                itemBuilder: (context, index) {
                                  return buildMedicinePresciptionCard(
                                    listMedicine['medication'][index]
                                        ['medicationName'],
                                    listMedicine['medication'][index]['dosage'],
                                    listMedicine['medication'][index]['shape'],
                                    listMedicine['medication'][index]
                                        ['remaining'],
                                    listMedicine['medication'][index]
                                        ['frequencyType'],
                                    listMedicine['medication'][index]
                                        ['frequencySelect'],
                                    listMedicine['medication'][index]
                                        ['isBeforeMeal'],
                                    listMedicine['medication'][index]
                                        ['schedule'],
                                    // () => handlePressMedicineCard(
                                    //     listMedicine['medication'][index].id),
                                    () => {
                                      handlePressMedicineCard(
                                        listMedicine['medication'][index],
                                        index,
                                      )
                                    },
                                  );
                                },
                              )
                            : SizedBox(height: 20),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          width: double.infinity,
                          color: Colors.transparent,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              handleAddMedicine();
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
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: double.infinity,
                color: Colors.transparent,
                child: ElevatedButton(
                  onPressed: () {
                    handleSavePrescription();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
      ),
    );
  }
}
