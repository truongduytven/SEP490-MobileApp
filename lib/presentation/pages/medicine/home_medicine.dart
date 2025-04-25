import 'dart:async';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gif_view/gif_view.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/models/medicine/medicine.dart';
import 'package:sep490/presentation/pages/medicine/controller/medicine_controller.dart';
import 'package:sep490/presentation/pages/medicine/prescription_screen.dart';
import 'package:sep490/presentation/pages/navigation_menu.dart';
import 'package:sep490/presentation/widgets/medicine/img_form.dart';
import 'package:sep490/theme/color.dart';
import 'package:intl/intl.dart';

class HomeMedicine extends StatefulWidget {
  final int? selectedYear;
  final int? selectedMonth;
  final int? selectedDay;
  const HomeMedicine({super.key, this.selectedYear, this.selectedMonth, this.selectedDay});

  @override
  State<HomeMedicine> createState() => _HomeMedicineState();
}

class _HomeMedicineState extends State<HomeMedicine> {
  late int selectedYear;
  late int selectedMonth;
  late int selectedDay;
  int today = DateTime.now().day;
  final ScrollController _scrollController = ScrollController();
  Prescription? prescription;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  late int userId = sharedPrefsHelper.getInt('accountId')!;
  late int selectedElderlyUserId =
      sharedPrefsHelper.getInt('selectedElderlyUserId') ?? 0;
  late bool isLoading = true;
  int indexAnimation = 0;
  late int roleId = sharedPrefsHelper.getInt('roleId') ?? 0;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.selectedYear ?? DateTime.now().year;
    selectedMonth = widget.selectedMonth ?? DateTime.now().month;
    selectedDay = widget.selectedDay ?? DateTime.now().day;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
    });
    getDataPrescription();
  }

  void _scrollToSelectedDay() {
    double scrollPosition = (selectedDay - 1) * 80;
    _scrollController.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void getDataPrescription() async {
    setState(() {
      isLoading = true;
    });
    MedicineController medicineController = MedicineController();
    await medicineController.getMedicines(
        selectedElderlyUserId == 0 ? userId : selectedElderlyUserId,
        '$selectedYear-$selectedMonth-$selectedDay');
    Timer(Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        prescription = medicineController.prescription;
        isLoading = false;
      });
    });
  }

  Map<String, List<Map<String, dynamic>>> categorizeMedicines() {
    Map<String, List<Map<String, dynamic>>> categorized = {
      "morning": [],
      "lunch": [],
      "afternoon": [],
      "night": []
    };

    if (prescription == null) return categorized;
    for (var medicine in prescription!.medicines) {
      for (var schedule in medicine.schedule) {
        int minutes = convertToMinutes(schedule.time);

        Map<String, dynamic> data = {
          "time": convertTime(schedule.time),
          "status": schedule.status,
        };

        if (minutes >= 5 * 60 && minutes < 12 * 60) {
          categorized["morning"]!.add({...medicine.toJson(), "time": data});
        } else if (minutes >= 12 * 60 && minutes < 15 * 60) {
          categorized["lunch"]!.add({...medicine.toJson(), "time": data});
        } else if (minutes >= 15 * 60 && minutes < 19 * 60) {
          categorized["afternoon"]!.add({...medicine.toJson(), "time": data});
        } else {
          categorized["night"]!.add({...medicine.toJson(), "time": data});
        }
      }
    }
    return categorized;
  }

  int convertToMinutes(String time) {
    final match = RegExp(r'(\d+):(\d+)?').firstMatch(time);
    if (match == null) return -1; // Invalid format
    int hours = int.parse(match.group(1)!);
    int minutes = match.group(2) != null ? int.parse(match.group(2)!) : 0;
    return hours * 60 + minutes;
  }

  void handleConfirmMedicine(
      String time, int medicationId, String status) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> data = {
      "confirmations": [
        {
          "dateTaken":
              "$selectedYear-${selectedMonth < 10 ? "0$selectedMonth" : selectedMonth}-${selectedDay < 10 ? "0$selectedDay" : selectedDay} $time:00",
          "status": status,
          "medicationId": medicationId,
        }
      ]
    };
    MedicineController medicineController = MedicineController();
    await medicineController.confirmMedicine(data);
    if (medicineController.isConfirmSuccess) {
      Timer(Duration(seconds: 1), () {
        CherryToast.success(
            toastDuration: Duration(seconds: 2),
            title: Text("Xác nhận thành công!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ))).show(context);
        getDataPrescription();
      });
    } else {
      Fluttertoast.showToast(
        msg: "Có lỗi trong quá trình xử lý!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleAllConfirmMedicine(List<Map<String, dynamic>> medicines) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> data = {"confirmations": []};
    medicines
        .where((med) => med['time']['status'] == 'Unused')
        .forEach((medicine) {
      data["confirmations"].add({
        "dateTaken":
            "$selectedYear-${selectedMonth < 10 ? "0$selectedMonth" : selectedMonth}-${selectedDay < 10 ? "0$selectedDay" : selectedDay} ${medicine["time"]["time"]}:00",
        "status": "Taken",
        "medicationId": medicine["medicationId"],
      });
    });
    MedicineController medicineController = MedicineController();
    await medicineController.confirmMedicine(data);
    if (medicineController.isConfirmSuccess) {
      Timer(Duration(seconds: 1), () {
        CherryToast.success(
            toastDuration: Duration(seconds: 2),
            title: Text("Xác nhận thành công!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ))).show(context);
        getDataPrescription();
      });
    } else {
      Fluttertoast.showToast(
        msg: "Có lỗi trong quá trình xử lý!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        isLoading = false;
      });
    }
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
          'Lịch uống thuốc',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationMenu(
                  keyIndex: 0,
                ),
              ),
            );
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/background_app.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10), // Top spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: selectedMonth,
                      items:
                          List.generate(12, (index) => index + 1).map((month) {
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
                            getDataPrescription();
                          });
                          indexAnimation = 0;
                        });
                      },
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: selectedYear,
                      items: List.generate(
                        2030 - 2025 + 1,
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
                            getDataPrescription();
                          });
                          indexAnimation = 0;
                        });
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    width: 100,
                    child: ElevatedButton(
                      onPressed: (selectedDay != DateTime.now().day ||
                              selectedMonth != DateTime.now().month ||
                              selectedYear != DateTime.now().year)
                          ? () {
                              setState(() {
                                selectedDay = DateTime.now().day;
                                selectedMonth = DateTime.now().month;
                                selectedYear = DateTime.now().year;
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _scrollToSelectedDay();
                                  getDataPrescription();
                                });
                                indexAnimation = 0;
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
                    int day = index + 1;
                    bool isSelected = day == selectedDay;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDay = day;
                            getDataPrescription();
                            _scrollToSelectedDay();
                            indexAnimation = 0;
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
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                              Text(
                                DateFormat('EEE', 'vi').format(
                                    DateTime(selectedYear, selectedMonth, day)),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.secondaryColor,
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
                selectedDay == today
                    ? 'HÔM NAY, NGÀY $selectedDay THÁNG $selectedMonth NĂM $selectedYear'
                    : '$weekDay, NGÀY $selectedDay THÁNG $selectedMonth NĂM $selectedYear',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: isLoading
                      ? Center(
                          child: GifView.asset(
                            'assets/gif/a.gif',
                            width: 100,
                            height: 100,
                            frameRate: 90,
                          ),
                        )
                      : SingleChildScrollView(child: buildMedicineList())),
              // Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrescriptionScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.assignment,
                    size: 20,
                    color: AppColors.bgColor,
                  ),
                  label: const Text(
                    'Chi tiết toa thuốc',
                    style: TextStyle(fontSize: 22, color: AppColors.bgColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 25,
                    ),
                    backgroundColor: AppColors.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMedicineList() {
    Map<String, List<Map<String, dynamic>>> categorizedMedicines =
        categorizeMedicines();
    bool isAllEmpty = categorizedMedicines.values.every((list) => list.isEmpty);

    if (prescription == null || prescription!.medicines.isEmpty || isAllEmpty) {
      return Column(
        children: [
          const SizedBox(height: 50),
          Image.asset(
            'assets/img3D/thuocrong.png',
            height: 150,
          ),
          const SizedBox(height: 20),
          const Text(
            'Không có lịch uống thuốc nào trong ngày này',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: AppColors.grayColor3,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSession(
            "SÁNG", categorizedMedicines["morning"]!, 'assets/img3D/sang.png'),
        buildSession(
            "TRƯA", categorizedMedicines["lunch"]!, 'assets/img3D/trua.png'),
        buildSession("CHIỀU", categorizedMedicines["afternoon"]!,
            'assets/img3D/chieu.png'),
        buildSession(
            "TỐI", categorizedMedicines["night"]!, 'assets/img3D/toi.png'),
      ],
    );
  }

  bool _isWithinSessionTime(String session) {
    final now = DateTime.now();
    final currentHour = now.hour;
    final selectedDateTime = DateTime(selectedYear, selectedMonth, selectedDay);

    if(now.isBefore(selectedDateTime)) {
      return false; // The selected date is in the past
    }

    switch (session) {
      case "SÁNG":
        return currentHour >= 5;
      case "TRƯA":
        return currentHour >= 11;
      case "CHIỀU":
        return currentHour >= 15;
      case "TỐI":
        return currentHour >= 18;
      default:
        return false;
    }
  }

  Widget buildSession(
      String title, List<Map<String, dynamic>> medicines, String imgSession) {
    if (medicines.isEmpty) return const SizedBox();
    medicines = medicines
      ..sort((a, b) =>
          convertToMinutes(a["time"]['time']) -
          convertToMinutes(b["time"]['time']));

    bool allUsed = medicines.every((med) => med['time']['status'] != 'Unused');
    bool isWithinSessionTime = _isWithinSessionTime(title);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imgSession, width: 40, height: 40),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const Spacer(),
              if (!allUsed && roleId == 2 && isWithinSessionTime)
                TextButton(
                  onPressed: () {
                    handleAllConfirmMedicine(medicines);
                  },
                  child: Text(
                    "UỐNG TẤT CẢ",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
            ],
          ),
        ),
        Column(
          children: medicines
              .map((medicine) =>
                  buildMedicineCard(medicine, isWithinSessionTime))
              .toList(),
        ),
      ],
    );
  }

  Widget buildMedicineCard(
      Map<String, dynamic> medicine, bool isWithinSessionTime) {
    indexAnimation++;
    return TweenAnimationBuilder(
      tween: Tween<Offset>(
        begin: const Offset(0, 0.8), // Start slightly below
        end: const Offset(0, 0), // Move to normal position
      ),
      duration: Duration(milliseconds: 550 + (indexAnimation * 300)),
      curve: Curves.fastLinearToSlowEaseIn,
      builder: (context, Offset offset, child) {
        return Transform.translate(
          offset: offset * MediaQuery.of(context).size.height,
          child: Opacity(
            opacity: (1 - offset.dy), // Fade effect
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: AppColors.grayColor1,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            buildImgForm(medicine["shape"]),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine["medicationName"],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Dùng ${medicine['dosage']} vào ${medicine['time']['time']} (${medicine['isBeforeMeal'] ? 'Trước' : 'Sau'} bữa ăn)",
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.grayColor5),
                    ),
                    Text(
                      "${medicine['remaining'].toString()} viên còn lại",
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.grayColor5),
                    ),
                  ],
                ),
              ),
            ),
            medicine['time']['status'] != 'Unused'
                ? (medicine['time']['status'] == 'Taken'
                    ? Icon(Icons.check_circle, size: 30, color: Colors.green)
                    : Icon(Icons.cancel, size: 30, color: Colors.red))
                : isWithinSessionTime && roleId == 2
                    ? Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              handleConfirmMedicine(medicine['time']['time'],
                                  medicine['medicationId'], "Skip");
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                Icons.cancel_outlined,
                                color: AppColors.secondaryColor,
                                size: 30,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              handleConfirmMedicine(medicine['time']['time'],
                                  medicine['medicationId'], "Taken");
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                color: AppColors.secondaryColor,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
          ],
        ),
      ),
    );
  }
}
