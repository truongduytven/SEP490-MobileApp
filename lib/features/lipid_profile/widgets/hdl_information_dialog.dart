import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class HDLInformationDialog extends StatelessWidget {
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
            child: IconButton(
              icon: Icon(Icons.close, size: 24, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Tiêu đề
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Thông Tin HDL (High-Density Lipoprotein)",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
          ),

          SizedBox(height: 12),

          // Nội dung cuộn được
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection("Vai trò của HDL:", [
                    "HDL thường được gọi là “Cholesterol tốt.”"
                        "Loại bỏ cholesterol dư thừa, bảo vệ tim mạch.",
                    "Giảm nguy cơ xơ vữa động mạch.",
                    "Hỗ trợ chuyển hóa lipid, cải thiện sức khỏe tim.",
                  ]),
                  _buildSection(
                      "Ngưỡng HDL khuyến cáo cho người lớn trên 20 tuổi:", [
                    "Nam giới: < 1.03 mmol/L",
                    "Nữ giới: < 1.29 mmol/L",
                  ]),
                  _buildSection("Nguyên nhân khiến HDL thấp:", [
                    "Chế độ ăn nhiều tinh bột, chất béo không lành mạnh.",
                    "Hút thuốc lá, lối sống ít vận động.",
                    "Béo phì, tiểu đường type 2.",
                  ]),
                  _buildSection("Cách tăng HDL tự nhiên:", [
                    "Tập thể dục thường xuyên (đi bộ, bơi, chạy bộ).",
                    "Ăn uống lành mạnh: dầu ô liu, cá hồi, hạnh nhân.",
                    "Bỏ thuốc lá, duy trì cân nặng hợp lý.",
                    "Hạn chế đường và tinh bột tinh chế.",
                  ]),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  // Widget xây dựng một phần nội dung
  Widget _buildSection(String title, List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
        ),
        ...points.map((point) => _buildBulletPoint(point)).toList(),
        SizedBox(height: 16),
      ],
    );
  }

  // Widget hiển thị gạch đầu dòng
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 16)),
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
