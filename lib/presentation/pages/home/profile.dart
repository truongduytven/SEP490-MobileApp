import 'dart:async';
import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/models/home_model.dart';
import 'package:sep490/presentation/pages/home/controller/home_controller.dart';
import 'package:sep490/presentation/pages/home/profile_screen.dart';
import 'package:sep490/presentation/widgets/auth_field.dart';
import 'package:sep490/theme/color.dart';
import 'package:table_calendar/table_calendar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController dateOfBirthController;
  late String gender;
  // ignore: unused_field
  late DateTime _focusedDay;
  String _selectedDate = '';
  // ignore: unused_field
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  bool isLoading = false;
  bool isEditing = false;
  bool hasChanged = false;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int accountId;
  late ElderlyProfile? elderlyProfile = null;
  File? _selectedImageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    accountId = sharedPrefsHelper.getInt("accountId") ?? 0;
    getProfileData();
  }

  void getProfileData() async {
    setState(() {
      isLoading = true;
    });
    HomeController homeController = HomeController();
    await homeController.getElderlyProfile(accountId);
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        elderlyProfile = homeController.elderlyProfile;
        isLoading = false;
      });
      sharedPrefsHelper.setString("avatar", elderlyProfile!.avatar);
      sharedPrefsHelper.setString("fullName", elderlyProfile!.fullName);
      initData();
    });
  }

  void initData() {
    fullNameController = TextEditingController(text: elderlyProfile!.fullName);
    emailController = TextEditingController(text: elderlyProfile!.email);
    phoneNumberController =
        TextEditingController(text: elderlyProfile!.phoneNumber);
    dateOfBirthController = TextEditingController(
        text: DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(elderlyProfile!.dateOfBirth)));
    gender =
        (elderlyProfile!.gender == "Male" || elderlyProfile!.gender == "Female")
            ? elderlyProfile!.gender
            : "Other";
    _selectedDate = DateFormat('dd/MM/yyyy')
        .format(DateTime.parse(elderlyProfile!.dateOfBirth));
  }

  void checkChanges() {
    bool changed = fullNameController.text != elderlyProfile!.fullName ||
        gender != elderlyProfile!.gender ||
        !isSameDate(DateFormat('dd/MM/yyyy').parse(_selectedDate),
            DateTime.parse(elderlyProfile!.dateOfBirth));
    setState(() {
      hasChanged = changed;
    });
  }

  bool isSameDate(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  void resetChanges() {
    fullNameController.text = elderlyProfile!.fullName;
    gender = elderlyProfile!.gender;
    dateOfBirthController = TextEditingController(
        text: DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(elderlyProfile!.dateOfBirth)));
    setState(() {
      hasChanged = false;
      isEditing = false;
    });
  }

  void handleSaveChanges() async {
    setState(() {
      isLoading = true;
    });
    String dobIso =
        DateFormat('dd/MM/yyyy').parse(_selectedDate).toIso8601String();
    HomeController homeController = HomeController();
    await homeController.updateElderlyProfile(
        accountId,
        fullNameController.text,
        _selectedImageFile != null ? _selectedImageFile!.path : "",
        gender,
        dobIso);
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        isEditing = false;
        hasChanged = false;
      });
      if (homeController.isUpdateSuccess) {
        CherryToast.success(
          toastDuration: Duration(seconds: 2),
          title: Text(
            "Cập nhật thông tin thành công!",
            style: TextStyle(color: Colors.black),
          ),
        ).show(context);
      } else {
        CherryToast.error(
          toastDuration: Duration(seconds: 2),
          title: Text(
            homeController.errorMessage ?? "Có lỗi trong quá trình xử lý!",
            style: TextStyle(color: Colors.black),
          ),
        ).show(context);
      }
      getProfileData();
    });
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chọn ảnh'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Máy ảnh'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Chọn từ thư viện'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
        hasChanged = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text("Thông tin cá nhân",
            style: TextStyle(
                color: AppColors.secondaryColor,
                fontSize: 25,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              if (isEditing) {
                resetChanges();
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
          )
        ],
      ),
      body: !isLoading
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Avatar
                  SizedBox(
                    height: 115,
                    width: 115,
                    child: Stack(
                      fit: StackFit.expand,
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          backgroundImage: _selectedImageFile != null
                              ? FileImage(_selectedImageFile!)
                              : NetworkImage(elderlyProfile!.avatar)
                                  as ImageProvider,
                        ),
                        if (isEditing)
                          Positioned(
                            right: -16,
                            bottom: 0,
                            child: SizedBox(
                              height: 46,
                              width: 46,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: const BorderSide(color: Colors.white),
                                  ),
                                  backgroundColor: const Color(0xFFF5F6F9),
                                ),
                                onPressed: _showImageSourceDialog,
                                child: SvgPicture.string(cameraIcon),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  AuthField(
                    hintText: "Họ và tên",
                    labelText: "Họ và tên",
                    controller: fullNameController,
                    isRequired: true,
                    isEnable: isEditing,
                    onChanged: (_) => checkChanges(),
                  ),

                  const SizedBox(height: 24),

                  // Email (read-only)
                  AuthField(
                    hintText: "Email",
                    labelText: "Email",
                    controller: emailController,
                    isRequired: true,
                    isEnable: false,
                    onChanged: (_) => checkChanges(),
                  ),

                  const SizedBox(height: 24),

                  // Phone number (read-only)
                  AuthField(
                    hintText: "Số điện thoại",
                    labelText: "Số điện thoại",
                    controller: phoneNumberController,
                    isRequired: true,
                    isEnable: false,
                    onChanged: (_) => checkChanges(),
                  ),

                  const SizedBox(height: 24),

                  DropdownButtonFormField2<String>(
                    value: gender.isNotEmpty ? gender : null,
                    items: const [
                      DropdownMenuItem(
                          value: "Male",
                          child: Text(
                            'Nam',
                            style: TextStyle(fontSize: 20),
                          )),
                      DropdownMenuItem(
                          value: "Female",
                          child: Text(
                            'Nữ',
                            style: TextStyle(fontSize: 20),
                          )),
                      DropdownMenuItem(
                          value: "Other",
                          child: Text(
                            'Khác',
                            style: TextStyle(fontSize: 20),
                          )),
                    ],
                    onChanged: isEditing
                        ? (item) {
                            setState(() {
                              gender = item ?? '';
                            });
                            checkChanges();
                          }
                        : null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng chọn giới tính';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabled: isEditing,
                      hintText: "Chọn giới tính",
                      labelText: "Giới tính",
                      labelStyle:
                          TextStyle(color: AppColors.textColor, fontSize: 19),
                      hintStyle:
                          TextStyle(fontSize: 20, color: AppColors.grayColor3),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide:
                            const BorderSide(color: AppColors.grayColor1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide:
                            const BorderSide(color: AppColors.grayColor1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide:
                            const BorderSide(color: AppColors.secondaryColor),
                      ),
                    ),
                    buttonStyleData: ButtonStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.bgColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: dateOfBirthController,
                    style: TextStyle(
                      fontSize: 20,
                      color: !isEditing
                          ? AppColors.grayColor3
                          : AppColors.secondaryColor,
                    ),
                    textInputAction: TextInputAction.next,
                    readOnly: true,
                    onTap: () async {
                      // ignore: unused_local_variable
                      DateTime? pickedDate = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            content: SizedBox(
                                height: 400,
                                width: 300,
                                child: CalendarDatePicker2(
                                  config: CalendarDatePicker2Config(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now()
                                        .subtract(Duration(days: 18 * 365)),
                                  ),
                                  value: _selectedDate.isNotEmpty
                                      ? [
                                          DateFormat('dd/MM/yyyy')
                                              .parse(_selectedDate)
                                        ]
                                      : [],
                                  onValueChanged: (dates) {
                                    if (dates.isNotEmpty) {
                                      setState(() {
                                        _selectedDate = DateFormat('dd/MM/yyyy')
                                            .format(dates.first);
                                        dateOfBirthController.text =
                                            _selectedDate;
                                      });
                                      checkChanges();
                                      Navigator.of(context).pop(dates.first);
                                    }
                                  },
                                )),
                          );
                        },
                      );
                    },
                    decoration: InputDecoration(
                      enabled: isEditing,
                      hintText: "Chọn ngày sinh",
                      labelText: "Ngày sinh",
                      labelStyle:
                          TextStyle(color: AppColors.textColor, fontSize: 19),
                      hintStyle:
                          TextStyle(color: AppColors.grayColor3, fontSize: 20),
                      suffix: SvgPicture.asset('assets/icons/calendarIcon.svg'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide:
                            const BorderSide(color: AppColors.grayColor1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide:
                            const BorderSide(color: AppColors.grayColor1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide:
                            const BorderSide(color: AppColors.secondaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng chọn ngày sinh';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  // Created date (read-only)
                  AuthField(
                    hintText: "Ngày tạo tài khoản",
                    labelText: "Ngày tạo tài khoản",
                    controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(elderlyProfile!.createdDate))),
                    isRequired: true,
                    isEnable: false,
                    onChanged: (_) => checkChanges(),
                  ),

                  const SizedBox(height: 32),

                  // Save button
                  if (isEditing && hasChanged)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: double.infinity,
                      color: Colors.transparent,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          handleSaveChanges();
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
            )
          : const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
                strokeWidth: 2,
              ),
            ),
    );
  }
}
