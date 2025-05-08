import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:gif_view/gif_view.dart';
import 'package:intl/intl.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/main.dart';
import 'package:sep490/models/doctor.dart';
import 'package:sep490/presentation/pages/advise_doctor/controllers/doctor_controller.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/doctor_list.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/package_list.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/report_appointment.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/term_to_use.dart';
import 'package:sep490/presentation/pages/advise_doctor/screens/time_slot_doctor.dart';
import 'package:sep490/presentation/widgets/appointment/_infoChip.dart';
import 'package:sep490/presentation/widgets/appointment/buildAppointmentCard.dart';
import 'package:sep490/theme/color.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:month_year_picker/month_year_picker.dart';

class HomeDoctorAdviseScreen extends StatefulWidget {
  const HomeDoctorAdviseScreen({super.key});

  @override
  State<HomeDoctorAdviseScreen> createState() => _HomeDoctorAdviseScreenState();
}

class _HomeDoctorAdviseScreenState extends State<HomeDoctorAdviseScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver, RouteAware {
  final List<String> tabs = ['Lịch hẹn', 'Bác sĩ', 'Gói dịch vụ'];
  Map<String, String> statusOptions = {
    "Tất cả": "All",
    "Chưa tham gia": "NotYet",
    "Đã tham gia": "Joined",
    "Đã hủy": "Cancelled",
  };
  String selectedStatus = "All";
  late TabController _tabController;
  bool isLoading = false;
  late DoctorData? doctorData = null;
  late UserSubscription? packageData = null;
  late List<AppoimentDoctor>? appoimentDoctor = null;
  bool isLoadingAppointment = false;
  bool isPackage = false;
  List<String> endowments = [
    'Lựa chọn 1 bác sĩ riêng để hỗ trợ',
    'Tư vấn sức khỏe online hoặc offline',
    'Cảnh báo khi có chỉ số bất thường',
    'Hỗ trợ những trường hợp khẩn cấp',
    'Chỉ từ 50.000đ/tháng',
  ];
  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int accountId = 0;
  late int selectedElderlyUserId = 0;
  late String fullName = "";
  late String selectedElderlyUserName = "";
  late int roleId = 0;
  DateTime selectedDate = DateTime.now(); // Default to current date
  String selectedMonthYear = DateFormat('MM/yyyy').format(
      DateTime.now()); // Default to current month/year in "MM/yyyy" format
  final TextEditingController _dateController =
      TextEditingController(); // Default to current year (2025)

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    accountId = sharedPrefsHelper.getInt('accountId') ?? 0;
    selectedElderlyUserId =
        sharedPrefsHelper.getInt('selectedElderlyUserId') ?? 0;
    selectedElderlyUserName =
        sharedPrefsHelper.getString('selectedElderlyUserName') ?? "";
    fullName = sharedPrefsHelper.getString('fullName') ?? "";
    roleId = sharedPrefsHelper.getInt('roleId') ?? 0;
    initializeDateFormatting('vi_VN', null).then((_) {
      setState(() {
        selectedMonthYear = DateFormat('MM/yyyy', 'vi_VN').format(selectedDate);
        _dateController.text = selectedMonthYear;
      });
    });
    getDoctorData();
    checkIsPackage();
    _setupFirebaseListeners();
    WidgetsBinding.instance.addObserver(this);
  }

// Hàm thiết lập lắng nghe thông báo Firebase
  void _setupFirebaseListeners() {
    // Lắng nghe khi app đang mở
    _onMessageSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleNotification(message);
    });

    // Lắng nghe khi người dùng mở app từ thông báo
    _onMessageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotification(message);
    });
  }

  // Xử lý khi nhận được thông báo
  void _handleNotification(RemoteMessage message) {
    // Báo cáo tư vấn bác sĩ
    print("Message ${message.notification?.title}");
    if (message.notification?.title == "Báo cáo tư vấn bác sĩ") {
      getDoctorData();
      checkIsPackage();
    }
  }

  void getDoctorData() async {
    setState(() {
      isLoading = true;
      isLoadingAppointment = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.getDoctorData(
        selectedElderlyUserId == 0 ? accountId : selectedElderlyUserId);
    await doctorController.getAppointmentByID(
        selectedElderlyUserId == 0 ? accountId : selectedElderlyUserId,
        selectedStatus,
        selectedMonthYear);
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        doctorData = doctorController.doctorData;
        appoimentDoctor = doctorController.appoimentDoctor;
        if (appoimentDoctor != null) {
          appoimentDoctor!.sort((a, b) {
            final dateA = DateFormat("dd/MM/yyyy HH:mm").parse(a.dateTime);
            final dateB = DateFormat("dd/MM/yyyy HH:mm").parse(b.dateTime);
            return dateB.compareTo(dateA); // ascending
          });
        }
        isLoading = false;
        isLoadingAppointment = false;
      });
    });
  }

  void checkIsPackage() async {
    setState(() {
      isLoading = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.getPackageUser(
        selectedElderlyUserId == 0 ? accountId : selectedElderlyUserId);
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        packageData = doctorController.packageData;
        isPackage = packageData != null;
        isLoading = false;
      });
    });
  }

  void getAppointmentByStatus(String status, {String? month}) async {
    setState(() {
      isLoadingAppointment = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.getAppointmentByID(
        selectedElderlyUserId == 0 ? accountId : selectedElderlyUserId,
        status,
        selectedMonthYear);
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        appoimentDoctor = doctorController.appoimentDoctor;
        if (appoimentDoctor != null) {
          appoimentDoctor!.sort((a, b) {
            final dateA = DateFormat("dd/MM/yyyy HH:mm").parse(a.dateTime);
            final dateB = DateFormat("dd/MM/yyyy HH:mm").parse(b.dateTime);
            return dateB.compareTo(dateA); // ascending
          });
        }
        isLoadingAppointment = false;
      });
    });
  }

  Future<void> _selectMonthYear(BuildContext context) async {
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('vi', 'VN'),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            visualDensity: VisualDensity.compact, // Reduce space
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            textTheme: TextTheme(
              bodyMedium: TextStyle(fontSize: 14), // Smaller font
            ),
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 0.9, // Optional: smaller text globally
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4), // Reduce outer padding
              child: child!,
            ),
          ),
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedMonthYear = DateFormat('MM/yyyy', 'vi_VN').format(picked);
        _dateController.text = selectedMonthYear;
        getAppointmentByStatus(selectedStatus, month: selectedMonthYear);
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    routeObserver.unsubscribe(this);
    _onMessageSubscription?.cancel();
    _onMessageOpenedAppSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Đăng ký RouteAware để theo dõi sự kiện navigation
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      // Kiểm tra xem route có phải là PageRoute không
      routeObserver.subscribe(
          this,
          // ignore: unnecessary_cast
          route as PageRoute<dynamic>); // Ép kiểu thành PageRoute<dynamic>
    }
  }

  void showConfirmCancelAppointment(int appoinmentId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Xác nhận"),
          content: const Text("Bạn có chắc chắn muốn hủy cuộc hẹn này không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
                cancelAppointment(appoinmentId);
              },
              child: const Text("Xác nhận"),
            ),
          ],
        );
      },
    );
  }

  void cancelAppointment(int appointmentId) async {
    setState(() {
      isLoadingAppointment = true;
    });
    DoctorController doctorController = DoctorController();
    await doctorController.cancelAppointment(appointmentId, accountId);
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (doctorController.isCancelSuccess) {
        CherryToast.success(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Hủy cuộc hẹn thành công",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        getDoctorData();
        checkIsPackage();
        setState(() {
          isLoadingAppointment = false;
        });
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 3),
          title: Text(
            "Hủy cuộc hẹn thất bại",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ).show(context);
        setState(() {
          isLoadingAppointment = false;
        });
      }
    });
  }

  @override
  void didPopNext() {
    getDoctorData();
    checkIsPackage(); // Gọi lại API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(
            'Lịch hẹn của ${selectedElderlyUserName == "" ? fullName : selectedElderlyUserName}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25)),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
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
                    'assets/gif/sos_loading.gif',
                    width: 100,
                    height: 100,
                    frameRate: 60,
                  ),
                )
              : Padding(
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
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildTabContent(1),
                            _buildTabContent(2),
                            _buildTabContent(3),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
      floatingActionButton: (isPackage && _tabController.index == 0)
          ? FloatingActionButton(
              onPressed: () {
                final result = Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TimeSlotDoctor()));
                result.then((value) {
                  if (value != null) {
                    getDoctorData();
                    checkIsPackage();
                  }
                });
              },
              shape: CircleBorder(),
              backgroundColor: AppColors.secondaryColor,
              child: Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildTabContent(int index) {
    Widget checkTab() {
      switch (index) {
        case 1:
          return _buildSchdule();
        case 2:
          return _buildDoctor();
        case 3:
          return _buildPackage();
        default:
          return Container();
      }
    }

    return checkTab();
  }

  Widget _buildSchdule() {
    // ignore: unnecessary_null_comparison
    return Column(
      children: [
        Row(children: [
          // Status Dropdown
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(color: AppColors.grayColor1, width: 1),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedStatus,
                  onChanged: (String? newValue) {
                    if (selectedStatus == newValue) return;
                    setState(() {
                      selectedStatus = newValue!;
                      getAppointmentByStatus(newValue);
                    });
                  },
                  items: statusOptions.entries
                      .map<DropdownMenuItem<String>>((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: TextStyle(fontSize: 16),
                          ),
                          if (selectedStatus == entry.value)
                            Icon(
                              Icons.check,
                              color: AppColors.primaryColor,
                              size: 20,
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                  selectedItemBuilder: (context) {
                    return statusOptions.entries
                        .map<Widget>((entry) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(entry.key, style: TextStyle(fontSize: 16)),
                              ],
                            ))
                        .toList();
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          // Month Dropdown
          Expanded(
            child: GestureDetector(
              onTap: () => _selectMonthYear(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(color: AppColors.grayColor1, width: 1),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _dateController,
                        enabled: false, // Disable manual text input
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
        SizedBox(height: 10),
        (isLoading || isLoadingAppointment)
            ? Expanded(
                child: Center(
                  child: GifView.asset(
                    'assets/gif/sos_loading.gif',
                    width: 100,
                    height: 100,
                    frameRate: 60,
                  ),
                ),
              )
            : (appoimentDoctor != null && appoimentDoctor!.isNotEmpty)
                ? Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: appoimentDoctor!
                            .map((item) => BuildAppointmentCard(
                                  appoimentDoctor: item,
                                  onCancel: () async => {
                                    showConfirmCancelAppointment(
                                        item.professorAppointmentId)
                                  },
                                  onJoin: () => Future.value(),
                                  onReport: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReportAppointment(
                                                appoimentDoctor: item,
                                                isEdited: false,
                                              ))),
                                  isListCard: true,
                                ))
                            .toList(),
                      ),
                    ),
                  )
                : Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/img/no-data.png',
                            width: 70, height: 70),
                        SizedBox(height: 10),
                        Text('Không có dữ liệu',
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
      ],
    );
  }

  Widget _buildDoctor() {
    // ignore: unnecessary_null_comparison
    return doctorData != null
        ? SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileCard(),
                const SizedBox(height: 16),
                _buildInfoCard()
              ],
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/img/no-data.png', width: 70, height: 70),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('Dường như bạn chưa lựa chọn bác sĩ cho gói này!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.secondaryColor,
                      )),
                ),
                const SizedBox(height: 10),
                if (isPackage)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorList(
                            isChoosePackage: false,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                            color: AppColors.secondaryColor, width: 1),
                      ),
                    ),
                    child: Text('Chọn bác sĩ ngay',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.bgColor,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
              ],
            ),
          );
  }

  Widget _buildProfileCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    doctorData!.avatar,
                    width: 150,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        doctorData!.fullName,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor),
                      ),
                      Text(
                        doctorData!.clinicAddress,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.grayColor3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InfoChip(text: "⭐ ${doctorData!.rating}"),
                      const SizedBox(height: 8),
                      InfoChip(
                          text:
                              "Kinh nghiệm: ${doctorData!.experienceYears} năm"),
                      const SizedBox(height: 8),
                      InfoChip(
                          text: "Lĩnh vực: ${doctorData!.specialization[0]}"),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection("Học vấn", doctorData!.qualification),
                  _buildSection("Sự nghiệp", doctorData!.career),
                  _buildSection("Thành tựu", doctorData!.achievement),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<dynamic> content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        ...content.map((item) => Text(
              '• ${item.toString()}',
              style: TextStyle(fontSize: 20),
            )),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildPackage() {
    return packageData != null
        ? SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with background
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.9),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          packageData!.subscriptionName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow("Mô tả:", packageData!.description),
                            _buildInfoRow("Giá:",
                                "${convertMoney(packageData!.price)} VNĐ"),
                            _buildInfoRow(
                                "Thời gian bắt đầu:",
                                convertDateTimeToDateNoTime(
                                    packageData!.startDate)),
                            _buildInfoRow(
                                "Thời gian kết thúc:",
                                convertDateTimeToDateNoTime(
                                    packageData!.endDate)),
                            _buildInfoRow("Số buổi còn lại:",
                                "${packageData!.numberOfMeetingLeft} buổi"),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TermToUse(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Điều khoản sử dụng",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      decoration: TextDecoration.underline,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      decorationThickness: 2,
                                      color: AppColors.secondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PackageList(
                            isShowFull: false,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                            color: AppColors.secondaryColor, width: 1),
                      ),
                    ),
                    child: Text('Mua gói dịch vụ lẻ',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.bgColor,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                )
              ],
            ),
          )
        : SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageSlideshow(
                    indicatorColor: AppColors.primaryColor,
                    autoPlayInterval: 3000,
                    isLoop: true,
                    width: double.infinity,
                    height: 250,
                    initialPage: 0,
                    children: [
                      Image.network(
                        'https://cdn.youmed.vn/photos/67c3e343-bbab-46f2-950e-f11b86ecde6e.jpg',
                        fit: BoxFit.cover,
                      ),
                      Image.network(
                        'https://benhvienvietduc.org/wp-content/uploads/2018/11/bs-thanh.jpg',
                        fit: BoxFit.cover,
                      ),
                      Image.network(
                        'https://files.benhvien108.vn/ecm/source_files/2019/02/12/190212-2-090611-120219-57.jpg',
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            'Trải nghiệm ngay gói dịch vụ từ đội ngũ bác sĩ của chúng tôi',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor)),
                        SizedBox(height: 20),
                        ...endowments.map((e) => Row(
                              children: [
                                SizedBox(width: 4),
                                Icon(
                                  Icons.check,
                                  color: AppColors.primaryColor,
                                  size: 30,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  e,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.secondaryColor),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  if (roleId == 2 ||
                      (roleId == 3 && selectedElderlyUserId != 0))
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      width: double.infinity,
                      color: Colors.transparent,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PackageList(
                                        isShowFull: true,
                                      )));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                  color: AppColors.secondaryColor, width: 1),
                            )),
                        icon: Icon(Icons.payment,
                            size: 25, color: AppColors.bgColor),
                        label: const Text('Mua gói ngay',
                            style: TextStyle(
                              fontSize: 25,
                              color: AppColors.bgColor,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                    )
                  // : Text('Bạn hãy nhờ người thân mua gói dịch vụ cho bạn!',
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //         fontSize: 25,
                  //         fontWeight: FontWeight.w600,
                  //         color: AppColors.primaryColor)),
                ]),
          );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
