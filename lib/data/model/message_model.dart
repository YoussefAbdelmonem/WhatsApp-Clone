import 'package:whats_app_clone/common/enums/message_enum.dart';


class MessageModel {
  final String senderID;
  final String receiverID;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageID;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  MessageModel({
    required this.senderID,
    required this.receiverID,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageID,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
  });

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderID,
      'recieverid': receiverID,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageID': messageID,
      'isSeen': isSeen,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType.type,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderID: json['senderID'],
      receiverID: json['receiverID'],
      text: json['text'],
      type: (json['type'].toString()).toEnum(),
      timeSent: DateTime.fromMicrosecondsSinceEpoch(json['timeSent']),
      messageID: json['messageID'],
      isSeen: json['isSeen'],

      repliedMessage: json['repliedMessage'] ?? '',
      repliedTo: json['repliedTo'] ?? '',
      repliedMessageType: (json['repliedMessageType'] as String).toEnum(),
    );
  }
}
