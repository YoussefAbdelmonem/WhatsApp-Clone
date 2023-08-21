import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/colors.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:whats_app_clone/componets/button_widget.dart';
import 'package:whats_app_clone/componets/text_widget.dart';
import 'package:whats_app_clone/features/auth/controller/auth_controller.dart';
import 'package:whats_app_clone/features/auth/repo/auth_repo.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login-screen';

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
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, "${country!.dialCode}$phoneNumber");
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
              GestureDetector(
                onTap: (){
                  print("${country!.dialCode}${phoneController.text.trim()}");
                },
                child: const TextWidget(
                  title: 'WhatsApp will need to verify your phone number.',
                  color: textColor,
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return Center(
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
                  if (country != null) TextWidget(title: '${country!.dialCode}',color: Colors.white),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,


                      decoration: const InputDecoration(
                        hintText: 'phone number',
                        fillColor: textColor,
                        hintStyle: TextStyle(
                          color: textColor,

                        )
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.58),
              SizedBox(
                width: 100,
                child: ButtonWidget(
                  title: 'Next',
                  onTap: sendNumber,




                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
