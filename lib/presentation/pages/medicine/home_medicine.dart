import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/medicine/create_medicine.dart';
import 'package:sep490/theme/color.dart';
import 'package:intl/intl.dart';

class HomeMedicine extends StatefulWidget {
  const HomeMedicine({super.key});

  @override
  State<HomeMedicine> createState() => _HomeMedicineState();
}

class _HomeMedicineState extends State<HomeMedicine> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
    });
  }

  void _scrollToSelectedDay() {
    double scrollPosition = (selectedDay - 1) * 80;
    _scrollController.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    String weekDay = DateFormat('EEEE', 'vi')
        .format(
          DateTime(selectedYear, selectedMonth, selectedDay),
        )
        .toUpperCase();
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        title: Text(
          'Thuốc của tôi',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10), // Top spacing
            // Year and Month Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<int>(
                  value: selectedMonth,
                  items: List.generate(12, (index) => index + 1).map((month) {
                    return DropdownMenuItem<int>(
                      value: month,
                      child: Text('Tháng $month',
                          style: const TextStyle(fontSize: 20)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = value!;
                      selectedDay = 1;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToSelectedDay(); // Scroll to day 1
                      });
                    });
                  },
                ),
                DropdownButton<int>(
                  value: selectedYear,
                  items: List.generate(
                    2050 - 2025 + 1,
                    (index) => 2025 + index,
                  ).map((year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text('Năm $year',
                          style: const TextStyle(fontSize: 20)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value!;
                      selectedDay = 1;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToSelectedDay(); // Scroll to day 1
                      });
                    });
                  },
                ),
                Container(
                  decoration: BoxDecoration(),
                  width: 100,
                  child: ElevatedButton(
                    onPressed: (selectedDay != DateTime.now().day ||
                            selectedMonth != DateTime.now().month ||
                            selectedYear != DateTime.now().year)
                        ? () {
                            // Set selected day to today
                            setState(() {
                              selectedDay = DateTime.now().day;
                              selectedMonth = DateTime.now().month;
                              selectedYear = DateTime.now().year;

                              // Scroll to today's date
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _scrollToSelectedDay();
                              });
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                    child: const Text('Hôm nay',
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.bgColor,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Horizontal Date Selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Row(
                children: List.generate(daysInMonth, (index) {
                  int day = index + 1; // Days start from 1
                  bool isSelected = day == selectedDay;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDay = day;
                          _scrollToSelectedDay();
                        });
                      },
                      child: Container(
                        width: 64,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.secondaryColor
                              : AppColors.bgColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? Colors.transparent
                                  : AppColors.secondaryColor.withOpacity(0.3),
                              blurRadius: 1,
                              offset: const Offset(0, 0),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$day', // Display day number
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              DateFormat('EEE', 'vi').format(
                                  DateTime(selectedYear, selectedMonth, day)),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            // Selected Date Text
            Text(
              '$weekDay, NGÀY $selectedDay THÁNG $selectedMonth NĂM $selectedYear',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 50),
            // 3D Box Illustration
            Image.asset(
              'assets/img3D/thuocrong.png',
              height: 150,
            ),
            const SizedBox(height: 20),
            Text(
              'Không có thuốc đặt lịch',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColors.grayColor3,
              ),
            ),
            const Spacer(),
            // Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateMedicine(),
                  ),
                );
              },
              icon: const Icon(Icons.medical_services_outlined, size: 20, color: AppColors.bgColor,),
              label: const Text(
                'Chỉnh sửa hộp thuốc',
                style: TextStyle(fontSize: 22, color: AppColors.bgColor),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 25,
                ),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
