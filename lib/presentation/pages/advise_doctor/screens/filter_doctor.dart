import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class FilterDoctor extends StatefulWidget {
  final List<String> listFilter;
  const FilterDoctor({super.key, required this.listFilter});

  @override
  State<FilterDoctor> createState() => _FilterDoctorState();
}

class _FilterDoctorState extends State<FilterDoctor> {
  List<String> listFilter = [];
  List<String> listFilterName = ['A-Z', 'Z-A'];
  List<String> listFilterStar = ['Tăng dần', 'Giảm dần'];

  @override
  void initState() {
    super.initState();
    listFilter = widget.listFilter;
  }

  void handleConfirm(BuildContext context) {
    Navigator.pop(context, listFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Bộ lọc tìm kiếm',
            style: const TextStyle(
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 25)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                listFilter.clear();
              });
            },
            icon: const Icon(Icons.cleaning_services),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildFilterSection('Sắp xếp tên', listFilterName),
            buildFilterSection('Sắp xếp theo số sao', listFilterStar),
            Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              width: double.infinity,
              color: Colors.transparent,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context, listFilter);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side:
                          BorderSide(color: AppColors.secondaryColor, width: 1),
                    )),
                icon: Icon(Icons.check, size: 25, color: AppColors.bgColor),
                label: const Text('Xác nhận',
                    style: TextStyle(
                      fontSize: 25,
                      color: AppColors.bgColor,
                      fontWeight: FontWeight.w400,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((e) => buildFilterButton(e)).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildFilterButton(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (label == 'A-Z' || label == 'Z-A') {
            listFilter.removeWhere((element) =>
                element == 'A-Z' || element == 'Z-A');
          } else if (label == 'Tăng dần' || label == 'Giảm dần') {
            listFilter.removeWhere((element) =>
                element == 'Tăng dần' || element == 'Giảm dần');
          }  
          if (listFilter.contains(label)) {
            listFilter.remove(label);
          } else { 
            listFilter.add(label);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              width: listFilter.contains(label) ? 2 : 1,
              color: listFilter.contains(label)
                  ? AppColors.primaryColor
                  : AppColors.secondaryColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: listFilter.contains(label) ? FontWeight.w600 : null,
            color: listFilter.contains(label)
                ? AppColors.primaryColor
                : AppColors.secondaryColor,
          ),
        ),
      ),
    );
  }
}
