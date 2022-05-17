import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonTextCustom extends StatelessWidget {
  final String text;
  final double fontsize;
  final Color color;
  final Alignment alignment;
  final int? maxLines;
  final double height;
  final String fontFamily;
  final int fontWeight;
  final VoidCallback onPress;

  ButtonTextCustom(
      {this.text = '',
      this.fontsize = 16,
      this.color = Colors.black,
      this.alignment = Alignment.topLeft,
      this.maxLines,
      this.height = 1,
      this.fontFamily = 'Poppins-Regular',
      this.fontWeight = 1,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: alignment,
        child: TextButton(
          onPressed: onPress,
          child: Text(
            text,
            style: TextStyle(
                color: color,
                height: height,
                fontSize: fontsize,
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold),
            maxLines: maxLines,
          ),
        ));
  }
}
