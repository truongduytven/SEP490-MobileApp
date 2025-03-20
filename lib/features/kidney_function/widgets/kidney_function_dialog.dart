import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class KidneyFunctionInfoDialog extends StatelessWidget {

  const KidneyFunctionInfoDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
          // Tiêu đề
          Text(
            "Bảng Kết Luận Chức Năng Thận",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 16),
          // Bảng thông tin
          _buildInfoTable(),
          SizedBox(height: 20),
          // Nút đóng
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Đóng",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.bgColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Phương thức để xây dựng bảng thông tin
  Widget _buildInfoTable() {
    return Table(
      border: TableBorder.all(
        color: AppColors.borderColor,
        width: 1.0,
      ),
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(3),
        3: FlexColumnWidth(2),
      },
      children: [
        // Header của bảng
        TableRow(
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
          ),
          children: [
            _buildTableCell("Chỉ Số", isHeader: true),
            _buildTableCell("Giá Trị", isHeader: true),
            _buildTableCell("Kết Luận", isHeader: true),
            _buildTableCell("Nguồn Tham Khảo", isHeader: true),
          ],
        ),
        // Dữ liệu BUN
        _buildTableRow(
          "BUN",
          "< 7 mg/dL (2.5 mmol/L)",
          "Thấp: Có thể do suy dinh dưỡng, bệnh gan, hoặc uống quá nhiều nước.",
          "KDIGO Guidelines",
        ),
        _buildTableRow(
          "BUN",
          "7 - 20 mg/dL (2.5 - 7.1 mmol/L)",
          "Bình thường: Chức năng thận ổn định.",
          "National Kidney Foundation",
        ),
        _buildTableRow(
          "BUN",
          "> 20 mg/dL (7.1 mmol/L)",
          "Cao: Có thể do suy thận, mất nước, hoặc chế độ ăn nhiều protein.",
          "American Diabetes Association",
        ),
        // Dữ liệu GFR
        _buildTableRow(
          "GFR",
          "> 90 mL/min/1.73m²",
          "Bình thường: Chức năng thận tốt.",
          "KDIGO Guidelines",
        ),
        _buildTableRow(
          "GFR",
          "60 - 89 mL/min/1.73m²",
          "Suy giảm nhẹ: Cần theo dõi thêm.",
          "National Kidney Foundation",
        ),
        _buildTableRow(
          "GFR",
          "30 - 59 mL/min/1.73m²",
          "Suy giảm trung bình: Cần can thiệp y tế.",
          "American Diabetes Association",
        ),
        _buildTableRow(
          "GFR",
          "15 - 29 mL/min/1.73m²",
          "Suy giảm nặng: Cần điều trị tích cực.",
          "KDIGO Guidelines",
        ),
        _buildTableRow(
          "GFR",
          "< 15 mL/min/1.73m²",
          "Suy thận giai đoạn cuối: Cần lọc máu hoặc ghép thận.",
          "National Kidney Foundation",
        ),
        // Dữ liệu eGFR
        _buildTableRow(
          "eGFR",
          "> 90 mL/min/1.73m²",
          "Bình thường: Chức năng thận tốt.",
          "KDIGO Guidelines",
        ),
        _buildTableRow(
          "eGFR",
          "60 - 89 mL/min/1.73m²",
          "Suy giảm nhẹ: Cần theo dõi thêm.",
          "National Kidney Foundation",
        ),
        _buildTableRow(
          "eGFR",
          "30 - 59 mL/min/1.73m²",
          "Suy giảm trung bình: Cần can thiệp y tế.",
          "American Diabetes Association",
        ),
        _buildTableRow(
          "eGFR",
          "15 - 29 mL/min/1.73m²",
          "Suy giảm nặng: Cần điều trị tích cực.",
          "KDIGO Guidelines",
        ),
        _buildTableRow(
          "eGFR",
          "< 15 mL/min/1.73m²",
          "Suy thận giai đoạn cuối: Cần lọc máu hoặc ghép thận.",
          "National Kidney Foundation",
        ),
      ],
    );
  }

  // Phương thức để xây dựng một hàng trong bảng
  TableRow _buildTableRow(
      String label, String value, String conclusion, String reference) {
    return TableRow(
      children: [
        _buildTableCell(label),
        _buildTableCell(value),
        _buildTableCell(conclusion),
        _buildTableCell(reference),
      ],
    );
  }

  // Phương thức để xây dựng một ô trong bảng
  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 16 : 14,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? AppColors.primaryColor : AppColors.textColor,
        ),
      ),
    );
  }
}
