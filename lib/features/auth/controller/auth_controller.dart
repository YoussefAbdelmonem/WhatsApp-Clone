import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/features/auth/repo/auth_repo.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(ref, authRepository: ref.watch(authRepositoryProvider)),
);

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref ;

  AuthController(this.ref, {required this.authRepository});

  signInWithPhoneNumber(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhoneNumber(context, phoneNumber);
  }

  verifyYourOtp(BuildContext context, String verificationID, String otp) {
    authRepository.verifyOTP(
        context: context, otp: otp, verificationId: verificationID);
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePicture) {
    authRepository.saveUserData(
      context: context,
      name: name,
      profileImage: profilePicture,
      ref: ref,
    );
  }
}
