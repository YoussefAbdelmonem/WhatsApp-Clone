import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/enums/message_enum.dart';

class DisplayImageWidget extends StatelessWidget {
  final String message;
  final MessageEnum messageEnum;
  const DisplayImageWidget({super.key, required this.message, required this.messageEnum});

  @override
  Widget build(BuildContext context) {
    return messageEnum ==MessageEnum.text?Text(
        message,
        style: const TextStyle(
        fontSize: 16,
    )):CachedNetworkImage(imageUrl: message);
  }
}
