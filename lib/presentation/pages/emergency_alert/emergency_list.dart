import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:lottie/lottie.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/models/emergency.dart';
import 'package:sep490/presentation/pages/emergency_alert/controller/emergency_controller.dart';
import 'package:sep490/presentation/pages/emergency_alert/emergency_detail.dart';
import 'package:sep490/theme/color.dart';

class EmergencyList extends StatefulWidget {
  const EmergencyList({super.key});

  @override
  State<EmergencyList> createState() => _EmergencyListState();
}

class _EmergencyListState extends State<EmergencyList>
    with SingleTickerProviderStateMixin {
  late List<Emergency> emergencyList = [];
  bool isLoading = true;
  int accountId = 0;
  late List<Map<String, dynamic>> newEmergency = [];
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  final List<String> tabs = ['Tín hiệu khẩn cấp', 'Lịch sử'];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    accountId = sharedPrefsHelper.getInt('accountId') ?? 0;
    getEmergencyList();
  }

  void getEmergencyList() async {
    setState(() {
      isLoading = true;
    });
    EmergencyController emergencyController = EmergencyController();
    await emergencyController.getEmergencyList(accountId);
    Timer(Duration(seconds: 2), () {
      setState(() {
        emergencyList = emergencyController.emergencyList;
        isLoading = false;
      });
    });
  }

  bool checkishaveData() {
    if (emergencyList.isEmpty) {
      return false;
    }
    bool isHaveData = false;
    for (var element in emergencyList) {
      if (element.historyEmergency.isNotEmpty) {
        isHaveData = true;
        continue;
      }
    }
    return isHaveData;
  }

  bool checkNewEmergency() {
    bool isHaveNewEmergency = false;
    for (var element in emergencyList) {
      if (element.historyEmergency.isNotEmpty) {
        for (var e in element.historyEmergency) {
          if (!e.isConfirmed) {
            newEmergency.add({
              ...e.toJson(),
              'elderlyName': element.elderlyName,
              'phoneNumber': element.phoneNumber
            });
            isHaveNewEmergency = true;
          }
        }
      }
    }
    return isHaveNewEmergency;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          title: Text('Lịch sử khẩn cấp',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25)),
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.bgColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          actions: [
            Image.asset('assets/img/sos.png', width: 45, height: 45),
            SizedBox(
              width: 10,
            )
          ],
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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: AppColors.borderColor,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: TabBar(
                    dividerHeight: 0,
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.secondaryColor,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor: Colors.black,
                    labelColor: Colors.white,
                    labelStyle: const TextStyle(fontSize: 18),
                    tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: TabBarView(controller: _tabController, children: [
                  isLoading
                      ? Center(
                          child: GifView.asset(
                            'assets/gif/sos_loading.gif',
                            width: 100,
                            height: 100,
                            frameRate: 60,
                          ),
                        )
                      : checkNewEmergency()
                          ? SingleChildScrollView(
                              child: _buildNewEmergencyList(newEmergency))
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/img/no-data.png',
                                    width: 80,
                                    height: 80,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Hiện tại không có tín hiệu khẩn cấp',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                  isLoading
                      ? Center(
                          child: GifView.asset(
                            'assets/gif/sos_loading.gif',
                            width: 100,
                            height: 100,
                            frameRate: 60,
                          ),
                        )
                      : (checkishaveData()
                          ? SingleChildScrollView(
                              child: _buildEmergencyList(emergencyList))
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/img/no-data.png',
                                    width: 80,
                                    height: 80,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Không có dữ liệu',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            )),
                ]))
              ],
            ),
          ),
        ));
  }

  Widget _buildEmergencyList(List<Emergency> emergencyList) {
    return Column(
      children: emergencyList.map((e) {
        return _buildEmergencyItem(e);
      }).toList(),
    );
  }

  Widget _buildNewEmergencyList(List<Map<String, dynamic>> newEmergency) {
    return Column(
      spacing: 10,
      children: newEmergency.map((e) {
        return _buildNewEmergencyItem(e);
      }).toList(),
    );
  }

  Widget _buildEmergencyItem(Emergency emergency) {
    if (emergency.historyEmergency.isEmpty) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Người thân: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
            Text(emergency.elderlyName,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text("Số điện thoại: ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
            Text(emergency.phoneNumber,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 1,
          color: Colors.grey,
        ),
        Column(
          children: emergency.historyEmergency.map((e) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmergencyDetail(
                              elderlyName: emergency.elderlyName,
                              phoneNumber: emergency.phoneNumber,
                              emergencyId: e.emergencyConfirmationId,
                              elderlyId: e.elderlyId,
                              isEmergencyList: true,
                            )));
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                color: AppColors.bgColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  // side: const BorderSide(
                  //     color: AppColors.secondaryColor, width: 0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              e.isConfirmed
                                  ? Icon(
                                      Icons.circle,
                                      color: Colors.green,
                                      size: 10,
                                    )
                                  : Lottie.asset(
                                      'assets/img/AnimationRedDot.json',
                                      height: 50,
                                      width: 25),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                  e.isConfirmed
                                      ? 'Đã xác nhận'
                                      : 'Đang chờ hỗ trợ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: e.isConfirmed
                                          ? Colors.green
                                          : Colors.red)),
                            ],
                          ),
                          Text(
                            'Xem chi tiết ->',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.black,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text('Gửi lúc: ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400)),
                          Text('${e.emergencyTime} ${e.emergencyDate}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Xác nhận bởi: ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400)),
                          Text(
                              e.confirmationAccountName.isEmpty
                                  ? 'Chưa xác định'
                                  : e.confirmationAccountName,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Vào lúc: ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400)),
                          Text(
                              e.confirmationDate.isEmpty
                                  ? 'Chưa xác định'
                                  : convertDateTimeToString(e.confirmationDate),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget _buildNewEmergencyItem(Map<String, dynamic> emergency) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EmergencyDetail(
                    elderlyName: emergency['elderlyName'],
                    phoneNumber: emergency['phoneNumber'],
                    emergencyId: emergency['emergencyConfirmationId'],
                    elderlyId: emergency['elderlyId'],
                    isEmergencyList: false)));
      },
      child: Card(
        color: AppColors.bgColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  emergency['isConfirmed']
                      ? Icon(
                          Icons.circle,
                          color: Colors.green,
                          size: 10,
                        )
                      : Lottie.asset('assets/img/AnimationRedDot.json',
                          height: 50, width: 50),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                      emergency['isConfirmed']
                          ? 'Đã xác nhận'
                          : 'Đang chờ hỗ trợ',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: emergency['isConfirmed']
                              ? Colors.green
                              : Colors.red)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Người thân: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                  Text(emergency['elderlyName'],
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Số điện thoại: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  Text(emergency['phoneNumber'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Gửi lúc: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                  Text(
                      '${emergency['emergencyTime']} ${emergency['emergencyDate']}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
