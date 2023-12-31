import 'package:flutter/material.dart';
import 'package:whats_app_clone/colors.dart';
import 'package:whats_app_clone/common/enums/message_enum.dart';
import 'package:whats_app_clone/features/chat/widgets/display_text_image_widget.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;


  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: type == MessageEnum.text
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
                    children: [
                      // if (isReplying) ...[
                      //   Text(
                      //     username,
                      //     style: const TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      //   const SizedBox(height: 3),
                      //   Container(
                      //     padding: const EdgeInsets.all(10),
                      //     decoration: BoxDecoration(
                      //       color: backgroundColor.withOpacity(0.5),
                      //       borderRadius: const BorderRadius.all(
                      //         Radius.circular(
                      //           5,
                      //         ),
                      //       ),
                      //     ),
                      //     child: DisplayTextImageGIF(
                      //       message: repliedText,
                      //       type: repliedMessageType,
                      //     ),
                      //   ),
                      //   const SizedBox(height: 8),
                      // ],
                      DisplayTextImageGIF(
                        message: message,
                        type: type,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                         Icons.done_all,
                        size: 20,

                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
