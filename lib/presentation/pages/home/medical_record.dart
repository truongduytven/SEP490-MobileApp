import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/presentation/pages/home/controller/home_controller.dart';
import 'package:sep490/theme/color.dart';

class MedicalRecord extends StatefulWidget {
  final int? elderlyId;
  const MedicalRecord({super.key, this.elderlyId});

  @override
  State<MedicalRecord> createState() => _MedicalRecordState();
}

class _MedicalRecordState extends State<MedicalRecord> {
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int accountId = sharedPrefsHelper.getInt('accountId') ?? 0;
  bool isLoading = false;
  List<String>? medicalRecord = [];
  final List<Map<String, String>> treatmentOptions = [
    {
      "name": "Gan",
      "image": "assets/img3D/treatment_medical/gan.png",
    },
    {
      "name": "Huyết áp",
      "image": "assets/img3D/treatment_medical/huyetap.png",
    },
    {
      "name": "Não",
      "image": "assets/img3D/treatment_medical/nao.png",
    },
    {
      "name": "Phổi",
      "image": "assets/img3D/treatment_medical/phoi.png",
    },
    {
      "name": "Thận",
      "image": "assets/img3D/treatment_medical/than.png",
    },
    {
      "name": "Tiểu đường",
      "image": "assets/img3D/treatment_medical/tieuduong.png",
    },
    {
      "name": "Tim mạch",
      "image": "assets/img3D/treatment_medical/timmach.png",
    },
    {
      "name": "Xương khớp",
      "image": "assets/img3D/treatment_medical/xuong.png",
    },
    {
      "name": "Khác",
      "image": "assets/img3D/form_medical/khac.png",
    },
  ];
  bool isEditMode = false;
  List<String> updatedMedicalRecord = [];
  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    getMedicalRecord();
  }

  void _checkForChanges() {
    bool hasChangesNow = !_areListsEqual(medicalRecord!, updatedMedicalRecord);
    setState(() {
      hasChanges = hasChangesNow;
    });
  }

  // Helper method to compare lists
  bool _areListsEqual(List<String>? list1, List<String> list2) {
    if (list1 == null) return false;
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  void getMedicalRecord() async {
    setState(() {
      isLoading = true;
    });
    HomeController homeController = HomeController();
    await homeController.getMedicalRecord(widget.elderlyId ?? accountId);
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        if (homeController.medicalRecord != null) {
          medicalRecord = homeController.medicalRecord;
        } else {
          medicalRecord = [];
        }
        if (medicalRecord != null) {
          updatedMedicalRecord = List<String>.from(medicalRecord!);
        } else {
          updatedMedicalRecord = [];
        }
        isLoading = false;
        hasChanges = false;
        isEditMode = false;
      });
    });
  }

  void handleSaveData() async {
    setState(() {
      isLoading = true;
    });
    HomeController homeController = HomeController();
    await homeController.updateMedicalRecord(accountId, updatedMedicalRecord);
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (homeController.isUpdateMedicalSuccess) {
        getMedicalRecord();
        CherryToast.success(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Cập nhật thành công",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
      } else {
        setState(() {
          isLoading = false;
        });
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Cập nhật thất bại",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
      }
    });
  }

  void showAddDialog(BuildContext context) {
    List<Map<String, String>> remainingOptions = treatmentOptions
        .where((option) => !updatedMedicalRecord.contains(option["name"]))
        .toList();

    String? selected;
    String customInput = "";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(16),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Chọn hồ sơ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 250,
                    width: double.maxFinite,
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: remainingOptions.map((option) {
                        final isSelected = selected == option["name"];
                        return GestureDetector(
                          onTap: () {
                            setStateDialog(() {
                              selected = option["name"];
                              customInput = "";
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor.withOpacity(0.2)
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(option["image"]!, height: 50),
                                const SizedBox(height: 8),
                                Text(option["name"]!,
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (selected == "Khác")
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextField(
                        decoration:
                            const InputDecoration(hintText: "Nhập hồ sơ khác"),
                        onChanged: (value) => customInput = value,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Hủy"),
                ),
                ElevatedButton(
                  onPressed: () {
                    String finalName = selected == "Khác"
                        ? customInput.trim()
                        : selected ?? "";
                    if (finalName.isNotEmpty &&
                        !updatedMedicalRecord.contains(finalName)) {
                      setState(() {
                        updatedMedicalRecord.add(finalName);
                      });
                      _checkForChanges();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text("Thêm",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      )),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text("Hồ sơ bệnh án",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryColor,
            )),
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
        actions: [
          if (!isEditMode && widget.elderlyId == null)
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.secondaryColor),
              onPressed: () {
                setState(() {
                  isEditMode = true;
                });
              },
            ),
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.cancel, color: AppColors.secondaryColor),
              onPressed: () {
                setState(() {
                  isEditMode = false;
                  updatedMedicalRecord = List<String>.from(medicalRecord!);
                  hasChanges = false;
                });
              },
            ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
                strokeWidth: 2,
              ),
            )
          : medicalRecord!.isEmpty
              ? const Center(
                  child: Text("Chưa có hồ sơ bệnh án nào!"),
                )
              : Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 80), // leave space for button
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        children: updatedMedicalRecord.map((element) {
                          final matchedOption = treatmentOptions.firstWhere(
                            (option) => option["name"] == element,
                            orElse: () => {
                              "name": element,
                              "image": "assets/img3D/form_medical/khac.png",
                            },
                          );

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: Image.asset(
                                  matchedOption["image"]!,
                                  width: 70,
                                  height: 70,
                                ),
                                title: Text(matchedOption["name"]!,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondaryColor,
                                    )),
                                trailing: isEditMode
                                    ? IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            updatedMedicalRecord
                                                .remove(element);
                                          });
                                          _checkForChanges();
                                        },
                                      )
                                    : null,
                                onTap: () {},
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Save button floating at bottom
                    if (isEditMode)
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: hasChanges ? 100 : 20,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showAddDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.bgColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                color: AppColors.secondaryColor,
                                width: 2,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.add_circle_outline,
                              size: 25, color: AppColors.secondaryColor),
                          label: const Text('Thêm bệnh án',
                              style: TextStyle(
                                fontSize: 22,
                                color: AppColors.secondaryColor,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ),
                    if (isEditMode && hasChanges)
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 20,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            handleSaveData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: const Icon(Icons.save,
                              size: 25, color: AppColors.bgColor),
                          label: const Text('Lưu thay đổi',
                              style: TextStyle(
                                fontSize: 22,
                                color: AppColors.bgColor,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ),
                  ],
                ),
    );
  }
}
