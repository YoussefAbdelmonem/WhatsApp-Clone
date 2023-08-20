import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whats_app_clone/utils/responsive_layout.dart';
import 'package:whats_app_clone/utils/utils.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  static const String routeName = '/user-information-screen';

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Center(
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
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                    )
                  ),
                ),
                IconButton(onPressed: (){}, icon: Icon(Icons.add ))
              ],
            )

          ],
        ),
      ),
    ));
  }
}
