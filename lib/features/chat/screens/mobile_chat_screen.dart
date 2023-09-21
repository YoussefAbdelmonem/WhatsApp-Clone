import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/colors.dart';
import 'package:whats_app_clone/data/model/user_model.dart';
import 'package:whats_app_clone/features/auth/controller/auth_controller.dart';
import 'package:whats_app_clone/features/chat/widgets/chat_list.dart';

import '../widgets/send_chat_widget.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/mobile-chat';
  final String name;
  final String uid;

  const MobileChatScreen({Key? key, required this.name, required this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userDataById(uid),
            builder: (context, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 12),
                  ),
                  // 10.ph,
                  Text(
                    snapShot.data!.isOnline ? 'online' : 'offline',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              );
            }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              recieverUserId: uid,
              isGroupChat: false,
            ),
          ),
          SendChatWidget(
            receiverUserId: uid,
          )
        ],
      ),
    );
  }
}
