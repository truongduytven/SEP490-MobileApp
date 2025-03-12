import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gif_view/gif_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/presentation/pages/medicine/controller/medicine_controller.dart';
import 'package:sep490/presentation/pages/medicine/create_presciption/create_prescription_screen.dart';
import 'package:sep490/presentation/pages/medicine/create_presciption/create_title_prescription.dart';
import 'package:sep490/presentation/pages/medicine/detail_medicine.dart';
import 'package:sep490/presentation/pages/medicine/home_medicine.dart';
import 'package:sep490/presentation/widgets/loading/loadingImgPath.dart';
import 'package:sep490/presentation/widgets/medicine/medicine_card.dart';
import 'package:sep490/theme/color.dart';

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  Map<String, dynamic>? prescription;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int userId = sharedPrefsHelper.getInt('accountId')!;
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
    await medicineController.getPresciption(userId);
    Timer(Duration(seconds: 2), () {
      setState(() {
        prescription = medicineController.prescriptionUpdate?.toJson();
        isLoading = false;
      });
    });
  }

  void handlePressMedicineCard(Map<String, dynamic> medicine, int index) async {
    Map<String, dynamic> oldMedicine = {
      'medicationName': medicine['medicationName'],
      'dosage': medicine['dosage'],
      'shape': medicine['shape'],
      'remaining': medicine['remaining'],
      'frequencyType': medicine['frequencyType'],
      'frequencySelect': medicine['frequencySelect'],
      'isBeforeMeal': medicine['isBeforeMeal'],
      'schedule': medicine['schedule'],
    };
    final newMedicine = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailMedicine(
          medicineData: oldMedicine,
        ),
      ),
    );

    if (newMedicine != null && newMedicine is Map<String, dynamic>) {
      setState(() {
        prescription!['medicines'][index]['medicationName'] =
            newMedicine['medicationName'];
        prescription!['medicines'][index]['shape'] = newMedicine['shape'];
        prescription!['medicines'][index]['dosage'] = newMedicine['dosage'];
        prescription!['medicines'][index]['remaining'] =
            newMedicine['remaining'];
        prescription!['medicines'][index]['frequencyType'] =
            newMedicine['frequencyType'];
        prescription!['medicines'][index]['frequencySelect'] =
            newMedicine['frequencySelect'];
        prescription!['medicines'][index]['isBeforeMeal'] =
            newMedicine['isBeforeMeal'];
        prescription!['medicines'][index]['schedule'] = newMedicine['schedule'];
        isEdited = true;
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
        prescription!['medicines'].add(newMedicine);
        isEdited = true;
      });
    }
  }

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
                Navigator.pop(context);
                _showImageSourceDialog();
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

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                    vertical: 15, horizontal: 20), // Increase tap area
                leading: Icon(Icons.camera_alt,
                    size: 40, color: Colors.blue), // Bigger icon
                title: Text(
                  'Chụp ảnh',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold), // Bigger text
                ),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              Divider(),
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                leading:
                    Icon(Icons.photo_library, size: 40, color: Colors.green),
                title: Text(
                  'Chọn ảnh từ thư viện',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      Navigator.pop(context); // Đóng dialog
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreatePrescriptionScreen(imagePath: image.path),
        ),
      );
    }
  }

  void handleUpdatePrescription() async {
    LoadingDialog.show(context, 'assets/gif/opd.gif', 'Đang lưu toa thuốc...');
    Map<String, dynamic> newObject = {
      ...prescription!,
      "medication": (prescription!["medicines"])
          .map((medicine) => {
                ...medicine,
                "note": "nothing",
                "treatment": "string",
                "frequencySelect": medicine['frequencyType'] != 'Select'
                    ? []
                    : medicine['frequencySelect'],
                "schedule": medicine["schedule"]
                    .map(
                        (time) => time.length > 5 ? time.substring(0, 5) : time)
                    .toList(),
              })
          .toList(),
    }..remove("medicines");

    newObject.remove('startDate');
    newObject.remove('id');

    MedicineController medicineController = MedicineController();
    await medicineController.updatePrescriptionController(
        newObject, prescription!['id']);
    Timer(const Duration(seconds: 1), () {
      if (medicineController.isUpdateSuccess) {
        Navigator.pop(context);
        LoadingDialog.show(context, 'assets/gif/create_success.gif',
            'Lưu toa thuốc thành công!');
        Timer(const Duration(seconds: 2), () {
          Navigator.pop(context);
          setState(() {
            isEdited = false;
            getPrescription();
          });
        });
      } else {
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

  void handleCancelPrescription() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Xác nhận',
            style: TextStyle(fontSize: 25),
          ),
          content: const Text(
            'Bạn có chắc chắn muốn hủy toa thuốc này không?',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Hủy',
                style: TextStyle(color: AppColors.secondaryColor),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                LoadingDialog.show(
                    context, 'assets/gif/opd.gif', 'Đang hủy toa thuốc...');
                MedicineController medicineController = MedicineController();
                await medicineController
                    .cancelPrescriptionController(prescription!['id']);
                Timer(const Duration(seconds: 2), () {
                  if (medicineController.isCancelSuccess) {
                    Navigator.pop(context);
                    LoadingDialog.show(context, 'assets/gif/create_success.gif',
                        'Hủy toa thuốc thành công!');
                    Timer(const Duration(seconds: 2), () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      setState(() {
                        isEdited = false;
                        getPrescription();
                      });
                    });
                  } else {
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
              },
              child: const Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
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
            "Chi tiết toa thuốc",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeMedicine(),
                ),
              );
            },
          ),
          actions: [
            prescription != null && prescription!['medicationImage'] != ''
                ? IconButton(
                    icon: Icon(Icons.image),
                    onPressed: () {
                      handleShowImage(
                          context, prescription!['medicationImage']);
                    },
                  )
                : Container(),
          ],
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
              : prescription == null
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
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
                                      color:
                                          AppColors.grayColor3.withOpacity(0.5),
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
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: AppColors.secondaryColor),
                                        children: [
                                          const TextSpan(
                                            text: "Ngày bắt đầu: ",
                                          ),
                                          TextSpan(
                                            text: convertDate(
                                                prescription!['startDate']),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
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
                                            color: AppColors.secondaryColor),
                                        children: [
                                          const TextSpan(
                                            text: "Ngày kết thúc: ",
                                          ),
                                          TextSpan(
                                            text: convertDate(
                                                prescription!['endDate']),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
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
                                            color: AppColors.secondaryColor),
                                        children: [
                                          const TextSpan(
                                            text:
                                                "Điều trị: ", // Phần này giữ bình thường
                                          ),
                                          TextSpan(
                                            text: prescription![
                                                'treatment'], // Chỉ phần ngày bắt đầu
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
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
                                    prescription!['medicines'].isNotEmpty
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                prescription!['medicines']
                                                    .length,
                                            itemBuilder: (context, index) {
                                              return buildMedicineCard(
                                                prescription!['medicines']
                                                    [index]['medicationName'],
                                                prescription!['medicines']
                                                    [index]['dosage'],
                                                prescription!['medicines']
                                                    [index]['shape'],
                                                prescription!['medicines']
                                                    [index]['remaining'],
                                                prescription!['medicines']
                                                    [index]['frequencyType'],
                                                prescription!['medicines']
                                                    [index]['frequencySelect'],
                                                prescription!['medicines']
                                                    [index]['isBeforeMeal'],
                                                prescription!['medicines']
                                                    [index]['schedule'],
                                                () => {
                                                  handlePressMedicineCard(
                                                      prescription!['medicines']
                                                          [index],
                                                      index)
                                                },
                                              );
                                            },
                                          )
                                        : Center(
                                            child: Column(
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
                                                    color: AppColors
                                                        .secondaryColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                              ],
                                            ),
                                          ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      width: double.infinity,
                                      color: Colors.transparent,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          handleAddMedicine();
                                        },
                                        icon: Icon(Icons.add_circle,
                                            size: 25,
                                            color: AppColors.iconColor),
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
                            child: ElevatedButton.icon(
                              onPressed: () {
                                handleCancelPrescription();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.bgColor,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(
                                        color: AppColors.secondaryColor,
                                        width: 2),
                                  )),
                              icon: Icon(Icons.pause_circle,
                                  size: 25, color: AppColors.secondaryColor),
                              label: const Text('Ngưng toa thuốc',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: AppColors.secondaryColor,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                          ),
                          if (isEdited)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              width: double.infinity,
                              color: Colors.transparent,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  handleUpdatePrescription();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondaryColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    )),
                                icon: Icon(Icons.save,
                                    size: 25, color: AppColors.bgColor),
                                label: const Text('Lưu thay đổi',
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
