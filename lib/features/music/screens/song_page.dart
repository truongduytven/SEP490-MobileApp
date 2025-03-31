import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sep490/features/music/provider/playlist_provider.dart';
import 'package:sep490/features/music/screens/home_music_screen.dart';
import 'package:sep490/features/music/widgets/neu_box.dart';

class SongPage extends ConsumerWidget {
  final int playlistId;
  const SongPage({super.key, required this.playlistId});

  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, "0");
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";
    return formattedTime;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistAsync = ref.watch(playlistProvider(playlistId));
    final notifier = ref.read(playlistProvider(playlistId).notifier);
    final isDarkMode = ref.watch(themeProvider.notifier).isDarkMode;

    return playlistAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
      data: (playlist) {
        if (notifier.currentSongIndex == null || playlist.isEmpty) {
          return Scaffold(
            body: Center(child: Text('Không có bài hát nào')),
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          );
        }

        final currentSong = playlist[notifier.currentSongIndex!];

        return Scaffold(
          backgroundColor:
              isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 25, right: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          // notifier.resetPlayer();
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back,
                            color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      Text(
                        "Senior Music",
                        style: TextStyle(
                          fontSize: 18,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.music_note_outlined,
                            color: isDarkMode ? Colors.white : Colors.black),
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                  NeuBox(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 250,
                              maxHeight: 300,
                            ),
                            child: Image.network(
                              currentSong.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Icon(
                                  Icons.music_note,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        currentSong.musicName,
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        currentSong.singer,
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white.withOpacity(0.7)
                                              : Colors.black.withOpacity(0.7),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child:
                                      Icon(Icons.favorite, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: [
                        StreamBuilder<Duration>(
                          stream: notifier.getPositionStream(),
                          builder: (context, snapshot) {
                            final currentPosition =
                                snapshot.data ?? Duration.zero;
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formatTime(currentPosition),
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      Text(
                                        formatTime(notifier.totalDuration),
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                      thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 0)),
                                  child: Slider(
                                    min: 0,
                                    max: notifier.totalDuration.inSeconds
                                        .toDouble(),
                                    value: currentPosition.inSeconds.toDouble(),
                                    activeColor: Colors.pink,
                                    onChanged: (double value) {},
                                    onChangeEnd: (double value) {
                                      notifier.seek(
                                          Duration(seconds: value.toInt()));
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: notifier.playPreviousSong,
                                child: NeuBox(
                                  child: Icon(
                                    Icons.skip_previous,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: notifier.pauseOrResume,
                                child: NeuBox(
                                  child: Icon(
                                    notifier.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: GestureDetector(
                                onTap: notifier.playNextSong,
                                child: NeuBox(
                                  child: Icon(
                                    Icons.skip_next,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
