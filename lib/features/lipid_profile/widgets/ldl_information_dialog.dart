import 'package:flutter/material.dart';

class LDLInformationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nút đóng dialog
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
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

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Thông Tin LDL (Low-Density Lipoprotein)",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),

                  SizedBox(height: 12),

                  // Nội dung về LDL
                  _buildSectionTitle("Vai trò của LDL:"),

                  _buildBulletPoint(
                      "LDL thường được gọi là “cholesterol xấu”."),
                  _buildBulletPoint(
                      "Vận chuyển cholesterol đến các tế bào trong cơ thể."),
                  _buildBulletPoint(
                      "Khi dư thừa, có thể tích tụ trong động mạch, gây xơ vữa."),
                  _buildBulletPoint(
                      "Tăng nguy cơ đau tim, đột quỵ nếu mức quá cao."),

                  SizedBox(height: 12),
                  _buildSectionTitle(
                      "Ngưỡng LDL bình thường cho người lớn trên 20 tuổi: <2.58 mmol/L"),
                  _buildBulletPoint("Ngưỡng cận cao: 3.36-4.11 mmol/L"),
                  _buildBulletPoint("Ngưỡng cao: 4.14-4.89 mmol/L."),
                  _buildBulletPoint("Ngưỡng rất cao: 4.91 mmol/L"),

                  SizedBox(height: 12),
                  _buildSectionTitle("Nguyên nhân gây LDL cao:"),
                  _buildBulletPoint(
                      "Chế độ ăn nhiều chất béo bão hòa, cholesterol."),
                  _buildBulletPoint("Lối sống ít vận động, béo phì."),
                  _buildBulletPoint(
                      "Tiểu đường, di truyền, căng thẳng kéo dài."),

                  SizedBox(height: 12),
                  _buildSectionTitle("Cách giảm LDL tự nhiên:"),
                  _buildBulletPoint("Ăn nhiều rau củ, thực phẩm giàu chất xơ."),
                  _buildBulletPoint("Bổ sung chất béo tốt từ cá, dầu ô liu."),
                  _buildBulletPoint("Tập thể dục ít nhất 30 phút mỗi ngày."),
                  _buildBulletPoint("Hạn chế đồ chiên rán, thức ăn nhanh."),
                  _buildBulletPoint("Bỏ thuốc lá, kiểm soát cân nặng."),

                  SizedBox(height: 20),

                  // 📚 Nguồn tham khảo
                  _buildSectionTitle("📚 Nguồn tham khảo:"),
                  _buildBulletPoint("Hiệp hội Tim mạch Hoa Kỳ (AHA)."),
                  _buildBulletPoint("Viện Sức khỏe Quốc gia Hoa Kỳ (NIH)."),
                  _buildBulletPoint("VINMEC"),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget tiêu đề phần
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.redAccent,
        ),
      ),
    );
  }

  // Widget hiển thị gạch đầu dòng
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
