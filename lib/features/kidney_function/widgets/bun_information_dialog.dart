import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class BunInformationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Đóng dialog
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Text(
                "Chỉ số BUN (Blood Urea Nitrogen)",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Chỉ số BUN là gì?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Chỉ số BUN (Blood Urea Nitrogen) đo lượng nitơ trong máu có nguồn gốc từ urea. Urea là sản phẩm cuối cùng của quá trình chuyển hóa protein trong cơ thể. Chỉ số BUN thường được sử dụng để đánh giá chức năng thận.",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Giá trị bình thường của BUN",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Giá trị bình thường của BUN thường nằm trong khoảng từ 7 đến 20 mg/dL (milligrams per deciliter).",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Nguyên nhân BUN cao",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "BUN cao có thể do các nguyên nhân sau:",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "- Suy thận\n- Mất nước\n- Chế độ ăn nhiều protein\n- Xuất huyết tiêu hóa",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Nguyên nhân BUN thấp",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "BUN thấp có thể do các nguyên nhân sau:",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "- Suy dinh dưỡng\n- Bệnh gan nặng\n- Uống quá nhiều nước",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
