import 'package:flutter/material.dart';
import 'package:whats_app_clone/componets/button_widget.dart';
import 'package:whats_app_clone/componets/text_widget.dart';
import 'package:whats_app_clone/utils/responsive_layout.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/main.png",
                  width: 300,
                  height: 300,
                ),
                32.ph,
                const TextWidget(
                  title:
                      'Read our Privacy Policy. Tap “Agree and continue” to accept the Teams of Service.',
                  color: Colors.white,
                fontSize: 14,
                ),
                64.ph,
                ButtonWidget(
                  title: "AGREE AND CONTINUE",
                  onTap: (){
                    Navigator.pushNamed(context, '/login-screen');
                  },
                )
              ]),
        ),
      ),
    );
  }
}
