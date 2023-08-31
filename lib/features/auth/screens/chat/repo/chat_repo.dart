
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_clone/data/model/user_model.dart';
import 'package:whats_app_clone/utils/utils.dart';

class ChatRepository {
  final FirebaseFirestore firestore;

 final FirebaseAuth firebaseAuth;

  ChatRepository({required this.firestore, required this.firebaseAuth});


void sendTextMessage(
     BuildContext context,
     String text,
     String recieverUserId,
     UserModel senderUser,
  )async {
    try{
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

      var userDataMap =
      await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromJson(userDataMap.data()!);


      // await firestore.collection('users').doc(receiverUser).collection('chats').add({
      //   'text': text,
      //   'sender': senderUser.name,
      //   'time': DateTime.now().millisecondsSinceEpoch,
      // });

    }catch(e){
      showSnackBar(context, e.toString());
    }
  }

}
