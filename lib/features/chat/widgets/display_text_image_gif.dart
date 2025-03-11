import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sep490/common/enums/message_enum.dart';
import 'package:sep490/features/chat/widgets/video_player_item.dart';
import 'package:sep490/theme/color.dart';

class DisplayTextImageGif extends StatefulWidget {
  final String message;
  final MessageEnum type;
  final bool? isMe;

  const DisplayTextImageGif({
    Key? key,
    required this.message,
    required this.type,
    this.isMe,
  }) : super(key: key);

  @override
  State<DisplayTextImageGif> createState() => _DisplayTextImageGifState();
}

class _DisplayTextImageGifState extends State<DisplayTextImageGif> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String getLowResVideoUrl(String originalUrl) {
    return originalUrl.replaceFirst(
        '/upload/', '/upload/q_auto:low,w_1280,h_720/');
  }

  @override
  void initState() {
    super.initState();

    // Listen for changes in player state
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.message));
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes);
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final bool isUserMe = widget.isMe ?? true;

    return widget.type == MessageEnum.Text
        ? Text(
            widget.message,
            style: TextStyle(
              color: isUserMe ? AppColors.bgColor : AppColors.secondaryColor,
              fontSize: 16,
            ),
          )
        : widget.type == MessageEnum.Audio
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      isUserMe ? AppColors.bgColor : AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: _togglePlayPause,
                      icon: Icon(
                        _isPlaying ? Icons.pause_circle : Icons.play_circle,
                        size: 32,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        min: 0,
                        max: _duration.inSeconds.toDouble(),
                        value: _position.inSeconds.toDouble(),
                        onChanged: (value) {
                          _audioPlayer.seek(Duration(seconds: value.toInt()));
                        },
                        activeColor: AppColors.primaryColor,
                        inactiveColor: Colors.grey,
                      ),
                    ),
                    Text(
                      _formatDuration(_position),
                      style: const TextStyle(color: AppColors.primaryColor),
                    ),
                  ],
                ),
              )
            : widget.type == MessageEnum.Video
                ? VideoPlayerItem(
                    videoUrl: getLowResVideoUrl(widget.message),
                  )
                : widget.type == MessageEnum.CallSuccess ||
                        widget.type == MessageEnum.CallFailure
                    ? _buildCallMessage(
                        isSuccess: widget.type == MessageEnum.CallSuccess,
                        isUserMe: isUserMe,
                        message: widget.message)
                    : CachedNetworkImage(imageUrl: widget.message);
  }
}

Widget _buildCallMessage({
  required bool isSuccess,
  required bool isUserMe,
  required String message,
}) {
  // Extract call type (video or audio) from the message
  final isVideoCall = message.toLowerCase().contains("video");
  final callType = isVideoCall ? "Video" : "Thoại";

  // Extract duration from the message (assuming the format is "Cuộc gọi Video - 0")
  final duration = message.split(" - ").last;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 8),
        Icon(
          isVideoCall
              ? (isSuccess ? Icons.videocam : Icons.videocam_off)
              : (isSuccess ? Icons.call : Icons.phone_callback_rounded),
          color: isSuccess ? Colors.green : AppColors.primaryColor,
          size: 24,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Cuộc gọi $callType",
              style: TextStyle(
                color: isUserMe ? AppColors.bgColor : AppColors.secondaryColor,
                fontSize: 16,
              ),
            ),
            if (isSuccess)
              Text(
                duration,
                style: TextStyle(
                  color:
                      isUserMe ? AppColors.bgColor : AppColors.secondaryColor,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ],
    ),
  );
}
