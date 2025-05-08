import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class TermToUse extends StatelessWidget {
  const TermToUse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text('Điều khoản sử dụng gói',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryColor)),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.bgColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            SizedBox(height: 10),
            buildTitle('1. Điều khoản sử dụng gói dịch vụ tư vấn bác sĩ từ xa'),
            buildText(
                '- Khi bạn mua gói dịch vụ bạn có thể đặt lịch hẹn với bác sĩ tư vấn từ xa.'),
            buildText(
                '- Bạn có thể đặt lịch hẹn với bác sĩ tư vấn từ xa trong thời gian gói dịch vụ còn hiệu lực và vẫn còn lượt đặt lịch.'),
            buildText(
                '- Bạn có thể tham gia buổi tư vấn khi thời gian bắt đầu cách hiện tại không quá 10 phút.'),
            buildText(
                '- Bạn có thể hủy lịch hẹn và số lượt đặt lịch sẽ được hoàn lại.'),
            buildTitle('2. Điều khoản với bác sĩ'),
            buildText(
                '- Bạn nhận được báo cáo khi hoàn tất buổi tư vấn với bác sĩ.'),
            buildText(
                '- Bạn có thể đánh giá bác sĩ sau khi hoàn tất buổi tư vấn.'),
            buildText(
                '- Trong quá trình tư vấn, hệ thống sẽ tự động chụp màn hình sau khoảng thời gian nhất định để đảm bảo chất lượng buổi tư vấn.'),
            buildText(
                '- Nếu có bất kỳ vấn đề gì xảy ra trong buổi tư vấn hoặc do bác sĩ, bạn có thể báo cáo cho chúng tôi thông qua chức năng báo cáo. (Ở màn hình chính chọn vào ảnh đại diện -> chọn báo cáo -> điền thông tin cần báo cáo -> gửi báo cáo và đợi sự liện hệ từ chúng tôi).'),
            buildTitle('3. Điều khoản với tiện ích'),
            buildText(
                '- Bạn có thể sử dụng tiện ích như chơi game, nghe nhạc, xem bài tập, đọc sách.'),
            buildText(
                '- Các tiện ích sẽ khả dụng khi thời gian gói còn hiệu lực.'),
            buildText(
                '- Nếu có bất kỳ vấn đề gì xảy ra trong việc tham gia tiện ích, bạn có thể báo cáo cho chúng tôi thông qua chức năng báo cáo. (Ở màn hình chính chọn vào ảnh đại diện -> chọn báo cáo -> điền thông tin cần báo cáo -> gửi báo cáo và đợi sự liện hệ từ chúng tôi).'),
          ],
        ),
      ),
    );
  }

  Widget buildText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: AppColors.textColor),
      ),
    );
  }

  Widget buildTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor),
      ),
    );
  }
}
