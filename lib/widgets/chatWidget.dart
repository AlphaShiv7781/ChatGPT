import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_gpt/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:chat_gpt/services/assets_manager.dart';
import 'text_widget.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({Key? key, required this.msg, required this.chatIndex})
      : super(key: key);

  final String msg;
  final int chatIndex;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? scaffoldBackground : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0
                      ? AssestsManager.userImage
                      : AssestsManager.botImage,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: chatIndex == 0
                      ? TextWidget(
                          label: msg,
                        )
                      : DefaultTextStyle(
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                          child: AnimatedTextKit(
                               isRepeatingAnimation: false,
                               repeatForever: false,
                              // displayFullTextOnTap: true,
                              // totalRepeatCount: 1,
                              animatedTexts: [
                                TypewriterAnimatedText(msg.trim())
                              ]),
                        ),
                ),
                chatIndex == 0
                    ? const SizedBox.shrink()
                    : const Row(
                        children: [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.thumb_down_off_alt_outlined,
                            color: Colors.white,
                          )
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
