import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sep490/features/music/screens/playlist_page.dart';
import 'dart:convert';

import 'package:sep490/features/music/widgets/neu_box.dart';

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
        child: CircularProgressIndicator(
          color: isDarkMode ? Colors.pinkAccent : Colors.pink,
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
              const SizedBox(height: 4),
              Text(
                '${playlist['numberOfContent']} bài hát',
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
}
