import 'package:flutter/material.dart';
import 'package:whats_app_clone/componets/text_widget.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});
  static const String routeName = '/otp-screen';

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidget(
          title: 'verifying your number',

        ),
      ),
      body: Column(),
    );
  }
}
