import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/controllers/doctor_controller.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/checkout.dart';
import 'package:sep490/theme/color.dart';

class PackageList extends StatefulWidget {
  const PackageList({super.key});

  @override
  State<PackageList> createState() => _PackageListState();
}

class _PackageListState extends State<PackageList> {
  late List<ComboData>? comboData = null;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  bool isLoading = false;
  List<List<Color>> gradientColors = [
    [Colors.orange, Colors.deepOrange],
    [Colors.pink, Colors.purple],
    [Colors.green, Colors.teal],
    [Colors.indigo, Colors.blue],
    [Colors.redAccent, Colors.red],
  ];
  late int selectedElderly = 0;
  late int roleId = 0;

  @override
  void initState() {
    super.initState();
    selectedElderly = sharedPrefsHelper.getInt('selectedElderlyUserId') ?? 0;
    roleId = sharedPrefsHelper.getInt('roleId') ?? 0;
    getComboData();
  }

  void getComboData() async {
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.getComboData();
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (doctorController.comboData != null) {
        if (doctorController.comboData!.isEmpty) {
          setState(() {
            comboData = null;
            isLoading = false;
          });
        } else {
          setState(() {
            comboData = doctorController.comboData!
                .where((element) => element.status == 'Active')
                .toList();
            isLoading = false;
          });
        }
      } else {
        setState(() {
          comboData = doctorController.comboData;
          isLoading = false;
        });
      }
    });
  }

  void _showPackageDetails(BuildContext context, ComboData package) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 20),
              Text(package.name,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor)),
              const SizedBox(height: 15),
              Text('${convertMoney(package.fee)} VND',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),
              const Text('Mô tả:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(package.description),
              const SizedBox(height: 15),
              const Text('Ngày khả dụng:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${package.validityPeriod} ngày (kể từ ngày mua)'),
              const SizedBox(height: 15),
              const Text('Số lần gặp nhau:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${package.numberOfMeeting} lần gặp/tháng'),
              const SizedBox(height: 15),
              const Text('Cập nhật gần nhất:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${package.updatedTime} ${package.updatedDate}'),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Checkout(
                            comboData: package,
                          ),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15)),
                  child: const Text('Thanh toán ngay',
                      style: TextStyle(fontSize: 18, color: AppColors.bgColor)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Danh sách gói dịch vụ',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryColor)),
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/background_app.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading
            ? Center(
                child: GifView.asset(
                  'assets/gif/search_box.gif',
                  width: 100,
                  height: 100,
                  frameRate: 60,
                ),
              )
            : comboData == null || comboData!.isEmpty
                ? Center(
                    child: Text(
                      'Không có gói dịch vụ nào.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: comboData!.length,
                    itemBuilder: (context, index) {
                      final colors =
                          gradientColors[index % gradientColors.length];
                      final package = comboData![index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 3,
                        color: AppColors.bgColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _showPackageDetails(context, package),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 12,
                                  bottom: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: colors,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(package.name,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.bgColor)),
                                    Text('${convertMoney(package.fee)} VND',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.bgColor)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 16,
                                  bottom: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.bgColor,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(package.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            size: 16),
                                        const SizedBox(width: 4),
                                        Text('${package.validityPeriod} ngày'),
                                        const Spacer(),
                                        const Icon(Icons.people, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                            '${package.numberOfMeeting} lần gặp mặt/tháng'),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
