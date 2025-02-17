  import 'package:flutter/material.dart';

Widget buildImgForm(String value) {
    String imgPath = 'assets/img3D/form_medical/viennhong.png';
    if (value == 'Viên') {
      imgPath = 'assets/img3D/form_medical/vien.png';
    } else if (value == 'Ống') {
      imgPath = 'assets/img3D/form_medical/ong.png';
    } else if (value == 'Lần dùng') {
      imgPath = 'assets/img3D/form_medical/landung.png';
    } else if (value == 'Xịt') {
      imgPath = 'assets/img3D/form_medical/xit.png';
    } else if (value == 'Gói') {
      imgPath = 'assets/img3D/form_medical/goi.png';
    } else if (value == 'Khác') {
      imgPath = 'assets/img3D/form_medical/khac.png';
    }
    return CircleAvatar(
      backgroundColor: Color(0xFFE6E9FF),
      radius: 20,
      child: Image.asset(imgPath, width: 30, height: 30),
    );
  }