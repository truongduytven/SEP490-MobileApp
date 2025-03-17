import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gif_view/gif_view.dart';
import 'package:latlong2/latlong.dart';
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

  @override
  void initState() {
    super.initState();
    isEmergencyList = widget.isEmergencyList;
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
    await emergencyController.getEmergencyList(widget.emergencyId);
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
      var results = await HereService.getNearbyHospitals(latUser, lngUser);

      setState(() {
        hospitals = results;
        userLat = position.latitude;
        userLng = position.longitude;
        isLoading = false;
      });
      print("Hospitals: $hospitals");
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
        await launchUrl(googleMapsWebUri,
            mode: LaunchMode.externalApplication);
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

  void _showHospitalInfo(Map<String, dynamic> hospital, BuildContext context) async {
    String address = 'Không có địa chỉ';
    String url = "https://revgeocode.search.hereapi.com/v1/revgeocode?at=${hospital["lat"]},${hospital["lon"]}&lang=vi-VN&apiKey=ssc7HJ2D3isw5gqCLduFMWE4Drrp5Z_Wsu1ZQ20NZtE";
    try {
      var response = await Dio().get(url);
      if (response.statusCode == 200) {
        address = response.data["items"][0]["address"]["label"];
      }
    } catch (e) {
      print("Lỗi khi mở trình duyệt: $e");
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(hospital["name"] ?? "Bệnh viện không có tên"),
          content: Column(
            children: [
              Text("Vị trí: (${hospital["lat"]}, ${hospital["lon"]})"),
              Text("Địa chỉ: $address"),
              Text("Số điện thoại: ${hospital["phone"] ?? "Không có số điện thoại"}"),
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
                  Text(widget.elderlyName,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                  SizedBox(
                    height: 10,
                  ),
                  Text('SĐT: ${widget.phoneNumber}',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: isEmergencyList
                  ? _buildEmergencyList()
                  : _buildEmergencyDetail(),
            )),
            Center(
              child: Text('Alo'),
            )
          ],
        ));
  }

  Widget _buildEmergencyList() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text('Danh sách thông tin khẩn cấp',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Ngày: 12/12/2021'),
                  subtitle: Text('Thời gian: 12:00'),
                  trailing: Icon(Icons.check_circle, color: Colors.green),
                );
              })
        ],
      ),
    );
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
            decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: Colors.white, size: 25),
                SizedBox(width: 8),
                Text(
                  'Vị trí người thân hiện tại',
                  style: TextStyle(
                      color: AppColors.bgColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: location,
                    initialZoom: 14.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: location,
                          width: 80.0,
                          height: 60.0,
                          child: Column(
                            children: [
                              Text("Người thân"),
                              Icon(Icons.person_pin_circle,
                                  color: Colors.red, size: 40),
                            ],
                          ),
                        ),
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
                      heroTag: "zoom_in",
                      onPressed: _zoomIn,
                      child: Icon(Icons.add),
                    ),
                    SizedBox(height: 10),
                    FloatingActionButton(
                      heroTag: "zoom_out",
                      onPressed: _zoomOut,
                      child: Icon(Icons.remove),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.camera_alt, color: Colors.white, size: 25),
                SizedBox(width: 8),
                Text(
                  'Hình ảnh từ camera người thân',
                  style: TextStyle(
                      color: AppColors.bgColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (emergencyInfo.frontCameraImage.isNotEmpty)
                Column(
                  children: [
                    Image.network(
                      emergencyInfo.frontCameraImage,
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

              // Rear Camera Image
              if (emergencyInfo.rearCameraImage.isNotEmpty)
                Column(
                  children: [
                    Image.network(
                      emergencyInfo.rearCameraImage,
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
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.local_hospital, color: Colors.white, size: 25),
                SizedBox(width: 8),
                Text(
                  'Bệnh viện gần người thân',
                  style: TextStyle(
                      color: AppColors.bgColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
