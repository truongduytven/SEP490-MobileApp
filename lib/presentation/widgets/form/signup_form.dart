import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sep490/presentation/pages/auth/medical_record.dart';
import 'package:sep490/presentation/widgets/auth_field.dart';
import 'package:sep490/theme/color.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';

class SignUpForm extends StatefulWidget {
  final String typeIn;
  const SignUpForm({super.key, required this.typeIn});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String _selectedDate = '';
  String _selectedGender = '';
  late DateTime _focusedDay;
  bool isButtonEnabled = false;
  // ignore: unused_field
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  File? _selectedAvatar;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController phoneController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    fullNameController.addListener(_onTextChanged);
    emailController.addListener(_onTextChanged);
    phoneController.addListener(_onTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    _loadSavedAvatar();
  }

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadSavedAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? avatarPath = prefs.getString('avatar');
    if (avatarPath != null && File(avatarPath).existsSync()) {
      setState(() {
        _selectedAvatar = File(avatarPath);
      });
    }
  }

  Future<void> _pickAvatar() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('avatar', imageFile.path);
      setState(() {
        _selectedAvatar = imageFile;
      });
    }
  }

  void _onTextChanged() {
    setState(() {
      isButtonEnabled = fullNameController.text.isNotEmpty &&
          (emailController.text.isNotEmpty ||
              phoneController.text.isNotEmpty) &&
          _selectedDate.isNotEmpty &&
          _selectedGender.isNotEmpty;
    });
  }

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (widget.typeIn == 'Phone') {
        prefs.setString('emailOrPhoneSignUpLater', emailController.text);
      } else if (widget.typeIn == 'Email') {
        prefs.setString('emailOrPhoneSignUpLater', phoneController.text);
      }
      prefs.setString('fullName', fullNameController.text);
      prefs.setString('dateOfBirth', _selectedDate);
      prefs.setString('gender', _selectedGender);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedicalRecordScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Image.asset(
          //   'assets/img3D/businessman.png',
          //   height: 150,
          // ),
          Text('Ảnh đại diện', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _pickAvatar,
            child: CircleAvatar(
              radius: 70,
              backgroundImage: _selectedAvatar != null
                  ? FileImage(_selectedAvatar!)
                  : AssetImage('assets/img/default_avatar.png')
                      as ImageProvider,
              child: _selectedAvatar == null
                  ? Icon(Icons.camera_alt, size: 30, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(height: 36),
          AuthField(
            labelText: "Họ và tên",
            hintText: "Nhập họ tên",
            controller: fullNameController,
            focusNode: _focusNode,
          ),
          const SizedBox(height: 24),

          // Email Field
          if (widget.typeIn == 'Phone number')
            AuthField(
              labelText: "Email",
              hintText: "Nhập email",
              controller: emailController,
              suffixIcon: SvgPicture.asset('assets/icons/mailIcon.svg'),
              keyboardType: TextInputType.emailAddress,
            ),
          if (widget.typeIn == 'Email')
            AuthField(
              labelText: "Số điện thoại",
              hintText: "Nhập số điện thoại",
              controller: phoneController,
              keyboardType: TextInputType.numberWithOptions(),
              suffixIcon: SizedBox(
                  height: 20,
                  child: SvgPicture.asset('assets/icons/phoneIcon.svg')),
            ),

          const SizedBox(height: 24),

          TextFormField(
            controller: TextEditingController(text: _selectedDate),
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
                      child: TableCalendar(
                        firstDay: DateTime(1900),
                        lastDay: DateTime.now(),
                        focusedDay: _focusedDay,
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month',
                          CalendarFormat.twoWeeks: 'Year',
                        },
                        selectedDayPredicate: (day) {
                          if (_selectedDate.isNotEmpty) {
                            final parsedDate = DateTime.parse(
                              "${_selectedDate.split('/')[2]}-${_selectedDate.split('/')[1].padLeft(2, '0')}-${_selectedDate.split('/')[0].padLeft(2, '0')}",
                            );
                            // Compare only the year, month, and day
                            final isSameDate = day.year == parsedDate.year &&
                                day.month == parsedDate.month &&
                                day.day == parsedDate.day;
                            return isSameDate;
                          }
                          return false;
                        },
                        calendarFormat: CalendarFormat.month,
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          leftChevronVisible: true,
                          rightChevronVisible: true,
                        ),
                        availableGestures: AvailableGestures.all,
                        calendarStyle: CalendarStyle(
                          selectedDecoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          Navigator.pop(context);
                          // Update the selected date when a day is selected
                          setState(() {
                            _selectedDate =
                                "${selectedDay.day}/${selectedDay.month}/${selectedDay.year}";
                            _focusedDay = focusedDay;
                            print(
                                'heheh ${selectedDay.day}/${selectedDay.month}/${selectedDay.year} hehe $focusedDay');
                          });
                        },
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            },
            decoration: InputDecoration(
              hintText: "Chọn ngày sinh",
              labelText: "Ngày sinh",
              labelStyle: TextStyle(color: AppColors.textColor, fontSize: 19),
              hintStyle: TextStyle(color: AppColors.grayColor3, fontSize: 20),
              suffix: SvgPicture.asset('assets/icons/calendarIcon.svg'),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: AppColors.grayColor1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: AppColors.grayColor1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: AppColors.primaryColor),
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
          // Gender Field using DropdownButton2
          DropdownButtonFormField2<String>(
            value: _selectedGender.isNotEmpty ? _selectedGender : null,
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
            onChanged: (gender) {
              setState(() {
                _selectedGender = gender ?? '';
              });
              _onTextChanged();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng chọn giới tính';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Chọn giới tính",
              labelText: "Giới tính",
              labelStyle: TextStyle(color: AppColors.textColor, fontSize: 19),
              hintStyle: TextStyle(fontSize: 20, color: AppColors.grayColor3),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: AppColors.grayColor1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: AppColors.grayColor1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: AppColors.primaryColor),
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),

          // Submit Button
          ElevatedButton(
            onPressed: isButtonEnabled
                ? () {
                    handleSubmit();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.secondaryColor,
              foregroundColor: AppColors.bgColor,
              minimumSize: const Size(double.infinity, 55),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            child: const Text(
              "Tiếp tục",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
