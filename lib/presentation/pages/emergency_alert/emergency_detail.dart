import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gif_view/gif_view.dart';
import 'package:latlong2/latlong.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/models/emergency.dart';
import 'package:sep490/presentation/pages/emergency_alert/controller/emergency_controller.dart';
import 'package:sep490/presentation/pages/emergency_alert/here_servies.dart';
import 'package:sep490/presentation/pages/emergency_alert/location_service.dart';
import 'package:sep490/theme/color.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyDetail extends StatefulWidget {
  final String elderlyName;
  final String phoneNumber;
  final int emergencyId;
  final int elderlyId;
  final bool isEmergencyList;
  const EmergencyDetail(
      {super.key,
      required this.elderlyName,
      required this.phoneNumber,
      required this.emergencyId,
      required this.elderlyId,
      required this.isEmergencyList});

  @override
  State<EmergencyDetail> createState() => _EmergencyDetailState();
}

class _EmergencyDetailState extends State<EmergencyDetail> {
  late bool isEmergencyList = false;
  late List<EmergencyInformation> emergencyInformationList = [];
  bool isLoading = false;
  late final MapController _mapController = MapController();
  double? userLat, userLng;
  List hospitals = [];
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int accountId = 0;

  @override
  void initState() {
    super.initState();
    isEmergencyList = widget.isEmergencyList;
    accountId = sharedPrefsHelper.getInt('accountId') ?? 0;
    if (isEmergencyList) {
      _getEmergencyList();
    } else {
      _getEmergencyDetail();
    }
  }

  void _getEmergencyList() async {
    setState(() {
      isLoading = true;
    });
    EmergencyController emergencyController = EmergencyController();
    await emergencyController.getEmergencyListDetail(widget.emergencyId);
    Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
        emergencyInformationList = emergencyController.emergencyInformationList;
      });
    });
  }

  void _getEmergencyDetail() async {
    setState(() {
      isLoading = true;
    });
    EmergencyController emergencyController = EmergencyController();
    await emergencyController.getEmergencyDetail(widget.emergencyId);
    Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
        if (emergencyController.emergencyInformation != null) {
          emergencyInformationList
              .add(emergencyController.emergencyInformation!);
        }
      });
      if (emergencyController.emergencyInformation != null) {
        loadHospitals(emergencyController.emergencyInformation!.latitude,
            emergencyController.emergencyInformation!.longitude);
      }
    });
  }

  Future<void> loadHospitals(String lat, String lng) async {
    setState(() {
      isLoading = true;
    });
    try {
      double latUser = double.tryParse(lat) ?? double.nan;
      double lngUser = double.tryParse(lng) ?? double.nan;
      var position = await LocationService.getCurrentLocation();
      var results = [];
      if (!isEmergencyList) {
        results = await HereService.getNearbyHospitals(latUser, lngUser);
      }
      setState(() {
        hospitals = results;
        userLat = position.latitude;
        userLng = position.longitude;
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi khi tải bệnh viện: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _openGoogleMaps(double latitude, double longitude) async {
    final Uri googleMapsAppUri =
        Uri.parse("geo:$latitude,$longitude?q=$latitude,$longitude");
    final Uri googleMapsWebUri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

    try {
      bool canOpenApp = await canLaunchUrl(googleMapsAppUri);

      if (canOpenApp) {
        await launchUrl(googleMapsAppUri);
      } else {
        await launchUrl(googleMapsWebUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Error launching URL: $e");
    }
  }

  void _zoomIn() {
    _mapController.move(
        _mapController.camera.center, _mapController.camera.zoom + 1);
  }

  void _zoomOut() {
    _mapController.move(
        _mapController.camera.center, _mapController.camera.zoom - 1);
  }

  void _focusLocation(LatLng location) {
    _mapController.move(location, 17.0);
  }

  void _showHospitalInfo(
      Map<String, dynamic> hospital, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(hospital["name"] ?? "Bệnh viện không có tên"),
          content: Column(
            children: [
              Text("Vị trí: (${hospital["lat"]}, ${hospital["lon"]})"),
              Text("Địa chỉ: ${hospital["address"]}"),
              Text("Số điện thoại: ${hospital["phone"]}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  void _showDialogConfirm(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(10),
          title: Text("Xác nhận hỗ trợ",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
          content: Text(
              "Bạn có chắc chắn muốn xác nhận hỗ trợ cho người thân? Khi xác nhận hệ thống sẽ ngưng thông báo vị trí cũng như sẽ không thông báo đến bác sĩ và 115.",
              style: TextStyle(fontSize: 22)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Hủy", style: TextStyle(fontSize: 20)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() {
                  isLoading = true;
                });
                EmergencyController emergencyController = EmergencyController();
                await emergencyController.confirmEmergencyInformation(
                    widget.emergencyId, accountId);
                Timer(Duration(seconds: 1), () {
                  if (emergencyController.isConfirmedSuccess) {
                    setState(() {
                      isLoading = false;
                      isEmergencyList = true;
                    });
                    _getEmergencyList();
                  }
                });
              },
              child: Text("Xác nhận", style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri.parse("tel:$phoneNumber");

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print("Không thể thực hiện cuộc gọi đến số $phoneNumber");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          title: Text(
            'Chi tiết thông tin khẩn cấp',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
          ),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.bgColor,
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${widget.elderlyName} - ${widget.phoneNumber}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      emergencyInformationList.isNotEmpty
                          ? 'Thời gian: ${emergencyInformationList.first.informationTime} ${emergencyInformationList.first.informationDate}'
                          : '',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.grayColor3)),
                  if (emergencyInformationList.isNotEmpty && !isEmergencyList)
                    Text(
                        'Trạng thái: ${emergencyInformationList.first.isConfirmed ? "Đã xác nhận" : "Đang đợi xác nhận"}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.grayColor3)),
                  if (emergencyInformationList.isNotEmpty && isEmergencyList)
                    Text(
                        'Xác nhận bởi: ${emergencyInformationList.first.confirmationAccountName}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.grayColor3)),
                  if (emergencyInformationList.isNotEmpty && isEmergencyList)
                    Text(
                        'Thời gian xác nhận: ${emergencyInformationList.first.confirmationTime} ${emergencyInformationList.first.confirmationDate}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.grayColor3)),
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: _buildEmergencyDetail(),
            )),
            if (!isEmergencyList)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                width: double.infinity,
                color: Colors.transparent,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showDialogConfirm(context);
                  },
                  icon: Icon(Icons.check_circle,
                      size: 25, color: AppColors.bgColor),
                  label: Text('Xác nhận hỗ trợ',
                      style: TextStyle(
                        fontSize: 25,
                        color: AppColors.bgColor,
                      )),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 25,
                    ),
                    backgroundColor: AppColors.secondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: AppColors.iconColor)),
                    shadowColor: AppColors.secondaryColor,
                  ),
                ),
              ),
          ],
        ));
  }

  Widget _buildEmergencyDetail() {
    if (isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: GifView.asset(
            'assets/gif/sos_loading.gif',
            width: 100,
            height: 100,
            frameRate: 60,
          ),
        ),
      );
    }
    if (emergencyInformationList.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
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
              Text('Không có thông tin khẩn cấp'),
            ],
          ),
        ),
      );
    }

    EmergencyInformation emergencyInfo = emergencyInformationList.first;
    double lat = double.tryParse(emergencyInfo.latitude) ?? double.nan;
    double lng = double.tryParse(emergencyInfo.longitude) ?? double.nan;
    final LatLng location = LatLng(lat, lng);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vị trí người thân hiện tại',
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: location,
                    initialZoom: 17.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    ),
                    MarkerLayer(
                      markers: [
                        ...emergencyInformationList.map((e) => (Marker(
                              point: LatLng(double.tryParse(e.latitude) ?? 0,
                                  double.tryParse(e.longitude) ?? 0),
                              width: 80.0,
                              height: 80.0,
                              child: Column(
                                children: [
                                  Text(
                                    "Người thân",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(e.confirmationTime),
                                  Icon(Icons.person_pin_circle,
                                      color: Colors.red, size: 40),
                                ],
                              ),
                            ))),
                        Marker(
                          point: LatLng(userLat ?? 0, userLng ?? 0),
                          width: 50.0,
                          height: 60.0,
                          child: Column(
                            children: [
                              Text("Bạn"),
                              Icon(Icons.person_pin_circle,
                                  color: Colors.blue, size: 40),
                            ],
                          ),
                        ),
                        if (!isEmergencyList)
                          ...hospitals.map((hospital) {
                            return Marker(
                              point: LatLng(hospital["lat"], hospital["lon"]),
                              width: 50.0,
                              height: 50.0,
                              child: GestureDetector(
                                onTap: () {
                                  _showHospitalInfo(hospital, context);
                                },
                                child: Icon(Icons.local_hospital,
                                    color: Colors.red, size: 30),
                              ),
                            );
                          }),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Column(
                  children: [
                    FloatingActionButton(
                      mini: true,
                      heroTag: "focus_location",
                      onPressed: () => _focusLocation(location),
                      child: Icon(Icons.gps_fixed),
                    ),
                    SizedBox(height: 10),
                    FloatingActionButton(
                      mini: true,
                      heroTag: "zoom_in",
                      onPressed: _zoomIn,
                      child: Icon(Icons.add),
                    ),
                    SizedBox(height: 10),
                    FloatingActionButton(
                      mini: true,
                      heroTag: "zoom_out",
                      onPressed: _zoomOut,
                      child: Icon(Icons.remove, size: 30),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          if (!isEmergencyList)
            Center(
              child: GestureDetector(
                onTap: () {
                  _openGoogleMaps(10.8539804, 106.6698322);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.red, size: 30),
                    Text(
                      'Hoặc xem chi tiết bằng Google Maps',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blue, decoration: TextDecoration.underline, decorationColor: Colors.blue),
                      
                    ),
                  ],
                ),
              ),
            ),
          if (!isEmergencyList) SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hình ảnh từ camera người thân',
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          ...emergencyInformationList.map((element) {
            return Column(
              children: [
                SizedBox(height: 10),
                Text(
                  'Thời gian: ${emergencyInfo.confirmationTime} ${emergencyInfo.confirmationDate}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (element.frontCameraImage.isNotEmpty)
                      Column(
                        children: [
                          Image.network(
                            element.frontCameraImage,
                            width: MediaQuery.of(context).size.width / 2 - 20,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10),
                          Text('Camera trước',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    SizedBox(width: 10),
                    if (element.rearCameraImage.isNotEmpty)
                      Column(
                        children: [
                          Image.network(
                            element.rearCameraImage,
                            width: MediaQuery.of(context).size.width / 2 - 20,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10),
                          Text('Camera sau',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                        ],
                      ),
                  ],
                ),
              ],
            );
          }),
          SizedBox(height: 20),
          if(!isEmergencyList)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bệnh viện gần người thân',
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          if(!isEmergencyList)
          SizedBox(height: 20),
          if(!isEmergencyList)
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: hospitals.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> hospital = hospitals[index];
              return ListTile(
                title: Text(hospital["name"] ?? "Bệnh viện không có tên"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hospital["phone"] ?? "Không có số điện thoại"),
                    Text(hospital["address"] ?? "Không có địa chỉ"),
                  ],
                ),
                trailing: hospital["phone"] != "Không có số điện thoại"
                    ? IconButton(
                        icon: Icon(Icons.phone),
                        onPressed: () => _makePhoneCall(hospital["phone"]),
                      )
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
