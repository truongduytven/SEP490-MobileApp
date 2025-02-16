import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sep490/common/enums/message_enum.dart';
import 'package:sep490/presentation/pages/chat/widgets/video_player_item.dart';
import 'package:sep490/theme/color.dart';

class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum type;
  final bool? isMe;
  const DisplayTextImageGif(
      {Key? key, required this.message, required this.type, this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final bool isUserMe = isMe ?? true;
    final AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnum.Text
        ? Text(
            message,
            style: TextStyle(
              color: isUserMe ? AppColors.bgColor : AppColors.secondaryColor,
              fontSize: 20,
            ),
          )
        : type == MessageEnum.Audio
            ? StatefulBuilder(builder: (context, setState) {
                return IconButton(
                    constraints: const BoxConstraints(
                      minWidth: 100,
                    ),
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      } else {
                        await audioPlayer.play(UrlSource(message));
                        setState(() {
                          isPlaying = true;
                        });
                      }
                    },
                    icon: Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle,
                    ));
              })
            : type == MessageEnum.Video
                ? VideoPlayerItem(
                    videoUrl: message,
                  )
                : type == MessageEnum.Gif
                    ? CachedNetworkImage(
                        imageUrl: message,
                      )
                    : CachedNetworkImage(
                        imageUrl: message,
                      );
  }
}
