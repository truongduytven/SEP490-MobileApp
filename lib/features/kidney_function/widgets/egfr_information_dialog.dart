import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class EgfrInformationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dấu X để đóng dialog
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
        SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chỉ số eGFR (Estimated Glomerular Filtration Rate)",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Chỉ số eGFR là gì?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Chỉ số eGFR (Estimated Glomerular Filtration Rate) là ước tính mức độ lọc của cầu thận, giúp đánh giá chức năng thận. eGFR được tính dựa trên nồng độ creatinine trong máu, tuổi, giới tính và chủng tộc.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Giá trị bình thường của eGFR",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Giá trị bình thường của eGFR thường lớn hơn 90 mL/phút/1.73m². Giá trị dưới 60 mL/phút/1.73m² có thể cho thấy chức năng thận suy giảm.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Nguyên nhân eGFR thấp",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "eGFR thấp có thể do các nguyên nhân sau:",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "- Bệnh thận mãn tính\n- Suy thận cấp\n- Mất nước nghiêm trọng\n- Tắc nghẽn đường tiết niệu",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
