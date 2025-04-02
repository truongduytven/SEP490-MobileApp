import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/music/provider/playlist_provider.dart';
import 'package:sep490/features/music/screens/home_music_screen.dart';
import 'package:sep490/features/music/screens/song_page.dart';
import 'package:sep490/features/music/widgets/neu_box.dart';
import 'package:sep490/features/music/widgets/now_playing_box.dart';
import 'package:sep490/theme/color.dart';

class PlaylistPage extends ConsumerStatefulWidget {
  final String playlistId;
  final String playlistName;
  final String imageUrl;

  const PlaylistPage({
    super.key,
    required this.playlistId,
    required this.playlistName,
    required this.imageUrl,
  });

  @override
  ConsumerState<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends ConsumerState<PlaylistPage> {
  @override
  void initState() {
    super.initState();
    // Load songs khi khởi tạo
    Future.microtask(() => ref
        .read(playlistProvider(int.parse(widget.playlistId)).notifier)
        .refresh());
  }

  void goToSong(int songIndex) {
    ref
        .read(playlistProvider(int.parse(widget.playlistId)).notifier)
        .setCurrentSongIndex(songIndex);
  }

  @override
  Widget build(BuildContext context) {
    final playlistAsync =
        ref.watch(playlistProvider(int.parse(widget.playlistId)));
    final notifier =
        ref.read(playlistProvider(int.parse(widget.playlistId)).notifier);
    final isDarkMode = ref.watch(themeProvider.notifier).isDarkMode;

    return WillPopScope(
      onWillPop: () async {
        final notifier =
            ref.read(playlistProvider(int.parse(widget.playlistId)).notifier);
        // Dừng phát nhạc và reset trạng thái
        notifier.resetPlayer();
        return true;
      },
      child: Scaffold(
        backgroundColor:
            isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor:
              isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
          title: Text(
            widget.playlistName.toUpperCase(),
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            color: isDarkMode ? Colors.white : Colors.black,
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              final notifier = ref.read(
                  playlistProvider(int.parse(widget.playlistId)).notifier);

              // Dừng phát nhạc và reset trạng thái
              notifier.resetPlayer();

              Navigator.pop(context);
            },
          ),
        ),
        body: playlistAsync.when(
          loading: () => Scaffold(
            backgroundColor:
                isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://cdn.pixabay.com/animation/2023/08/22/07/30/07-30-19-708_512.gif',
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const CircularProgressIndicator();
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
            ),
          ),
          error: (error, _) => Center(child: Text('Error: $error')),
          data: (songs) {
            return Column(
              children: [
                // Header với ảnh playlist
                _buildPlaylistHeader(songs.length),

                Expanded(
                  child: ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return ListTile(
                        title: Text(
                          song.musicName,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(song.singer),
                        leading: SizedBox(
                          height: 60,
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              song.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.music_note,
                                size: 30,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        onTap: () => goToSong(index),
                      );
                    },
                  ),
                ),

                // Now playing bar
                if (notifier.currentSong != null) _buildNowPlayingBar(notifier),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaylistHeader(int songCount) {
    final isDarkMode = ref.watch(themeProvider.notifier).isDarkMode;

    return Container(
      padding: const EdgeInsets.all(16),
      height: 180,
      width: double.infinity,
      child: Row(
        children: [
          // Ảnh playlist
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.music_note, size: 50),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Thông tin playlist
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.playlistName,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '$songCount bài hát',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                NeuBox(
                  child: GestureDetector(
                    onTap: () {
                      // Phát ngẫu nhiên playlist
                      final songs = ref
                          .read(playlistProvider(int.parse(widget.playlistId))
                              .notifier)
                          .songs;
                      if (songs != null && songs.isNotEmpty) {
                        final randomIndex = 0; // Hoặc logic random phù hợp
                        ref
                            .read(playlistProvider(int.parse(widget.playlistId))
                                .notifier)
                            .setCurrentSongIndex(randomIndex);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        Text(
                          'PHÁT TẤT CẢ',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNowPlayingBar(PlaylistNotifier notifier) {
    final currentSong = notifier.currentSong!;
    final currentIndex = notifier.currentSongIndex!;
    final isDarkMode = ref.watch(themeProvider.notifier).isDarkMode;

    return NowPlayingBox(
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Ảnh album
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SongPage(
                    playlistId: int.parse(widget.playlistId),
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  currentSong.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.music_note,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Thông tin bài hát
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SongPage(
                      playlistId: int.parse(widget.playlistId),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentSong.musicName,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      currentSong.singer,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Các nút điều khiển
            IconButton(
              icon: Icon(
                Icons.skip_previous,
                color: currentIndex > 0 ? AppColors.primaryColor : Colors.grey,
                size: 30,
              ),
              onPressed:
                  currentIndex > 0 ? () => notifier.playPreviousSong() : null,
            ),
            IconButton(
              icon: Icon(
                notifier.isPlaying ? Icons.pause_circle : Icons.play_circle,
                color: AppColors.primaryColor,
                size: 35,
              ),
              onPressed: () => notifier.pauseOrResume(),
            ),
            IconButton(
              icon: Icon(
                Icons.skip_next,
                color: currentIndex < (notifier.songs?.length ?? 0) - 1
                    ? AppColors.primaryColor
                    : Colors.grey,
                size: 30,
              ),
              onPressed: currentIndex < (notifier.songs?.length ?? 0) - 1
                  ? () => notifier.playNextSong()
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
