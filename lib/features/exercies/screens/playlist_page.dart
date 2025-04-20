import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/exercies/provider/playlist_provider.dart';
import 'package:sep490/theme/color.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class PlaylistPage extends ConsumerStatefulWidget {
  final int playlistId;
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
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  int? _currentVideoIndex;
  bool _isInitializing = false;
  List<double> playbackRates = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(playlistProvider(widget.playlistId).notifier).fetchVideos();
    });
  }

  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _videoListener() {
    if (mounted) setState(() {});
  }

  Future<void> _initializeVideo(String url, String? posterUrl) async {
    if (_isInitializing) return;

    setState(() {
      _isInitializing = true;
    });

    final oldVideoController = _videoController;
    final oldChewieController = _chewieController;

    try {
      _videoController = VideoPlayerController.network(url)
        ..addListener(_videoListener)
        ..setLooping(false);

      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: true,
        playbackSpeeds: playbackRates,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.pink,
          handleColor: Colors.pink,
          bufferedColor: Colors.pink[100]!,
          backgroundColor: Colors.grey,
        ),
        placeholder: posterUrl != null && posterUrl.isNotEmpty
            ? Image.network(posterUrl, fit: BoxFit.cover)
            : Container(color: Colors.black),
        overlay: Container(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.playlistName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 4,
                  offset: Offset(1, 1),
                )
              ],
            ),
          ),
        ),
      );

      if (mounted) {
        setState(() {
          _isInitializing = false;
        });

        _videoController?.addListener(() {
          if (_videoController!.value.position ==
              _videoController!.value.duration) {
            _onNextVideo();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }

    oldVideoController?.removeListener(_videoListener);
    oldVideoController?.dispose();
    oldChewieController?.dispose();
  }

  void _onNextVideo() {
    final playlist = ref.read(playlistProvider(widget.playlistId)).value;
    if (playlist == null) return;

    final currentIndex = ref
        .read(playlistProvider(widget.playlistId).notifier)
        .currentVideoIndex;
    final nextIndex = currentIndex + 1;

    if (nextIndex < playlist.length) {
      ref.read(playlistProvider(widget.playlistId).notifier).playNextVideo();
      _initializeVideo(
        playlist[nextIndex].lessonUrl,
        playlist[nextIndex].imageUrl,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final playlistAsync = ref.watch(playlistProvider(widget.playlistId));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName, style: const TextStyle(color: AppColors.secondaryColor, fontSize: 25, fontWeight: FontWeight.w600)),
        // backgroundColor: Colors.pink,
        // foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: playlistAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Colors.pink,
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 50, color: Colors.pink),
              const SizedBox(height: 16),
              Text(
                'Error: $error',
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        data: (videos) {
          if (videos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.video_library, size: 50, color: Colors.pink),
                  SizedBox(height: 16),
                  Text(
                    'Không có video nào',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final currentIndex = ref
              .watch(playlistProvider(widget.playlistId).notifier)
              .currentVideoIndex;
          final currentVideo = videos[currentIndex];

          if (_currentVideoIndex != currentIndex ||
              (_videoController != null &&
                  _videoController!.dataSource != currentVideo.lessonUrl)) {
            _currentVideoIndex = currentIndex;
            _initializeVideo(currentVideo.lessonUrl, currentVideo.imageUrl);
          }

          return Column(
            children: [
              // Video Player
              AspectRatio(
                aspectRatio: 16 / 9,
                child: _isInitializing
                    ? Container(
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.pink,
                          ),
                        ),
                      )
                    : _chewieController != null &&
                            _chewieController!
                                .videoPlayerController.value.isInitialized
                        ? Chewie(controller: _chewieController!)
                        : Container(
                            color: Colors.black,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.play_circle_fill,
                                    color: Colors.pink[300],
                                    size: 50,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Chạm để xem',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
              ),

              // Video Info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  currentVideo.lessonName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[800],
                      ),
                ),
              ),

              // Video List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      color: index == currentIndex
                          ? Colors.pink[50]
                          : Colors.grey[50],
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          if (index != _currentVideoIndex) {
                            ref
                                .read(playlistProvider(widget.playlistId)
                                    .notifier)
                                .setCurrentVideo(index);
                            await _initializeVideo(
                                video.lessonUrl, video.imageUrl);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: video.imageUrl != null &&
                                        video.imageUrl!.isNotEmpty
                                    ? Image.network(
                                        video.imageUrl!,
                                        width: 80,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          width: 80,
                                          height: 60,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.videocam,
                                              color: Colors.grey),
                                        ),
                                      )
                                    : Container(
                                        width: 80,
                                        height: 60,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.videocam,
                                            color: Colors.grey),
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      video.lessonName,
                                      style: TextStyle(
                                        fontWeight: index == currentIndex
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Bài ${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.play_circle_outline,
                                color: Colors.pink[300],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
