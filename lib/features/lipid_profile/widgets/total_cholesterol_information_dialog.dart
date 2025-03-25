import 'package:flutter/material.dart';

class TotalCholesterolInformationDialog extends StatelessWidget {
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
                    "Thông Tin Cholesterol toàn phần (TC - Total cholesterol)",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),

                  SizedBox(height: 12),

                  // Nội dung về LDL
                  _buildSectionTitle("Vai trò của TC: "),

                  _buildBulletPoint(
                      "Cholesterol toàn phần bao gồm tổng HDL, LDL và VLDL (very low density lipoprotein – không nằm trong bộ mỡ máu, thường chiếm 1/5 TC)."),
                  _buildBulletPoint(
                      "Cholesterol là thành phần quan trọng của màng tế bào."),
                  _buildBulletPoint(
                      "Cần thiết để sản xuất hormone và vitamin D."),
                  _buildBulletPoint(
                      "Mức cao có thể làm tăng nguy cơ bệnh tim mạch."),

                  SizedBox(height: 12),
                  _buildSectionTitle(
                      "Ngưỡng khuyến cáo cho người lớn trên 20 tuổi: <5.17 mmol/L."),
                  SizedBox(height: 12),

                  _buildSectionTitle("Nguyên nhân tăng Tổng Cholesterol:"),
                  _buildBulletPoint(
                      "Chế độ ăn nhiều chất béo bão hòa và cholesterol."),
                  _buildBulletPoint("Ít vận động, béo phì, thừa cân."),
                  _buildBulletPoint("Tiểu đường, tăng huyết áp."),
                  _buildBulletPoint(
                      "Yếu tố di truyền, tuổi tác, hút thuốc lá."),

                  SizedBox(height: 12),
                  _buildSectionTitle("Cách giảm Cholesterol hiệu quả:"),
                  _buildBulletPoint("Ăn nhiều rau xanh, chất xơ hòa tan."),
                  _buildBulletPoint("Bổ sung cá béo, dầu ô liu, hạt óc chó."),
                  _buildBulletPoint("Tập thể dục ít nhất 30 phút/ngày."),
                  _buildBulletPoint("Bỏ thuốc lá, hạn chế rượu bia."),
                  _buildBulletPoint("Có thể cần thuốc điều trị nếu quá cao."),

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
