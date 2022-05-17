import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  ReusableButton(
      {required this.btnCircularRadius,
      required this.btnWidth,
      required this.btnHeight,
      required this.btnChild,
      required this.btnColour});
  final Color btnColour;
  final Widget btnChild;
  final double btnHeight;
  final double btnWidth;
  final double btnCircularRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: btnHeight,
      width: btnWidth,
      decoration: BoxDecoration(
        color: btnColour,
        borderRadius: BorderRadius.circular(btnCircularRadius),
      ),
      child: btnChild,
    );
  }
}
