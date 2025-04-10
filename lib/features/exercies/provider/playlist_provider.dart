// playlist_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Video {
  final int lessonId;
  final String lessonName;
  final String lessonUrl;
  final String? imageUrl;

  Video({
    required this.lessonId,
    required this.lessonName,
    required this.lessonUrl,
    this.imageUrl,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      lessonId: json['lessonId'],
      lessonName: json['lessonName'],
      lessonUrl: json['lessonUrl'],
      imageUrl: json['imageUrl'],
    );
  }
}

class PlaylistNotifier extends StateNotifier<AsyncValue<List<Video>>> {
  final int playlistId;
  
  PlaylistNotifier(this.playlistId) : super(const AsyncValue.loading()) {
    fetchVideos();
  }

  int _currentVideoIndex = 0;
  int get currentVideoIndex => _currentVideoIndex;
  
  Future<void> fetchVideos() async {
    state = const AsyncValue.loading();
    try {
      final response = await http.get(
        Uri.parse('https://api.diavan-valuation.asia/content-management/all-lesson/$playlistId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          final videos = (data['data'] as List)
              .where((video) => video['status'] == 'Active')
              .map((video) => Video.fromJson(video))
              .toList();
          
          state = AsyncValue.data(videos);
        } else {
          state = AsyncValue.error(data['message'] ?? 'Failed to load videos', StackTrace.current);
        }
      } else {
        state = AsyncValue.error('Failed to load videos: ${response.statusCode}', StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  void setCurrentVideo(int index) {
    if (index >= 0 && index < (state.value?.length ?? 0)) {
      _currentVideoIndex = index;
    }
  }

  void playNextVideo() {
    if (_currentVideoIndex < (state.value?.length ?? 0) - 1) {
      _currentVideoIndex++;
    }
  }

  void playPreviousVideo() {
    if (_currentVideoIndex > 0) {
      _currentVideoIndex--;
    }
  }
}

final playlistProvider = StateNotifierProvider.family<PlaylistNotifier, AsyncValue<List<Video>>, int>(
  (ref, playlistId) => PlaylistNotifier(playlistId),
);