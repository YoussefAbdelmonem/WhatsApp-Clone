
import 'package:flutter/material.dart';
import 'package:whats_app_clone/colors.dart';
import 'package:whats_app_clone/componets/text_widget.dart';

class ButtonWidget extends StatelessWidget {
  String title;

  double width, height, radius;
  double? fontSize;
  Widget? child;
  Color textColor, buttonColor, borderColor, inkColor;
  void Function()? onTap;
  bool withBorder;

  ButtonWidget(
      {Key? key,
        this.title = "OK",
        this.width = 88.0,
        this.height = 50.0,
        this.onTap,
        this.child,
        this.fontSize,
        this.textColor = Colors.white,
        this.buttonColor = tabColor,
        this.borderColor = tabColor,
        this.inkColor = tabColor,
        this.withBorder = false,
        this.radius = 32.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
          shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                  side: withBorder
                      ? BorderSide(color: borderColor)
                      : const BorderSide(color: Colors.transparent)))),
      onPressed: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: inkColor,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        child: child ??
            Container(
              constraints: BoxConstraints(minWidth: width, minHeight: height),
              // min sizes for Material buttons
              alignment: Alignment.center,
              child: TextWidget(
                title: title,
                fontSize: fontSize ?? 16,
                textAlign: TextAlign.center,
                color: textColor,
              ),
            ),
      ),
    );
  }
}