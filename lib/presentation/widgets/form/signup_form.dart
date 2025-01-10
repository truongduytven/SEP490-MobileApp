import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sep490/presentation/pages/auth/otp_screen.dart';
import 'package:sep490/presentation/widgets/auth_field.dart';
import 'package:sep490/theme/color.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:table_calendar/table_calendar.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String _selectedDate = '';
  String _selectedGender = '';
  late DateTime _focusedDay; // This stores the focused date
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
  }

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AuthField(
            labelText: "Họ và tên",
            hintText: "Nhập họ tên",
            controller: fullNameController,
          ),
          const SizedBox(height: 16),

          // Email Field
          AuthField(
            labelText: "Email",
            hintText: "Nhập email",
            controller: emailController,
            suffixIcon: SvgPicture.asset('assets/icons/mailIcon.svg'),
            keyboardType: TextInputType.emailAddress, // Optional keyboard type
          ),
          const SizedBox(height: 16),

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
          const SizedBox(height: 16),

          TextFormField(
            controller: TextEditingController(
                text: _selectedDate), // Set the selected date here

            textInputAction: TextInputAction.next,
            readOnly: true,
            onTap: () async {
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
                        calendarFormat:
                            CalendarFormat.month, // Basic month view
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false, // Hide format button
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
                            _calendarFormat =
                                format; // Toggle between month and year view
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

          // Phone Number Field
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: AuthField(
              labelText: "Số điện thoại",
              hintText: "Nhập số điện thoại",
              controller: phoneController,
              keyboardType: TextInputType.numberWithOptions(),
              suffixIcon: SizedBox(
                  height: 20,
                  child: SvgPicture.asset('assets/icons/phoneIcon.svg')),
            ),
          ),

          // Password Field
          AuthField(
            labelText: "Mật khẩu",
            hintText: "Nhập mật khẩu",
            controller: passwordController,
            isObscureText: true, // Obscure the password
            suffixIcon: SvgPicture.asset('assets/icons/lockIcon.svg'),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.05),

          // Submit Button
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                print('Email/Số điện thoại: ${emailController.text}');
                print('Mật khẩu: ${passwordController.text}');
                print('Họ tên: ${fullNameController.text}');
                print('Email: ${emailController.text}');
                print('Ngày sinh: $_selectedDate');
                print('Giới tính: $_selectedGender');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtpScreen(),
                  ),
                );
              }
            },
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
