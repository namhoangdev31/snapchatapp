import 'package:snapchatapp/views/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapchatapp/widgets/text.dart';

class CustomButton extends StatelessWidget {
  final String text;

  final Color color;

  final VoidCallback onPress;

  CustomButton({
    required this.onPress,
    this.text = 'Write text ',
    this.color = Colors.black38,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(10),
      onPressed: onPress,
      color: color,
      child: CustomText(
        alignment: Alignment.center,
        text: text,
        color: Colors.white,
      ),
    );
  }
}
