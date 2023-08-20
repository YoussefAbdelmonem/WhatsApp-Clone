import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/features/auth/controller/auth_controller.dart';
import 'package:whats_app_clone/utils/responsive_layout.dart';
import 'package:whats_app_clone/utils/utils.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  const UserInformationScreen({super.key});

  static const String routeName = '/user-information-screen';

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  File? image;
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {

    });
  }
  void storeUserData(){
    String name = nameController.text.trim();
    if(name.isNotEmpty){
      ref.read(authControllerProvider).saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              32.ph,
              Stack(
                children: [
                  image == null
                      ? const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://encrypted-tbn3.gstatic.com/licensed-image?q=tbn:ANd9GcRnXB0Z-Z_IfdLilDUsP2H3m_Ce68gZS1uU3Xdr-dlCYUxz6dVVGVq47uXLr8BFdHg3du51HppF15uCFis"),
                          radius: 64,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(image!),
                          radius: 64,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 70,
                    child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
              32.ph,

              Row(
                children: [
                  Container(
                    width:size.width*0.75 ,
                    color: Colors.white38,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Enter your name",
                      )
                    ),
                  ),
                  IconButton(onPressed: storeUserData,
                      icon: Icon(Icons.done ,color: Colors.white,))
                ],
              )

            ],
          ),
        ),
      ),
    ));
  }
}
