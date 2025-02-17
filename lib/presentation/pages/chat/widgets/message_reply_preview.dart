import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sep490/common/provider/message_reply_provider.dart';
import 'package:sep490/presentation/pages/chat/widgets/display_text_image_gif.dart';
import 'package:sep490/theme/color.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});
  void cancelReply(WidgetRef ref) {
    ref.read(messsageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messsageReplyProvider);
    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReply!.isMe ? 'Trả lời' : 'Trả lời',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor),
                ),
              ),
              GestureDetector(
                child: const Icon(
                  Icons.close,
                  size: 16,
                ),
                onTap: () => cancelReply(ref),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          DisplayTextImageGif(
            isMe: false,
            message: messageReply.messsage,
            type: messageReply.messageEnum,
          )
        ],
      ),
    );
  }
}
