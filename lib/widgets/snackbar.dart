import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Flushbar getSnackBar(String text, String message, Color color) => Flushbar(
      title: text,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      titleColor: color,
      backgroundColor: Colors.black.withOpacity(0.7),
      duration: Duration(seconds: 2),
      borderRadius: BorderRadius.circular(15),
    );
