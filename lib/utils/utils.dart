

import 'dart:io';

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