import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/colors.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:whats_app_clone/features/auth/controller/auth_controller.dart';
import 'package:whats_app_clone/features/auth/repo/auth_repo.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  CountryCode? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void sendNumber() {
    String phoneNumber = phoneController.text.trim();
    if(country!=null && phoneNumber.isNotEmpty){
      ref.read(authControllerProvider).signInWithPhoneNumber(context, "${country!.dialCode}$phoneNumber");
    }

    // ref.read(provider)
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('WhatsApp will need to verify your phone number.'),
              const SizedBox(height: 10),
              TextButton(
                onPressed: (){
                  showDialog(context: context, builder: (_){
                    return  Center(
                      child: CountryCodePicker(
                        onChanged: (CountryCode countryCode) {
                          setState(() {
                            country = countryCode;
                          });

                        },


                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                      ),
                    );
                  });
                },
                child: const Text('Pick Country'),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  if (country != null) Text('${country!.dialCode}'),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        hintText: 'phone number',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.6),
              // SizedBox(
              //   width: 90,
              //   child: CustomButton(
              //     onPressed: sendPhoneNumber,
              //     text: 'NEXT',
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
