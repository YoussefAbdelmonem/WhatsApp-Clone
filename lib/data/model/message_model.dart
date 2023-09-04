import 'package:whats_app_clone/common/enums/message_enum.dart';

class MessageModel {
  final String senderID;
  final String receiverID;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageID;
  final bool isSeen;

  MessageModel(
  {
    required this.senderID,
    required this.receiverID,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageID,
    required this.isSeen,
}
  );

factory MessageModel.fromJson(Map<String, dynamic> json){
  return MessageModel(
    senderID: json['senderID'],
    receiverID: json['receiverID'],
    text: json['text'],
    type: (json['type'].toString()).toEnum(),
    timeSent: DateTime.fromMicrosecondsSinceEpoch(json['timeSent']),
    messageID: json['messageID'],
    isSeen: json['isSeen'],
  );}

  Map<String, dynamic> toJson() => {
    'senderID': senderID,
    'receiverID': receiverID,
    'text': text,
    'type': type.type,
    'timeSent': timeSent.millisecondsSinceEpoch,
    'messageID': messageID,
    'isSeen': isSeen,
  };

}
