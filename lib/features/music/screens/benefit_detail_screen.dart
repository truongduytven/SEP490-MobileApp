import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class BenefitDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String detailedContent;

  const BenefitDetailScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.detailedContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: _buildContentSection(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      iconTheme: IconThemeData(
        color: AppColors.bgColor,
      ),
      expandedHeight: 280,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: imageUrl,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildQuoteCard(context),
          const SizedBox(height: 24),
          _buildDetailedContent(),
          const SizedBox(height: 30),
          _buildScientificInfoCard(context),
          const SizedBox(height: 30),
          _buildRelatedTips(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.8),
            Theme.of(context).primaryColor.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.format_quote,
            color: Colors.white,
            size: 36,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              height: 1.5,
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lợi ích chi tiết',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            detailedContent,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScientificInfoCard(BuildContext context) {
    // Thông tin khoa học tương ứng với từng lợi ích
    final Map<String, List<Map<String, String>>> scientificInfoData = {
      'Giảm căng thẳng': [
        {
          'source': 'Đại học Stanford',
          'info':
              'Nhạc có nhịp điệu 60 nhịp/phút có thể giảm cortisol (hormone stress) đến 25%'
        },
        {
          'source': 'Journal of Music Therapy',
          'info':
              'Âm nhạc kích thích sản sinh endorphin - chất giảm đau tự nhiên của cơ thể'
        },
      ],
      'Tăng tập trung': [
        {
          'source': 'Journal of Neuroscience',
          'info': 'Nhạc Baroque giúp tăng khả năng tập trung lên 35%'
        },
        {
          'source': 'Hiệu ứng Mozart',
          'info':
              'Nhạc không lời với tiết tấu ổn định tạo "hiệu ứng Mozart" kích thích não bộ'
        },
      ],
      'Cải thiện giấc ngủ': [
        {
          'source': 'Sleep Medicine',
          'info':
              'Nghe nhạc êm dịu trước khi ngủ 45 phút giúp cải thiện chất lượng giấc ngủ 25%'
        },
        {
          'source': 'Nghiên cứu sóng não',
          'info':
              'Nhạc sóng alpha (8-13Hz) đồng bộ hóa với sóng não khi thư giãn'
        },
      ],
      'Tăng hiệu suất tập luyện': [
        {
          'source': 'Sport Sciences',
          'info': 'Nhạc có BPM 120-140 giúp tăng hiệu suất tập luyện 15-20%'
        },
        {
          'source': 'Journal of Sports Medicine',
          'info': 'Âm nhạc làm giảm cảm giác mệt mỏi và tăng sức bền'
        },
      ],
      'Cải thiện tâm trạng': [
        {
          'source': 'McGill University',
          'info': 'Nghe nhạc yêu thích làm tăng dopamine lên 9%'
        },
        {
          'source': 'Neuroimage',
          'info':
              'Âm nhạc kích thích sản sinh dopamine - chất dẫn truyền thần kinh tạo cảm giác vui vẻ'
        },
      ],
    };

    final dataList = scientificInfoData[title] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.science, size: 24),
            SizedBox(width: 8),
            Text(
              'Cơ sở khoa học',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...dataList
            .map((data) => _buildScienceItem(data['source']!, data['info']!)),
      ],
    );
  }

  Widget _buildScienceItem(String source, String info) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                source,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            info,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedTips(BuildContext context) {
    // Tips tương ứng với từng loại lợi ích
    final Map<String, List<String>> tips = {
      'Giảm căng thẳng': [
        'Tạo danh sách phát riêng cho các khoảng thời gian căng thẳng',
        'Thử nghe nhạc thiên nhiên kết hợp với thiền 10 phút',
        'Tìm nhạc có nhịp độ 60-80 BPM để đồng bộ với nhịp tim khi thư giãn'
      ],
      'Tăng tập trung': [
        'Sử dụng tai nghe chống ồn khi nghe nhạc tập trung',
        'Thử kỹ thuật Pomodoro: 25 phút làm việc với nhạc không lời',
        'Tạo không gian làm việc yên tĩnh kết hợp với nhạc nền nhẹ nhàng'
      ],
      'Cải thiện giấc ngủ': [
        'Thiết lập danh sách phát nhạc ngủ tự động tắt sau 30-45 phút',
        'Tránh nhạc có lời và nhạc kích thích trước khi đi ngủ',
        'Kết hợp âm thanh trắng hoặc tiếng mưa nhẹ với nhạc thư giãn'
      ],
      'Tăng hiệu suất tập luyện': [
        'Tạo danh sách nhạc theo cường độ tập luyện tăng dần',
        'Điều chỉnh BPM phù hợp với loại hình tập luyện',
        'Đồng bộ nhịp nhạc với chuyển động cơ thể để tăng hiệu quả'
      ],
      'Cải thiện tâm trạng': [
        'Tạo danh sách các bài hát gợi nhớ kỷ niệm đẹp',
        'Thử thay đổi thể loại nhạc khi tâm trạng không tốt',
        'Kết hợp nghe nhạc với hoạt động yêu thích như đi bộ, vẽ'
      ],
    };

    final tipsList = tips[title] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.lightbulb_outline, size: 24),
            SizedBox(width: 8),
            Text(
              'Mẹo áp dụng',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.amber.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: tipsList
                .asMap()
                .entries
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
