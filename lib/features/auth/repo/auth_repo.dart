import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/common/repo/common_firebase_storage.dart';
import 'package:whats_app_clone/data/model/user_model.dart';
import 'package:whats_app_clone/features/auth/screens/otp/otp_screen.dart';
import 'package:whats_app_clone/features/auth/screens/user_information/user_information_screen.dart';
import 'package:whats_app_clone/screens/mobile_layout_screen.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firebaseFireStore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firebaseFireStore;

  AuthRepository({required this.auth, required this.firebaseFireStore});

  void signInWithPhoneNumber(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          Navigator.pushNamed(
            context,
            OTPScreen.routeName,
            arguments: verificationId,
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message!),
      ));
    }
  }

  void verifyOTP(
      {required BuildContext context,
      required String otp,
      required String verificationId}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message!),
      ));
    }
  }

  void saveUserData({
    required BuildContext context,
    required File? profileImage,
    required String name,
    required dynamic ref,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = "https://encrypted-tbn3.gstatic.com/licensed-image?q=tbn:ANd9GcRnXB0Z-Z_IfdLilDUsP2H3m_Ce68gZS1uU3Xdr-dlCYUxz6dVVGVq47uXLr8BFdHg3du51HppF15uCFis";

      if (profileImage != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepoProvider)
            .storeFileToFireStore("profileImages/$uid", profileImage);
      }
      var user = UserModel(
        name: name,
        phoneNumber: auth.currentUser!.uid,
        profilePicture: photoUrl,
        uid: uid,
        isOnline: true,
        groupIds: [],
      );
      await firebaseFireStore.collection("users").doc(uid).set(user.toJson());
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MobileLayoutScreen()), (route) => false);
    } catch (e) {
      print(e);
    }
  }
}
