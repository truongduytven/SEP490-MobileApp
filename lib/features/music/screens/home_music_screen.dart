import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sep490/features/music/screens/benefit_detail_screen.dart';
import 'package:sep490/features/music/screens/playlist_page.dart';
import 'dart:convert';

import 'package:sep490/features/music/widgets/neu_box.dart';
import 'package:sep490/theme/color.dart';

// 1. Define your themes in a separate file (theme_provider.dart)
final ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade700,
    surface: Colors.grey.shade800,
    onBackground: Colors.white,
    onSurface: Colors.white,
  ),
);

final ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary: Colors.grey.shade200,
    secondary: Colors.white,
    surface: Colors.white,
    onBackground: Colors.black,
    onSurface: Colors.black,
  ),
);

// 2. Theme Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(lightMode);

  void toggleTheme() {
    state = state == lightMode ? darkMode : lightMode;
  }

  bool get isDarkMode => state == darkMode;
}

// 3. HomeMusicScreen Implementation
class HomeMusicScreen extends ConsumerStatefulWidget {
  const HomeMusicScreen({super.key});

  @override
  ConsumerState<HomeMusicScreen> createState() => _HomeMusicScreenState();
}

class _HomeMusicScreenState extends ConsumerState<HomeMusicScreen> {
  List<dynamic> playlists = [];
  bool isLoading = true;
  String errorMessage = '';
  int _currentCarouselIndex = 0;
  final List<Map<String, dynamic>> carouselItems = [
    {
      'image':
          'https://t4.ftcdn.net/jpg/07/62/21/69/360_F_762216992_HjUZb565ohcpBh6R2rtal3JlOEf94XSX.jpg',
      'title': 'Sự kiện âm nhạc đặc biệt',
      'subtitle': 'Khám phá các nghệ sĩ hàng đầu'
    },
    {
      'image':
          'https://i.ytimg.com/vi/Rq5GeoLKJ7Y/hq720.jpg?sqp=-oaymwEXCK4FEIIDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLBv3JaoQy_pTkUsRnTq0AhlJCaMXQ',
      'title': 'Bản phát hành mới nhất',
      'subtitle': 'Nghe những bài hát mới nhất'
    },
    {
      'image':
          'https://avatar-ex-swe.nixcdn.com/topic/share/2022/12/29/7/1/c/b/1672295147154.jpg',
      'title': 'Bảng xếp hạng top hits',
      'subtitle': 'Những bài hát đang thịnh hành'
    },
  ];
  @override
  void initState() {
    super.initState();
    _fetchPlaylists();
  }

  Future<void> _fetchPlaylists() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.diavan-valuation.asia/content-management/all-music-playlist'),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          setState(() {
            playlists = (data['data'] as List)
                .where((playlist) =>
                    playlist['status'] == 'Active' &&
                    (playlist['numberOfContent'] as int) > 0)
                .toList();
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'Failed to load playlists';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load playlists (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider) == darkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: isDarkMode ? Colors.white : Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor:
            isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
        title: Text(
          'Âm nhạc',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade900,
            ),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: _buildBody(isDarkMode),
    );
  }

  Widget _buildBody(bool isDarkMode) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 45),
            Image.network(
              'https://cdn.pixabay.com/animation/2023/08/22/07/30/07-30-19-708_512.gif',
              height: 150,
              width: 150,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CircularProgressIndicator(
                  color: AppColors.primaryColor,
                );
              },
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.music_note, size: 100),
            ),
            const SizedBox(height: 20),
            Text(
              'Đang tải nhạc...',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black),
            ),
          ],
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          errorMessage,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
      );
    }

    if (playlists.isEmpty) {
      return Center(
        child: Text(
          'Không tìm thấy danh sách phát nào',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCarouselSlider(isDarkMode),
          const SizedBox(height: 12), // Giảm khoảng cách
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề với style đẹp hơn
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "DANH SÁCH PHÁT",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildPlaylistGrid(isDarkMode),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lợi ích của việc nghe nhạc",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildBenefitCard(
                          'https://media.suckhoecong.vn/thumb_x800x450/Images/Uploaded/Share/2015/04/12/bi-quyet-giam-stress-cho-nguoi-nghi-huu11428815986.jpg',
                          'Giảm căng thẳng',
                          'Nhạc nhẹ giúp thư giãn tinh thần'),
                      _buildBenefitCard(
                          'https://cdn.benhvienthucuc.vn/wp-content/uploads/2022/09/bieu-hien-cua-alzheimer-la-gi.jpg',
                          'Tăng tập trung',
                          'Nhạc không lời giúp làm việc hiệu quả'),
                      _buildBenefitCard(
                          'https://lmgworld.com/wp-content/uploads/2020/08/cach-ngu-ngon-cho-nguoi-gia.jpg',
                          'Cải thiện giấc ngủ',
                          'Nhạc êm dịu giúp ngủ ngon hơn'),
                      _buildBenefitCard(
                          'https://static.tuoitre.vn/tto/i/s626/2017/02/24/hinh-3-1487924858.jpg',
                          'Tăng hiệu suất tập luyện',
                          'Nhạc sôi động giúp tập trung hơn'),
                      _buildBenefitCard(
                          'https://cdn2.tuoitre.vn/thumb_w/480/2021/2/3/photo-1-1612317386495307179820.jpg',
                          'Cải thiện tâm trạng',
                          'Kích thích sản xuất dopamine'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistCard(Map<String, dynamic> playlist, bool isDarkMode) {
    return Card(
      color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaylistPage(
                playlistId: playlist['playlistId'].toString(),
                playlistName: playlist['playlistName'],
                imageUrl: playlist['imageUrl'],
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    playlist['imageUrl'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: isDarkMode
                          ? Colors.grey.shade700
                          : Colors.grey.shade200,
                      child: Icon(
                        Icons.music_note,
                        color: isDarkMode ? Colors.white : Colors.black,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                // Wrap text in Flexible
                child: Text(
                  playlist['playlistName'],
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Danh sách bài hát',
                style: TextStyle(
                  color:
                      isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselSlider(bool isDarkMode) {
    return Column(
      children: [
        SizedBox(
          child: Stack(
            children: [
              CarouselSlider.builder(
                itemCount: carouselItems.length,
                itemBuilder: (context, index, realIndex) {
                  final item = carouselItems[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            item['image'],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                              );
                            },
                          ),
                          // Lớp phủ gradient
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          // Nội dung text
                          Positioned(
                            left: 16,
                            right: 16,
                            bottom: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 10,
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['subtitle'],
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 16,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 10,
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.92,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  pauseAutoPlayOnTouch: true,
                  onPageChanged: (index, reason) {
                    setState(() => _currentCarouselIndex = index);
                  },
                ),
              ),
              // Indicator custom
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: carouselItems.asMap().entries.map((entry) {
                    return AnimatedContainer(
                      width: _currentCarouselIndex == entry.key ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white.withOpacity(
                            _currentCarouselIndex == entry.key ? 0.9 : 0.4),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12), // Giảm khoảng cách
      ],
    );
  }

  Widget _buildPlaylistGrid(bool isDarkMode) {
    if (playlists.isEmpty) {
      return Center(
        child: Text(
          'Không tìm thấy danh sách phát nào',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        return _buildPlaylistCard(playlists[index], isDarkMode);
      },
    );
  }

  Widget _buildBenefitCard(String imageUrl, String title, String subtitle) {
    final Map<String, String> detailedContents = {
      'Giảm căng thẳng':
          'Âm nhạc có khả năng làm dịu hệ thần kinh, giảm nhịp tim và huyết áp. '
              'Các bản nhạc chậm, đặc biệt là nhạc cổ điển hoặc nhạc thiền, có thể '
              'kích hoạt phản ứng thư giãn của cơ thể, giúp giảm các triệu chứng căng thẳng và lo âu.',
      'Tăng tập trung':
          'Nhạc không lời với tiết tấu ổn định tạo môi trường âm thanh lý tưởng cho công việc. '
              'Nó giúp che lấp các tiếng ồn gây xao nhãng đồng thời kích thích não bộ ở mức độ phù hợp '
              'để duy trì sự tập trung trong thời gian dài.',
      'Cải thiện giấc ngủ':
          'Nhạc êm dịu giúp làm chậm sóng não từ trạng thái beta (tỉnh táo) sang alpha (thư giãn) '
              'và cuối cùng là theta (ngủ nhẹ) và delta (ngủ sâu). Đặc biệt hiệu quả khi nghe trong '
              'khoảng 30-45 phút trước khi đi ngủ.',
      'Tăng hiệu suất tập luyện':
          'Nhạc sôi động với nhịp điệu phù hợp có thể tăng sức bền, giảm cảm giác mệt mỏi '
              'và tăng hiệu suất tập luyện lên đến 20%. Nó giúp đồng bộ hóa chuyển động cơ thể '
              'và tạo nguồn động lực tinh thần.',
      'Cải thiện tâm trạng':
          'Âm nhạc kích thích trung tâm khoái cảm của não bộ, giải phóng dopamine - chất dẫn truyền '
              'thần kinh tạo cảm giác vui vẻ. Nghe nhạc yêu thích trong 15 phút đã có thể cải thiện '
              'đáng kể tâm trạng.',
    };
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BenefitDetailScreen(
              imageUrl: imageUrl,
              title: title,
              description: subtitle,
              detailedContent: detailedContents[title] ?? '',
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
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
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
