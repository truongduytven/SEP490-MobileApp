import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/features/exercies/provider/playlist_provider.dart';
import 'package:video_player/video_player.dart';

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
  int? _currentVideoIndex;
  bool _isInitializing = false;
  bool _showControls = false;

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
    super.dispose();
  }

  void _videoListener() {
    if (mounted) setState(() {});
  }

  Future<void> _initializeVideo(String url, String? posterUrl) async {
    if (_isInitializing) return;

    setState(() {
      _isInitializing = true;
      _showControls = false;
    });

    final oldController = _videoController;

    try {
      final newController = VideoPlayerController.network(url)
        ..addListener(_videoListener)
        ..setLooping(false);

      await newController.initialize();

      if (mounted) {
        setState(() {
          _videoController = newController;
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

    oldController?.removeListener(_videoListener);
    oldController?.dispose();
  }

  
  void _onNextVideo() {
    final playlist = ref.read(playlistProvider(widget.playlistId)).value;
    if (playlist == null) return;

    final currentIndex = ref
        .read(playlistProvider(widget.playlistId).notifier)
        .currentVideoIndex;

    // Chuyển đến video tiếp theo theo thứ tự
    final nextIndex = currentIndex + 1;

    if (nextIndex < playlist.length) {
      ref
          .read(playlistProvider(widget.playlistId).notifier)
          .setCurrentVideo(nextIndex);
      _initializeVideo(
        playlist[nextIndex].lessonUrl,
        playlist[nextIndex].imageUrl,
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    final playlistAsync = ref.watch(playlistProvider(widget.playlistId));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: playlistAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (videos) {
          if (videos.isEmpty) {
            return const Center(
              child: Text('Không có video nào'),
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
              // Video Player with Gesture Detector for Controls
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showControls = !_showControls;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
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
                          : _videoController != null &&
                                  _videoController!.value.isInitialized
                              ? VideoPlayer(_videoController!)
                              : Container(
                                  color: Colors.black,
                                  child: Center(
                                    child: Icon(
                                      Icons.play_circle_fill,
                                      color: Colors.pink[300],
                                      size: 50,
                                    ),
                                  ),
                                ),
                    ),

                    // Video Controls Overlay
                    if (_showControls && _videoController != null)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Top Controls
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back),
                                    color: Colors.white,
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            ),

                            // Center Play/Pause Button
                            IconButton(
                              icon: Icon(
                                _videoController!.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 50,
                              ),
                              color: Colors.white,
                              onPressed: () {
                                setState(() {
                                  if (_videoController!.value.isPlaying) {
                                    _videoController?.pause();
                                  } else {
                                    _videoController?.play();
                                  }
                                });
                              },
                            ),

                            // Bottom Controls
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  VideoProgressIndicator(
                                    _videoController!,
                                    allowScrubbing: true,
                                    colors: const VideoProgressColors(
                                      playedColor: Colors.pink,
                                      bufferedColor: Colors.pinkAccent,
                                      backgroundColor: Colors.white54,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDuration(
                                            _videoController!.value.position),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        _formatDuration(
                                            _videoController!.value.duration),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Video Info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  currentVideo.lessonName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                ),
              ),

              // Video List
              Expanded(
                child: ListView.builder(
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      color: index == currentIndex
                          ? Colors.pink[50]
                          : Colors.grey[100],
                      child: ListTile(
                        leading: video.imageUrl != null &&
                                video.imageUrl!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  video.imageUrl!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.videocam),
                                  ),
                                ),
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.videocam),
                              ),
                        title: Text(
                          video.lessonName,
                          style: TextStyle(
                            fontWeight: index == currentIndex
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        trailing: const Icon(Icons.play_circle_outline),
                        onTap: () async {
                          if (index != _currentVideoIndex) {
                            ref
                                .read(playlistProvider(widget.playlistId)
                                    .notifier)
                                .setCurrentVideo(index);
                            await _initializeVideo(
                                video.lessonUrl, video.imageUrl);
                            setState(() {
                              _showControls = true;
                            });
                          }
                        },
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
