import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Song {
  final int musicId;
  final int playlistId;
  final String musicName;
  final String musicUrl;
  final String imageUrl;
  final String singer;
  final String status;

  Song({
    required this.musicId,
    required this.playlistId,
    required this.musicName,
    required this.musicUrl,
    required this.imageUrl,
    required this.singer,
    required this.status,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      musicId: json['musicId'] ?? 0,
      playlistId: json['playlistId'] ?? 0,
      musicName: json['musicName'] ?? 'Unknown',
      musicUrl: json['musicUrl'] ?? '',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
      singer: json['singer'] ?? 'Unknown Artist',
      status: json['status'] ?? 'Inactive',
    );
  }
}

class PlaylistNotifier extends StateNotifier<AsyncValue<List<Song>>> {
  final int playlistId;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _currentSongIndex;
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;

  PlaylistNotifier(this.playlistId) : super(const AsyncValue.loading()) {
    _fetchSongs();
    _setupAudioListeners();
  }

  Future<void> _fetchSongs() async {
    try {
      state = const AsyncValue.loading();
      final response = await http.get(
        Uri.parse(
            'https://api.diavan-valuation.asia/content-management/all-music/$playlistId'),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          final songs = (data['data'] as List)
              .map((item) => Song.fromJson(item))
              .where((song) => song.status == 'Active')
              .toList();
          state = AsyncValue.data(songs);
        } else {
          throw Exception(data['message'] ?? 'Failed to load songs');
        }
      } else {
        throw Exception('Failed to load songs (${response.statusCode})');
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void _setupAudioListeners() {
    _audioPlayer.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      state = AsyncValue.data(state.value!);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _currentDuration = position;
      state = AsyncValue.data(state.value!);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      playNextSong();
    });
  }

  Future<void> refresh() async {
    await _fetchSongs();
  }

  Future<void> play() async {
    if (_currentSongIndex == null || state.value == null) return;

    final song = state.value![_currentSongIndex!];
    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(song.musicUrl));
    _isPlaying = true;
    state = AsyncValue.data(state.value!);
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    state = AsyncValue.data(state.value!);
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    state = AsyncValue.data(state.value!);
  }

  Future<void> pauseOrResume() async {
    _isPlaying ? await pause() : await resume();
    state = AsyncValue.data(state.value!);
    state = AsyncValue.data(state.value!);
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
    state = AsyncValue.data(state.value!);
  }

  Stream<Duration> getPositionStream() {
    return _audioPlayer.onPositionChanged;
  }

  void playNextSong() {
    if (_currentSongIndex == null || state.value == null) return;

    setCurrentSongIndex(_currentSongIndex! < state.value!.length - 1
        ? _currentSongIndex! + 1
        : 0);
  }

  void playPreviousSong() async {
    if (_currentSongIndex == null || state.value == null) return;

    if (_currentDuration.inSeconds > 2) {
      await seek(Duration.zero);
    } else {
      setCurrentSongIndex(_currentSongIndex! > 0
          ? _currentSongIndex! - 1
          : state.value!.length - 1);
    }
  }

  void setCurrentSongIndex(int newIndex) {
    if (state.value == null || newIndex < 0 || newIndex >= state.value!.length)
      return;

    _currentSongIndex = newIndex;
    play();
  }

  Future<void> resetPlayer() async {
    try {
      await _audioPlayer.stop();
      _currentSongIndex = null;
      _isPlaying = false;
      _currentDuration = Duration.zero;
      state = AsyncValue.data(state.value ?? []);
    } catch (e) {
      print(e);
    }
  }

  // Getters
  List<Song>? get songs => state.value;
  int? get currentSongIndex => _currentSongIndex;
  Song? get currentSong => _currentSongIndex != null && state.value != null
      ? state.value![_currentSongIndex!]
      : null;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
}

// Provider family để nhận playlistId
final playlistProvider =
    StateNotifierProvider.family<PlaylistNotifier, AsyncValue<List<Song>>, int>(
  (ref, playlistId) => PlaylistNotifier(playlistId),
);
