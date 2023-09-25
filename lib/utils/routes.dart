import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whats_app_clone/features/auth/screens/login/screen/login_screen.dart';
import 'package:whats_app_clone/features/auth/screens/otp/otp_screen.dart';
import 'package:whats_app_clone/features/auth/screens/splash/splash_screen.dart';
import 'package:whats_app_clone/features/auth/screens/user_information/user_information_screen.dart';
import 'package:whats_app_clone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whats_app_clone/features/status/screens/status_screen.dart';

import '../data/model/status_model.dart';
import '../features/chat/screens/mobile_chat_screen.dart';
import '../features/status/screens/confirm_status_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );

    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactScreen(),
      );case MobileChatScreen.routeName:
        final args = settings.arguments as Map<String, dynamic>;
        final name =args["name"];
        final uid =args["uid"];
      return MaterialPageRoute(
        builder: (context) =>  MobileChatScreen(name: name, uid: uid,),
      );
    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(
          file: file,
        ),
      );
    case StatusScreen.routeName:
      final status = settings.arguments as Status;
      return MaterialPageRoute(
        builder: (context) => StatusScreen(
          status: status,
        ),
      );



    default:
      return MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );
  }
}