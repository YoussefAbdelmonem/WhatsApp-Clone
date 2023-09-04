import 'package:flutter/material.dart';
import 'package:whats_app_clone/colors.dart';
import 'package:whats_app_clone/utils/responsive_layout.dart';

class SendChatWidget extends StatefulWidget {
   SendChatWidget({super.key});

  @override
  State<SendChatWidget> createState() => _SendChatWidgetState();
}

class _SendChatWidgetState extends State<SendChatWidget> {
TextEditingController controller = TextEditingController();

 String text ='';

void update(value){
  text = value;
  setState(() {
  });
}

  @override
  Widget build(BuildContext context) {

    return  Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            onChanged: (value){
              update(value);
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: chatBarMessage,
              prefixIcon:  Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: IconButton(onPressed: (){}, icon: Icon(Icons.emoji_emotions, color: Colors.grey,)),

              ),
              suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.camera_alt, color: Colors.grey,)),
              hintText: 'Type a message!',
              hintStyle: TextStyle(
                color: Colors.white,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        CircleAvatar(
          backgroundColor: tabColor,
          radius:30 ,
          child: IconButton(
            onPressed: (){
              print(text);

            },
            icon:text.isNotEmpty?const Icon(Icons.send):  Icon(Icons.mic),
          ),
        )
      ],
    );
  }
}
