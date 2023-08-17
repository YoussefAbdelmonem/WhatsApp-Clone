import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/features/auth/repo/auth_repo.dart';

final authControllerProvider = Provider((ref) =>
    AuthController(authRepository: ref.watch(authRepositoryProvider)));

class AuthController {

  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  void signInWithPhoneNumber(BuildContext context, String phoneNumber) async {
    await authRepository.signInWithPhoneNumber(context, phoneNumber);
  }
}