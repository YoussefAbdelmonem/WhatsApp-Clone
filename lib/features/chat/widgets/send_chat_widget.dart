import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart';
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
  bool isShowEmojiContainer = false;
  FocusNode focusNode =FocusNode();
  String text = '';
bool isShowSendButton = false;
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
  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }
  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: chatBarMessage,
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: IconButton(
                        onPressed:toggleEmojiKeyboardContainer,
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        )),
                  ),
                  suffix: IconButton(
                      onPressed: selectImage,
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      )),
                  suffixIcon:  IconButton(
                      onPressed: selectVideo,
                      icon: Icon(
                        Icons.attach_file_rounded,
                        color: Colors.grey,
                      )),
                  hintText: 'Type a message!',
                  hintStyle: const TextStyle(
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
                icon:isShowSendButton ? const Icon(Icons.send) : Icon(Icons.mic),
              ),
            )
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
          height: 310,
          child: EmojiPicker(
            onEmojiSelected: ((category, emoji) {
              setState(() {
                controller.text =
                    controller.text + emoji.emoji;
              });

              if (!isShowSendButton) {
                setState(() {
                  isShowSendButton = true;
                });
              }
            }),
          ),
        )
            : const Nil(),
      ],
    );
  }
}
