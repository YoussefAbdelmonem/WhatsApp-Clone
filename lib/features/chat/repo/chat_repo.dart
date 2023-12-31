import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_app_clone/common/enums/message_enum.dart';
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
  void sendGIFMessage(
      BuildContext context,
      String gifUrl,
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
        message: "GIF",
        receiverUserId: receiverUserData.uid,
        time: timeSent,
      );

      saveMessageToMessageSubCollection(
          text: gifUrl,
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
}
