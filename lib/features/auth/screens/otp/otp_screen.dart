import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/componets/text_widget.dart';
import 'package:whats_app_clone/features/auth/controller/auth_controller.dart';
import 'package:whats_app_clone/utils/responsive_layout.dart';

class OTPScreen extends ConsumerWidget {
  const OTPScreen({ required this.verificationId});
  static const String routeName = '/otp-screen';
  final String verificationId;

  void verifyOtp(BuildContext context ,String userOtp, WidgetRef ref){
    ref.read(authControllerProvider).verifyYourOtp(context, verificationId, userOtp);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const TextWidget(
          title: 'verifying your number',

        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            32.ph,
            const TextWidget(
              title: 'We have send SMS with a code to your phone number',
              color: Colors.white,
              textAlign: TextAlign.center,
              fontSize: 16,

            ),
            32.ph,
            SizedBox(
              width: size.width * 0.6,
              child:  TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "- - - - - -",

                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 30,



                  )
                ),
                keyboardType: TextInputType.number,
                onChanged: (value){
                  if(value.length == 6){
                    print("verify");
                    verifyOtp(context, value.trim(), ref);
                  }
                  print("progress");
                },
              ),
            )
          ]
        ),
      ),
    );
  }

}
