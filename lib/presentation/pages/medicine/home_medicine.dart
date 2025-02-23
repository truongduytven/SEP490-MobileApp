import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/medicine/prescription_screen.dart';
import 'package:sep490/presentation/widgets/medicine/img_form.dart';
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
  int today = DateTime.now().day;
  final ScrollController _scrollController = ScrollController();
  late Map<String, dynamic> prescription = {};
  late Map<String, dynamic> prescriptionData = {
    "id": 1,
    "name": "Toa thuốc 1",
    "treatment": "viêm họng",
    "start_date": "2022-10-10",
    "medicines": [
      {
        "id": 1,
        'name': 'Paracetamol 500mg',
        'dosage': '1 viên',
        'form': 'Viên nhộng',
        'remaining': '31',
        'typeFrequency': 'Every',
        'frequencyEvery': '2',
        'frequencySelect': [],
        'mealTime': 'Trước ăn',
        'schedule': [
          {
            'time': '8:00',
            'status': 'skip',
          },
          {
            'time': '12:00',
            'status': 'used',
          },
          {
            'time': '18:00',
            'status': 'unUsed',
          }
        ],
      },
      {
        "id": 2,
        'name': 'Amoxicillin 500mg',
        'dosage': '1 viên',
        'form': 'Viên',
        'remaining': '31',
        'typeFrequency': 'Every',
        'frequencyEvery': '2',
        'frequencySelect': [],
        'mealTime': 'Trước ăn',
        'schedule': [
          {
            'time': '8:00',
            'status': 'skip',
          },
          {
            'time': '12:00',
            'status': 'used',
          },
          {
            'time': '18:00',
            'status': 'unUsed',
          }
        ],
      },
      {
        "id": 3,
        'name': 'Loratadine 10mg',
        'dosage': '1 viên',
        'form': 'Viên',
        'remaining': '31',
        'typeFrequency': 'Every',
        'frequencyEvery': '2',
        'frequencySelect': [],
        'mealTime': 'Trước ăn',
        'schedule': [
          {
            'time': '8:00',
            'status': 'skip',
          },
          {
            'time': '12:00',
            'status': 'used',
          },
          {
            'time': '18:00',
            'status': 'unUsed',
          }
        ],
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
    });
    getDataPrescription();
  }

  void getDataPrescription() {
    if (selectedDay == 20 && selectedMonth == 2 && selectedYear == 2025) {
      setState(() {
        prescription = prescriptionData;
      });
      categorizeMedicines();
    } else {
      setState(() {
        prescription = {};
      });
    }
  }

  Map<String, List<Map<String, dynamic>>> categorizeMedicines() {
    Map<String, List<Map<String, dynamic>>> categorized = {
      "morning": [],
      "lunch": [],
      "afternoon": [],
      "night": []
    };

    for (var medicine in prescription["medicines"]) {
      for (var schedule in medicine["schedule"]) {
        int minutes = convertToMinutes(schedule["time"]);

        Map<String, dynamic> data = {
          "time": schedule["time"],
          "status": schedule["status"],
        };

        if (minutes >= 5 * 60 && minutes < 12 * 60) {
          categorized["morning"]!.add({...medicine, "time": data});
        } else if (minutes >= 12 * 60 && minutes < 15 * 60) {
          categorized["lunch"]!.add({...medicine, "time": data});
        } else if (minutes >= 15 * 60 && minutes < 19 * 60) {
          categorized["afternoon"]!.add({...medicine, "time": data});
        } else {
          categorized["night"]!.add({...medicine, "time": data});
        }
      }
      ;
    }
    ;
    return categorized;
  }

  int convertToMinutes(String time) {
    final match = RegExp(r'(\d+):(\d+)?').firstMatch(time);
    if (match == null) return -1; // Invalid format
    int hours = int.parse(match.group(1)!);
    int minutes = match.group(2) != null ? int.parse(match.group(2)!) : 0;
    return hours * 60 + minutes;
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
        elevation: 0,
        scrolledUnderElevation: 0,
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
                              setState(() {
                                selectedDay = DateTime.now().day;
                                selectedMonth = DateTime.now().month;
                                selectedYear = DateTime.now().year;
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _scrollToSelectedDay();
                                  getDataPrescription();
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
              // 3D Box Illustration
              // Image.asset(
              //   'assets/img3D/thuocrong.png',
              //   height: 150,
              // ),
              // const SizedBox(height: 20),
              // Text(
              //   'Không có thuốc đặt lịch',
              //   style: TextStyle(
              //     fontSize: 22,
              //     fontWeight: FontWeight.w500,
              //     color: AppColors.grayColor3,
              //   ),
              // ),
              // const Spacer(),
              Expanded(
                  child: SingleChildScrollView(child: buildMedicineList())),
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
    if (prescription.isEmpty) {
      return Column(
        children: [
          // 3D Box Illustration
          Image.asset(
            'assets/img3D/thuocrong.png',
            height: 150,
          ),
          const SizedBox(height: 20),
          const Text(
            'Không có thuốc đặt lịch',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: AppColors.grayColor3,
            ),
          ),
        ],
      );
    }
    Map<String, List<Map<String, dynamic>>> categorizedMedicines =
        categorizeMedicines();

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

  Widget buildSession(
      String title, List<Map<String, dynamic>> medicines, String imgSession) {
    if (medicines.isEmpty) return const SizedBox();
    medicines = medicines
      ..sort((a, b) =>
          convertToMinutes(a["time"]['time']) -
          convertToMinutes(b["time"]['time']));

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
              TextButton(
                onPressed: () {
                  setState(() {
                    List<dynamic> updatedMedicines =
                        prescription["medicines"].map((med) {
                      List<dynamic> updatedSchedules =
                          med["schedule"].map((sched) {
                        bool shouldUpdate = medicines.any((sessionMed) =>
                            sessionMed["id"] == med["id"] &&
                            sessionMed["time"]["time"] == sched["time"]);
                        if (shouldUpdate) {
                          return {...sched, "status": "used"};
                        }
                        return sched;
                      }).toList();
                      return {...med, "schedule": updatedSchedules};
                    }).toList();

                    prescription = {
                      ...prescription,
                      "medicines": updatedMedicines
                    };
                  });
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
          children:
              medicines.map((medicine) => buildMedicineCard(medicine)).toList(),
        ),
      ],
    );
  }

  Widget buildMedicineCard(Map<String, dynamic> medicine) {
    return Container(
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
          buildImgForm(medicine["form"]),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine["name"],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Dùng ${medicine['dosage']} vào ${medicine['time']['time']} (${medicine['mealTime']})",
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.grayColor5),
                  ),
                  Text(
                    "${medicine['remaining']} viên còn lại",
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.grayColor5),
                  ),
                ],
              ),
            ),
          ),
          medicine['time']['status'] != 'unUsed'
              ? (medicine['time']['status'] == 'used'
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : Icon(Icons.cancel, color: Colors.red))
              : Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          prescription = {
                            ...prescription,
                            "medicines": prescription["medicines"].map((med) {
                              if (med["id"] == medicine["id"]) {
                                return {
                                  ...med,
                                  "schedule": med["schedule"].map((sched) {
                                    if (sched["time"] ==
                                        medicine["time"]["time"]) {
                                      return {
                                        ...sched,
                                        "status": "skip",
                                      };
                                    }
                                    return sched;
                                  }).toList(),
                                };
                              }
                              return med;
                            }).toList(),
                          };
                        });
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
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          prescription = {
                            ...prescription,
                            "medicines": prescription["medicines"].map((med) {
                              if (med["id"] == medicine["id"]) {
                                return {
                                  ...med,
                                  "schedule": med["schedule"].map((sched) {
                                    if (sched["time"] ==
                                        medicine["time"]["time"]) {
                                      return {
                                        ...sched,
                                        "status": "used",
                                      };
                                    }
                                    return sched;
                                  }).toList(),
                                };
                              }
                              return med;
                            }).toList(),
                          };
                        });
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
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
