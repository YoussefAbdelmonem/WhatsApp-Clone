import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_clone/data/model/chat_contacts_model.dart';
import 'package:whats_app_clone/data/model/user_model.dart';
import 'package:whats_app_clone/utils/utils.dart';

class ChatRepository {
  final FirebaseFirestore firestore;

  final FirebaseAuth firebaseAuth;

  ChatRepository({required this.firestore, required this.firebaseAuth});

  void saveDataToUserSubCollection({
    required UserModel receiverUser,
    required UserModel senderUser,
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

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
    UserModel senderUser,
  ) async {
    try {
      var timeSent = DateTime.now();
      UserModel? receiverUserData;

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