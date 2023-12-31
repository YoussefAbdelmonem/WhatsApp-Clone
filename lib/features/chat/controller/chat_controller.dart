import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/common/enums/message_enum.dart';
import 'package:whats_app_clone/data/model/chat_contacts_model.dart';
import 'package:whats_app_clone/data/model/message_model.dart';
import 'package:whats_app_clone/features/auth/controller/auth_controller.dart';
import 'package:whats_app_clone/features/chat/repo/chat_repo.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;

  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<MessageModel>> getChatMessages({required String receiverUserId}) {
    return chatRepository.getChatMessages(receiverUserId: receiverUserId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
  ) {
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage(context, text, receiverUserId, value!));
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverUserId,
    MessageEnum messageEnum,
  ) {
    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendFileMessage(
              context: context,
              file: file,
              receiverUserId: receiverUserId,
              senderUser: value!,
              messageEnum: messageEnum,
              ref: ref,
            ));
  }

  void sendGIFMessage(
      BuildContext context,
      String gifUrl,
      String receiverUserId,
      ) {
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newGIFUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendGIFMessage(context, newGIFUrl, receiverUserId, value!));
  }
}
