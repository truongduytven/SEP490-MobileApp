import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class GfrInformationDialog extends StatelessWidget {
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
                  "Chỉ số GFR (Glomerular Filtration Rate)",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Chỉ số GFR là gì?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Chức năng thận được đánh giá chính xác hơn thông qua độ lọc cầu thận ước tính viết tắt là GFR, được ước đoán dựa vào nồng độ creatinine máu.Chỉ số GFR (Glomerular Filtration Rate) đo lường mức độ lọc của cầu thận, cho biết khả năng lọc chất thải từ máu của thận. GFR là một chỉ số quan trọng để đánh giá chức năng thận.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Giá trị bình thường của GFR",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Giá trị bình thường của GFR Nam: từ 0.6 đến 1.2 mg/dl (tức là 53-106 mmol/l).\nNữ: từ 0.5 đến 1.1 mg/dl (tức là 44-97 mmol/l).",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Nguyên nhân GFR thấp",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "GFR thấp có thể do các nguyên nhân sau:",
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
                Text(
                  "Triệu chứng của nồng độ creatinine cao",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Triệu chứng của bệnh thận đa dạng và thường ít biểu hiện ra lâm sàng ngay từ giai đoạn sớm và không tương xứng với sự tăng nồng độ creatinine. Ở một số người bệnh thận chỉ được phát hiện ngẫu nhiên, nồng độ creatinine máu cao mà không có biểu hiện triệu chứng.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Một số người khác có biểu hiện như: mệt mỏi, phù, khó thở, thiếu máu, tăng huyết áp, đái ít và một số triệu chứng không đặc hiệu khác như buồn nôn, nôn, da khô thì giai đoạn này đã suy thận rất nặng thường là suy thận giai đoạn cuối.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Nguyên nhân gây nồng độ creatinine trong máu tăng cao",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Suy thận do nguồn gốc trước thận: Suy tim mất bù, mất nước, xuất huyết, hẹp động mạch thận.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Suy thận do nguồn gốc tại thận: Tổn thương cầu thận (tăng huyết áp, đái tháo đường, viêm cầu thận, bệnh thận lupus hệ thống), tổn thương ống thận (viêm thận, bể thận cấp hay mạn, sỏi thận, đau tủy xương, tăng acid uric, nhiễm độc thận).",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Suy thận do nguồn gốc sau thận: Sỏi thận, ung thư tiền liệt tuyến, các khối u bàng quang, khối u tử cung.",
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
