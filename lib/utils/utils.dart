

import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImageFromGallery (BuildContext context)async{
  File? image;
  try{
    final pickedImage =await ImagePicker().pickImage(source:ImageSource.gallery );
    if(pickedImage !=null){
      image = File(pickedImage.path);
    }


  }catch(e){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString()))
    );
  }
  return image;

}
Future<File?> pickVideoFromGallery (BuildContext context)async{
  File? video;
  try{
    final pickedVideo =await ImagePicker().pickVideo(source:ImageSource.gallery );
    if(pickedVideo !=null){
      video = File(pickedVideo.path);
    }


  }catch(e){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString()))
    );
  }
  return video;

}

void showSnackBar(BuildContext context, String string) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(string),
      )
  );
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(
      context: context,
      apiKey: 'pwXu0t7iuNVm8VO5bgND2NzwCpVH9S0F',
    );
  } catch (e) {
    showSnackBar( context, e.toString());
  }
  return gif;
}