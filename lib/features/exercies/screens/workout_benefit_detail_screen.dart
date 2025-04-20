import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share_plus/share_plus.dart';

class WorkoutBenefitDetailScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const WorkoutBenefitDetailScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  State<WorkoutBenefitDetailScreen> createState() =>
      _WorkoutBenefitDetailScreenState();
}

class _WorkoutBenefitDetailScreenState extends State<WorkoutBenefitDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Nội dung chi tiết tương ứng với từng lợi ích
  final Map<String, Map<String, dynamic>> benefitDetails = {
    'Sức khỏe tim mạch': {
      'description':
          'Tập luyện thường xuyên giúp tăng cường chức năng tim mạch, giảm nguy cơ mắc các bệnh về tim và đột quỵ. Hoạt động thể chất làm tăng lưu thông máu, giảm huyết áp và cải thiện cholesterol.',
      'stats': [
        {'text': 'Giảm 35% nguy cơ bệnh tim mạch', 'percent': 0.35},
        {'text': 'Tăng 25% hiệu suất tim', 'percent': 0.25},
        {'text': 'Cải thiện 30% tuần hoàn máu', 'percent': 0.30}
      ],
      'recommendations': [
        {
          'name': 'Cardio 30 phút/ngày',
          'description': 'Chạy bộ, đạp xe hoặc bơi lội',
          'icon': Icons.directions_run
        },
        {
          'name': 'Bài tập HIIT 3 lần/tuần',
          'description': 'Tập luyện cường độ cao ngắt quãng',
          'icon': Icons.timer
        },
        {
          'name': 'Đi bộ nhanh hàng ngày',
          'description': '10.000 bước mỗi ngày',
          'icon': Icons.directions_walk
        },
      ],
      'videos': [
        {
          'title': 'Bài tập Tim mạch 15 phút',
          'thumbnail': 'https://example.com/cardio.jpg',
          'url': 'https://example.com/video1'
        },
        {
          'title': 'HIIT cho người mới bắt đầu',
          'thumbnail': 'https://example.com/hiit.jpg',
          'url': 'https://example.com/video2'
        },
      ],
      'icon': Icons.favorite,
      'color': Colors.redAccent,
    },
    'Tăng cường năng lượng': {
      'description':
          'Tập thể dục kích thích sản xuất endorphin và cải thiện hiệu quả của ty thể - nhà máy năng lượng của tế bào. Điều này giúp bạn cảm thấy tràn đầy sinh lực suốt cả ngày.',
      'stats': [
        {'text': 'Tăng 20% mức năng lượng', 'percent': 0.20},
        {'text': 'Giảm 40% cảm giác mệt mỏi', 'percent': 0.40},
        {'text': 'Cải thiện 35% chất lượng làm việc', 'percent': 0.35}
      ],
      'recommendations': [
        {
          'name': 'Yoga buổi sáng',
          'description': '15-20 phút mỗi buổi sáng',
          'icon': Icons.self_improvement
        },
        {
          'name': 'Bài tập ngắn giữa giờ',
          'description': '5 phút mỗi giờ làm việc',
          'icon': Icons.access_time
        },
        {
          'name': 'Thể dục nhịp điệu',
          'description': '30 phút, 3 lần/tuần',
          'icon': Icons.music_note
        },
      ],
      'videos': [
        {
          'title': 'Yoga buổi sáng 10 phút',
          'thumbnail': 'https://example.com/yoga.jpg',
          'url': 'https://example.com/video3'
        },
        {
          'title': 'Bài tập tăng năng lượng',
          'thumbnail': 'https://example.com/energy.jpg',
          'url': 'https://example.com/video4'
        },
      ],
      'icon': Icons.bolt,
      'color': Colors.amberAccent,
    },
    'Giảm căng thẳng': {
      'description':
          'Hoạt động thể chất làm giảm hormone stress cortisol và kích thích sản xuất endorphin - chất giảm đau tự nhiên của cơ thể, giúp tinh thần thư thái và cải thiện tâm trạng.',
      'stats': [
        {'text': 'Giảm 30% cortisol', 'percent': 0.30},
        {'text': 'Tăng 25% endorphin', 'percent': 0.25},
        {'text': 'Cải thiện 40% chất lượng giấc ngủ', 'percent': 0.40}
      ],
      'recommendations': [
        {
          'name': 'Thiền kết hợp vận động',
          'description': '20 phút mỗi ngày',
          'icon': Icons.spa
        },
        {
          'name': 'Đi bộ trong thiên nhiên',
          'description': '45-60 phút, 3 lần/tuần',
          'icon': Icons.nature
        },
        {
          'name': 'Bài tập thở với yoga',
          'description': '10 phút trước khi ngủ',
          'icon': Icons.air
        },
      ],
      'videos': [
        {
          'title': 'Thiền 10 phút mỗi ngày',
          'thumbnail': 'https://example.com/meditation.jpg',
          'url': 'https://example.com/video5'
        },
        {
          'title': 'Yoga thư giãn buổi tối',
          'thumbnail': 'https://example.com/relax.jpg',
          'url': 'https://example.com/video6'
        },
      ],
      'icon': Icons.self_improvement,
      'color': Colors.lightBlueAccent,
    },
  };

  @override
  Widget build(BuildContext context) {
    final detail = benefitDetails[widget.title] ?? {};
    final primaryColor = detail['color'] ?? AppColors.primaryColor;

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
            ),
      ),
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(primaryColor),
            SliverToBoxAdapter(
              child: AnimationLimiter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      _buildIntroSection(detail),
                      _buildStatisticsSection(detail),
                      _buildRecommendationsSection(detail),
                      _buildScienceSection(widget.title),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(Color primaryColor) {
    return SliverAppBar(
      iconTheme: IconThemeData(
        color: AppColors.bgColor,
      ),
      backgroundColor: AppColors.primaryColor,
      expandedHeight: 280,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: AppColors.bgColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: widget.imageUrl,
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  return progress == null
                      ? child
                      : Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(primaryColor),
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                      progress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                },
              ),
            ),
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

  Widget _buildIntroSection(Map<String, dynamic> detail) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                detail['icon'] as IconData? ?? Icons.fitness_center,
                size: 28,
                color: detail['color'] ?? AppColors.primaryColor,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.subtitle,
                  style: TextStyle(
                    fontSize: 18,
                    color: detail['color'] ?? AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            detail['description'] ?? '',
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(Map<String, dynamic> detail) {
    final stats = detail['stats'] as List<dynamic>? ?? [];
    final iconColor = detail['color'] ?? AppColors.primaryColor;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Thống kê ấn tượng', Icons.assessment, iconColor),
          const SizedBox(height: 20),
          ...stats.map((stat) => _buildStatItem(
                stat['text'],
                stat['percent'],
                detail['icon'] as IconData? ?? Icons.fitness_center,
                iconColor,
              )),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection(Map<String, dynamic> detail) {
    final recommendations = detail['recommendations'] as List<dynamic>? ?? [];
    final iconColor = detail['color'] ?? AppColors.primaryColor;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
              'Bài tập đề xuất', Icons.fitness_center, iconColor),
          SizedBox(height: 10),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final exercise = recommendations[index];
                return _buildExerciseCard(
                  exercise['name'],
                  exercise['description'],
                  exercise['icon'],
                  iconColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScienceSection(String benefit) {
    final Map<String, String> scienceInfo = {
      'Sức khỏe tim mạch':
          'Theo Hiệp hội Tim mạch Hoa Kỳ, tập thể dục 150 phút/tuần giảm 35% nguy cơ bệnh tim. '
              'Nghiên cứu đăng trên Tạp chí Y học Thể thao Anh chỉ ra tập luyện cải thiện chức năng tim.',
      'Tăng cường năng lượng':
          'Nghiên cứu từ Đại học Georgia cho thấy tập thể dục thường xuyên giảm mệt mỏi 65%. '
              'Tập luyện làm tăng ty thể - nhà máy sản xuất năng lượng trong tế bào.',
      'Giảm căng thẳng':
          'Nghiên cứu từ Đại học Harvard: tập thể dục 30 phút giảm cortisol 25%. '
              'Tập luyện kích thích sản sinh endorphin - thuốc giảm đau tự nhiên của cơ thể.',
    };

    final iconColor =
        benefitDetails[benefit]?['color'] ?? AppColors.primaryColor;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Cơ sở khoa học', Icons.science, iconColor),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  iconColor.withOpacity(0.1),
                  iconColor.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.school, color: iconColor),
                      SizedBox(width: 8),
                      Text(
                        'Nghiên cứu khoa học',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: iconColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    scienceInfo[benefit] ?? '',
                    style: const TextStyle(fontSize: 15, height: 1.6),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
      String stat, double percent, IconData icon, Color color) {
    final numRegex = RegExp(r'(\d+)%');
    final match = numRegex.firstMatch(stat);
    final valueText = match != null ? match.group(1) : '';
    final remainingText = stat.replaceFirst('$valueText%', '');

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 30.0,
            lineWidth: 5.0,
            percent: percent,
            center: Text(
              '$valueText%',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            progressColor: color,
            backgroundColor: Colors.grey.shade200,
            animation: true,
            animationDuration: 1500,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              remainingText,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(
      String name, String description, IconData icon, Color color) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        description,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Lợi ích:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '• Tăng cường sức bền\n• Cải thiện tuần hoàn máu\n• Tăng cường trao đổi chất',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Đã thêm "$name" vào lịch tập')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: 8),
                            Text('Thêm vào lịch tập'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 40, color: color),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
