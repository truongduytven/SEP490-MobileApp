import 'package:flutter/material.dart';
import 'package:sep490/common/enums/message_enum.dart';
import 'package:sep490/presentation/pages/chat/widgets/display_text_image_gif.dart';
import 'package:sep490/theme/color.dart';
import 'package:swipe_to/swipe_to.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.avatar,
    required this.message,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
  }) : super(key: key);

  final String avatar;
  final String message;
  final String date;
  final MessageEnum type;
  final GestureDragUpdateCallback onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;

    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(width: 10),
            // Avatar on the left
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(avatar),
            ),
            const SizedBox(width: 8), // Space between avatar and message

            // Message Card
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 100,

                maxWidth: MediaQuery.of(context).size.width -
                    120, // Adjust for larger avatar
              ),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.circular(15),
                  ),
                ),
                color: AppColors.bgColor,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Stack(
                  children: [
                    Padding(
                      padding: type == MessageEnum.Text
                          ? const EdgeInsets.only(
                              left: 10,
                              right: 30,
                              top: 5,
                              bottom: 20,
                            )
                          : const EdgeInsets.only(
                              left: 5,
                              top: 5,
                              right: 5,
                              bottom: 25,
                            ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isReplying) ...[
                            Text(
                              username,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: DisplayTextImageGif(
                                isMe: false,
                                message: repliedText,
                                type: repliedMessageType,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          DisplayTextImageGif(
                            isMe: false,
                            message: message,
                            type: type,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      left: 10,
                      child: Text(
                        date,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
