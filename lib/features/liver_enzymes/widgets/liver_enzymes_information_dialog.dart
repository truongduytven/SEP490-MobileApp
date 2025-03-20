import 'package:flutter/material.dart';

class LiverEnzymesInformationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              child: Icon(Icons.close, size: 24, color: Colors.black),
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
                  "Thông tin về Men gan ",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                SizedBox(height: 10),
                _buildSectionTitle(
                  "Men gan gồm 4 loại chính:",
                ),
                _buildBulletPoint("Alanine Transaminase (ALT)"),
                _buildBulletPoint("Aspartate Transaminase (AST)"),
                _buildBulletPoint("Phosphatase kiềm (ALP)"),
                _buildBulletPoint("Gamma Glutamyl Transpeptidase (GGT)"),
                SizedBox(height: 10),
                _buildBulletPoint(
                  "ALT và AST được tìm thấy bên trong tế bào gan, trong khi ALP nằm ở màng tế bào gan và GGT có trong thành tế bào ống mật.",
                ),
                SizedBox(height: 10),
                _buildSectionTitle(
                  "Chỉ số men gan bình thường:",
                ),
                _buildBulletPoint("ALT: 20 - 40 UI/L"),
                _buildBulletPoint("AST: 20 - 40 UI/L"),
                _buildBulletPoint("ALP: 30 - 110 UI/L"),
                _buildBulletPoint("GGT: 20 - 40 UI/L"),
                SizedBox(height: 10),
                _buildSectionTitle(
                  "Khi các chỉ số này vượt ngưỡng, đó là dấu hiệu của men gan cao, thường do:",
                ),
                _buildBulletPoint("Viêm gan do virus."),
                _buildBulletPoint("Uống nhiều bia rượu."),
                _buildBulletPoint(
                    "Dùng thuốc hạ sốt, giảm đau, hoặc thuốc hạ mỡ máu."),
                SizedBox(height: 10),
                Text(
                  "📚 Nguồn tham khảo:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("• Hiệp hội Tiêu hóa Hoa Kỳ (AGA)"),
                Text("• Viện Sức khỏe Quốc gia Hoa Kỳ (NIH)"),
                Text("• Mayo Clinic"),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
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
        Text("• ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
