import 'package:flutter/material.dart';
import 'package:whats_app_clone/colors.dart';

class SendChatWidget extends StatelessWidget {
  const SendChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: mobileChatBoxColor,
        prefixIcon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Icon(Icons.emoji_emotions, color: Colors.grey,),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(Icons.camera_alt, color: Colors.grey,),
              Icon(Icons.attach_file, color: Colors.grey,),
            ],
          ),
        ),
        hintText: 'Type a message!',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        contentPadding: const EdgeInsets.all(10),
      ),
    );
  }
}
