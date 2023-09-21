import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/common/enums/message_enum.dart';

class MessageReplyModel {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReplyModel(this.message, this.isMe, this.messageEnum);
}

final messageReplyProvider = StateProvider<MessageReplyModel?>((ref) =>null);