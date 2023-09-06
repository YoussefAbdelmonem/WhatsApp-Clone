import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/colors.dart';
import 'package:whats_app_clone/common/enums/message_enum.dart';
import 'package:whats_app_clone/features/auth/controller/auth_controller.dart';
import 'package:whats_app_clone/features/chat/controller/chat_controller.dart';
import 'package:whats_app_clone/utils/responsive_layout.dart';
import 'package:whats_app_clone/utils/utils.dart';

class SendChatWidget extends ConsumerStatefulWidget {
  SendChatWidget({required this.receiverUserId, super.key});

  final String receiverUserId;

  @override
  ConsumerState<SendChatWidget> createState() => _SendChatWidgetState();
}

class _SendChatWidgetState extends ConsumerState<SendChatWidget> {
  TextEditingController controller = TextEditingController();

  String text = '';

  void update(value) {
    text = value;
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (text.isNotEmpty) {
      ref.read(chatControllerProvider).sendMessage(
            context,
            controller.text.trim(),
            widget.receiverUserId,
          );
    }
    controller.text = "";
    setState(() {});
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) async {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, widget.receiverUserId, messageEnum);
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            onChanged: (value) {
              update(value);
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: chatBarMessage,
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.grey,
                    )),
              ),
              suffixIcon: IconButton(
                  onPressed: selectImage,
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                  )),
              hintText: 'Type a message!',
              hintStyle: TextStyle(
                color: Colors.white,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        CircleAvatar(
          backgroundColor: tabColor,
          radius: 30,
          child: IconButton(
            onPressed: () {
              sendMessage();
            },
            icon: text.isNotEmpty ? const Icon(Icons.send) : Icon(Icons.mic),
          ),
        )
      ],
    );
  }
}
