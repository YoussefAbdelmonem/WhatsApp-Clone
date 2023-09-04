import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  void sendMessage(
    BuildContext context,
    String text,
    String receiverUserId,
  ) {
    ref.read(userDataAuthProvider).whenData((value) => chatRepository
        .sendTextMessage(context, text, receiverUserId, value!));
  }
}
