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

  Future<UserModel?> getCurrentUserData() async {
    var userData = await firebaseFireStore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromJson(userData.data()!);
    }
    return user;
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserInformationScreen.routeName,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      }

      var user = UserModel(
        name: name,
        uid: uid,
        isOnline: true,
        phoneNumber: auth.currentUser!.phoneNumber!,
        groupIds: [],
        profilePicture: photoUrl,
      );

      await firebaseFireStore.collection('users').doc(uid).set(user.toJson());

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileLayoutScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Stream<UserModel> userData(String userId) {
    return firebaseFireStore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromJson(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await firebaseFireStore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({
      'isOnline': isOnline,
    });
  }
}
