import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/properties/group.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_app_clone/common/enums/message_enum.dart';
import 'package:whats_app_clone/common/providers/message_reply_provider.dart';
import 'package:whats_app_clone/common/repo/common_firebase_storage.dart';
import 'package:whats_app_clone/data/model/chat_contacts_model.dart';
import 'package:whats_app_clone/data/model/message_model.dart';
import 'package:whats_app_clone/data/model/user_model.dart';
import 'package:whats_app_clone/utils/utils.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    firebaseAuth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore firestore;

  final FirebaseAuth firebaseAuth;

  ChatRepository({required this.firestore, required this.firebaseAuth});

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("chats")
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var element in event.docs) {
        var chatContact = ChatContact.fromMap(element.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromJson(userData.data()!);
        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePicture,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<MessageModel>> getChatMessages({required String receiverUserId}) {
    return firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection("messages")
        .orderBy("timeSent", descending: false)
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var element in event.docs) {
        messages.add(
          MessageModel.fromJson(element.data()),
        );
      }
      return messages;
    });
  }

  void saveDataToUserSubCollection({
    required UserModel receiverUser,
    required UserModel senderUser,
    // required String text,
    required String message,
    required String receiverUserId,
    required DateTime time,
  }) async {
    ///receiver
    var receiverChatContact = ChatContact(
      lastMessage: message,
      name: senderUser.name,
      timeSent: time,
      contactId: senderUser.uid,
      profilePic: senderUser.profilePicture,
    );
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(firebaseAuth.currentUser!.uid)
        .set(receiverChatContact.toMap());

    /// sender

    var senderChatContact = ChatContact(
      lastMessage: message,
      name: receiverUser.name,
      timeSent: time,
      contactId: receiverUser.uid,
      profilePic: receiverUser.profilePicture,
    );
    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(senderChatContact.toMap());
  }

  void saveMessageToMessageSubCollection(
      {required String text,
      required String messageId,
      required String receiverUserId,
      required String senderUserName,
      required receiverUserName,
      required MessageEnum messageType,
      required DateTime sendTime}) async {
    final message = MessageModel(
      senderID: firebaseAuth.currentUser!.uid,
      receiverID: receiverUserId,
      text: text,
      type: messageType,
      timeSent: sendTime,
      messageID: messageId,
      isSeen: false,
      repliedMessage: '',
      repliedMessageType: MessageEnum.text,
      repliedTo: receiverUserId,

    );

    ///sender
    await firestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("chats")
        .doc(receiverUserId)
        .collection("messages")
        .doc(messageId)
        .set(message.toJson());

    ///receiver
    await firestore
        .collection("users")
        .doc(receiverUserId)
        .collection("chats")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("messages")
        .doc(messageId)
        .set(message.toJson());
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
    UserModel senderUser,
  ) async {
    try {
      var timeSent = DateTime.now();
      UserModel? receiverUserData;
      var messageId = Uuid().v1();
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromJson(userDataMap.data()!);

      saveDataToUserSubCollection(
        receiverUser: receiverUserData,
        senderUser: senderUser,
        message: text,
        receiverUserId: receiverUserData.uid,
        time: timeSent,
      );

      saveMessageToMessageSubCollection(
          text: text,
          receiverUserId: receiverUserId,
          senderUserName: senderUser.name,
          receiverUserName: receiverUserData.name,
          messageType: MessageEnum.text,
          sendTime: timeSent,
          messageId: messageId);
      // await firestore.collection('users').doc(receiverUser).collection('chats').add({
      //   'text': text,
      //   'sender': senderUser.name,
      //   'time': DateTime.now().millisecondsSinceEpoch,
      // });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageEnum messageEnum,
    required ProviderRef ref,
  }) async {
    try {
      var timeSent = DateTime.now();

      var messageId = const Uuid().v1();
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              "chat/${messageEnum.type}/${senderUser.uid}/$receiverUserId/$messageId",
              file);
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromJson(userDataMap.data()!);
      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '📸 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }
      saveDataToUserSubCollection(
        receiverUser: receiverUserData,
        senderUser: senderUser,
        message: imageUrl,
        receiverUserId: receiverUserId,
        time: timeSent,
      );

      saveMessageToMessageSubCollection(
        text: imageUrl,
        messageId: messageId,
        receiverUserId: receiverUserId,
        senderUserName: senderUser.name,
        receiverUserName: receiverUserData.name,
        messageType: messageEnum,
        sendTime: timeSent,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReplyModel? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

      if (!isGroupChat) {
        var userDataMap =
        await firestore.collection('users').doc(receiverUserId).get();
        recieverUserData = UserModel.fromJson(userDataMap.data()!);
      }

      var messageId = const Uuid().v1();

      saveDataToContactsSubcollection(
        senderUser,
        recieverUserData,
        'GIF',
        timeSent,
        receiverUserId,
        isGroupChat,
      );

      saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: gifUrl,
        sendTime: timeSent,
        messageType: MessageEnum.gif,
        messageId: messageId,
        senderUserName: senderUser.name,
        // : messageReply,
        receiverUserName: recieverUserData?.name,
        // senderUsername: senderUser.name,
        // isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar( context,  e.toString());
    }
  }
}
///
class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  ChatRepository({
    required this.firestore,
    required this.firebaseAuth,
  });

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromJson(userData.data()!);

        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePicture,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }


  Stream<List<MessageModel>> getChatStream(String receiverUserId) {
    return firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var document in event.docs) {
        messages.add(MessageModel.fromJson(document.data()));
      }
      return messages;
    });
  }

  Stream<List<MessageModel>> getGroupChatStream(String groudId) {
    return firestore
        .collection('groups')
        .doc(groudId)
        .collection('chats')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var document in event.docs) {
        messages.add(MessageModel.fromJson(document.data()));
      }
      return messages;
    });
  }

  void _saveDataToContactsSubcollection(
      UserModel senderUserData,
      UserModel? recieverUserData,
      String text,
      DateTime timeSent,
      String receiverUserId,
      bool isGroupChat,
      ) async {
    if (isGroupChat) {
      await firestore.collection('groups').doc(receiverUserId).update({
        'lastMessage': text,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
// users -> reciever user id => chats -> current user id -> set data
      var recieverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePicture,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text,
      );
      await firestore
          .collection('users')
          .doc(receiverUserId)
          .collection('chats')
          .doc(firebaseAuth.currentUser!.uid)
          .set(
        recieverChatContact.toMap(),
      );
      // users -> current user id  => chats -> reciever user id -> set data
      var senderChatContact = ChatContact(
        name: recieverUserData!.name,
        profilePic: recieverUserData.profilePicture,
        contactId: recieverUserData.uid,
        timeSent: timeSent,
        lastMessage: text,
      );
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .set(
        senderChatContact.toMap(),
      );
    }
  }

  void _saveMessageToMessageSubcollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required MessageEnum messageType,
    required MessageReplyModel? messageReply,
    required String senderUsername,
    required String? receiverUserName,
    required bool isGroupChat,
  }) async {
    final message = MessageModel(
      senderID: firebaseAuth.currentUser!.uid,
      receiverID: receiverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageID: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
          ? senderUsername
          : receiverUserName ?? '',
      repliedMessageType:
      messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );
    if (isGroupChat) {
      // groups -> group id -> chat -> message
      await firestore
          .collection('groups')
          .doc(receiverUserId)
          .collection('chats')
          .doc(messageId)
          .set(
        message.toJson(),
      );
    } else {
      // users -> sender id -> reciever id -> messages -> message id -> store message
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .collection('messages')
          .doc(messageId)
          .set(
        message.toJson(),
      );
      // users -> eciever id  -> sender id -> messages -> message id -> store message
      await firestore
          .collection('users')
          .doc(receiverUserId)
          .collection('chats')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(
        message.toJson(),
      );
    }
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReplyModel? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

      if (!isGroupChat) {
        var userDataMap =
        await firestore.collection('users').doc(receiverUserId).get();
        recieverUserData = UserModel.fromJson(userDataMap.data()!);
      }

      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
        senderUser,
        recieverUserData,
        text,
        timeSent,
        receiverUserId,
        isGroupChat,
      );

      _saveMessageToMessageSubcollection(
        receiverUserId: receiverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        username: senderUser.name,
        messageReply: messageReply,
        receiverUserName: recieverUserData?.name,
        senderUsername: senderUser.name,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar( context,  e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReplyModel? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
        'chat/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId',
        file,
      );

      UserModel? recieverUserData;
      if (!isGroupChat) {
        var userDataMap =
        await firestore.collection('users').doc(receiverUserId).get();
        recieverUserData = UserModel.fromJson(userDataMap.data()!);
      }

      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '📸 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }
      _saveDataToContactsSubcollection(
        senderUserData,
        recieverUserData,
        contactMsg,
        timeSent,
        receiverUserId,
        isGroupChat,
      );

      _saveMessageToMessageSubcollection(
        receiverUserId: receiverUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUserData.name,
        messageType: messageEnum,
        messageReply: messageReply,
        receiverUserName: recieverUserData?.name,
        senderUsername: senderUserData.name,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar( context,  e.toString());    }
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReplyModel? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

      if (!isGroupChat) {
        var userDataMap =
        await firestore.collection('users').doc(receiverUserId).get();
        recieverUserData = UserModel.fromJson(userDataMap.data()!);
      }

      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
        senderUser,
        recieverUserData,
        'GIF',
        timeSent,
        receiverUserId,
        isGroupChat,
      );

      _saveMessageToMessageSubcollection(
        receiverUserId: receiverUserId,
        text: gifUrl,
        timeSent: timeSent,
        messageType: MessageEnum.gif,
        messageId: messageId,
        username: senderUser.name,
        messageReply: messageReply,
        receiverUserName: recieverUserData?.name,
        senderUsername: senderUser.name,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar( context,  e.toString());
    }
  }

  void setChatMessageSeen(
      BuildContext context,
      String receiverUserId,
      String messageId,
      ) async {
    try {
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(receiverUserId)
          .collection('chats')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      showSnackBar( context,  e.toString());
    }
  }
}