import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sep490/presentation/pages/medicine/create_presciption/create_prescription_screen.dart';
import 'package:sep490/presentation/widgets/auth_field.dart';
import 'package:sep490/theme/color.dart';
import 'package:table_calendar/table_calendar.dart';

class CreateTitlePrescription extends StatefulWidget {
  final String? endDate;
  final String? treatment;
  const CreateTitlePrescription({super.key, this.endDate, this.treatment});

  @override
  State<CreateTitlePrescription> createState() =>
      _CreateTitlePrescriptionState();
}

class _CreateTitlePrescriptionState extends State<CreateTitlePrescription> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController treatmentController = TextEditingController();
  late String _selectedDate;
  late DateTime _focusedDay;
  // ignore: unused_field
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDate = widget.endDate ?? '';
    treatmentController.text = widget.treatment ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    treatmentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tạo toa thuốc",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/background_app.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AuthField(
                labelText: "Điều trị bệnh",
                hintText: "Nhập bệnh đang điều trị",
                controller: treatmentController,
                focusNode: _focusNode,
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
                            locale: 'vi_VN',
                            firstDay: DateTime.now(),
                            lastDay: DateTime(2030),
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
                                final isSameDate =
                                    day.year == parsedDate.year &&
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
                  hintText: "Chọn ngày kết thúc thuốc",
                  labelText: "Ngày kết thúc",
                  labelStyle:
                      TextStyle(color: AppColors.textColor, fontSize: 20),
                  hintStyle:
                      TextStyle(color: AppColors.grayColor3, fontSize: 20),
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
                    borderSide:
                        const BorderSide(color: AppColors.secondaryColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn ngày kết thúc thuốc';
                  }
                  return null;
                },
                style: const TextStyle(fontSize: 20),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return CreatePrescriptionScreen(
                          endDate: _selectedDate,
                          treatment: treatmentController.text);
                    }));
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
                  "Tiếp theo",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
