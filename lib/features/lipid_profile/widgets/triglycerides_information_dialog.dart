import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class TriglyceridesInformationDialog extends StatelessWidget {
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
                    "Thông Tin Triglycerides",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Nội dung về Triglycerides
                  _buildSectionTitle("Vai trò của Triglycerides:"),
                  _buildBulletPoint(
                      "Dự trữ năng lượng từ chất béo trong cơ thể."),
                  _buildBulletPoint("Hình thành từ calo dư thừa khi ăn uống."),
                  _buildBulletPoint(
                      "Mức cao có thể làm tăng nguy cơ bệnh tim."),

                  SizedBox(height: 12),
                  _buildSectionTitle(
                      "Ngưỡng bình thường cho người lớn trên 20 tuổi: <1.7 mmol/L."),
                  _buildBulletPoint("Ngưỡng cận cao: 1.7-2.25 mmol/L."),
                  _buildBulletPoint("Ngưỡng cao: 2.26-5.64 mmol/L"),
                  _buildBulletPoint("Ngưỡng rất cao: >5.65 mmol/L"),

                  SizedBox(height: 12),
                  _buildSectionTitle("Nguyên nhân tăng Triglycerides:"),
                  _buildBulletPoint("Ăn quá nhiều đường, tinh bột, chất béo."),
                  _buildBulletPoint("Ít vận động, béo phì, thừa cân."),
                  _buildBulletPoint(
                      "Tiểu đường, rối loạn lipid máu, gan nhiễm mỡ."),
                  _buildBulletPoint("Uống rượu nhiều, hút thuốc lá."),

                  SizedBox(height: 12),
                  _buildSectionTitle("Cách giảm Triglycerides hiệu quả:"),
                  _buildBulletPoint("Hạn chế đường, tinh bột, thức ăn nhanh."),
                  _buildBulletPoint("Tập thể dục ít nhất 30 phút/ngày."),
                  _buildBulletPoint("Ăn nhiều rau xanh, chất xơ, cá béo."),
                  _buildBulletPoint("Bỏ thuốc lá, hạn chế rượu bia."),
                  _buildBulletPoint("Có thể cần thuốc điều trị nếu quá cao."),

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
