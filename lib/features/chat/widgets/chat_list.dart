import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whats_app_clone/data/model/message_model.dart';
import 'package:whats_app_clone/features/chat/controller/chat_controller.dart';
import 'package:whats_app_clone/features/chat/widgets/my_message_card.dart';
import 'package:whats_app_clone/features/chat/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({Key? key, required this.receiverUserId}) : super(key: key);
  final String receiverUserId;

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final messageController = ScrollController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
        stream: ref
            .read(chatControllerProvider)
            .getChatMessages(receiverUserId: widget.receiverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController.jumpTo(
              messageController.position.maxScrollExtent,

            );
          });
          return ListView.builder(
            itemCount: snapshot.data?.length,
            controller: messageController,
            itemBuilder: (context, index) {
              final message = snapshot.data![index];
              if (message.senderID == FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: message.text.toString(),
                  type: message.type,
                  date: DateFormat('hh:mm a').format(message.timeSent),
                );
              }
              return SenderMessageCard(
                message: message.text,
                messageEnum: message.type,
                date: DateFormat('hh:mm a').format(message.timeSent),
              );
            },
          );
        });
  }
}
