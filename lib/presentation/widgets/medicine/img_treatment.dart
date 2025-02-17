import 'package:flutter/material.dart';

Widget buildImgTreatment(String value) {
  String imgPath = 'assets/img3D/treatment_medical/huyetap.png';
  
  Map<String, String> treatmentImages = {
    'Tiểu đường': 'assets/img3D/treatment_medical/tieuduong.png',
    'Tim mạch': 'assets/img3D/treatment_medical/timmach.png',
    'Não': 'assets/img3D/treatment_medical/nao.png',
    'Gan': 'assets/img3D/treatment_medical/gan.png',
    'Phổi': 'assets/img3D/treatment_medical/phoi.png',
    'Thận': 'assets/img3D/treatment_medical/than.png',
    'Xương khớp': 'assets/img3D/treatment_medical/xuong.png',
    'Khác': 'assets/img3D/form_medical/khac.png',
  };

  // Nếu có key tương ứng, gán lại imgPath
  imgPath = treatmentImages[value] ?? imgPath;

  return CircleAvatar(
    backgroundColor: Colors.blue[50],
    radius: 20,
    child: Image.asset(imgPath, width: 30, height: 30),
  );
}
