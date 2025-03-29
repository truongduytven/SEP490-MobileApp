import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselWithSave extends StatefulWidget {
  @override
  _CarouselWithSaveState createState() => _CarouselWithSaveState();
}

class _CarouselWithSaveState extends State<CarouselWithSave> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> items = [
    {"name": "Item 1", "icon": Icons.home},
    {"name": "Item 2", "icon": Icons.star},
    {"name": "Item 3", "icon": Icons.favorite},
    {"name": "Item 4", "icon": Icons.settings},
    {"name": "Item 5", "icon": Icons.shopping_cart},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Prevents infinite height
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: items.map((item) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item["icon"], size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    item["name"],
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            print("Selected Item: ${items[_currentIndex]['name']}");
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
