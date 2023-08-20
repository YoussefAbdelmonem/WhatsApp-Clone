import 'package:flutter/material.dart';
import 'package:whats_app_clone/features/auth/screens/login/screen/login_screen.dart';
import 'package:whats_app_clone/features/auth/screens/otp/otp_screen.dart';
import 'package:whats_app_clone/features/auth/screens/splash/splash_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );

    case OTPScreen.routeName:
      // final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          // verificationId: verificationId,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );
  }
}