import 'package:snapchatapp/views/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'text.dart';

class CustomTextFormField extends StatelessWidget {
  final String text;

  final String hint;
  final bool? enable;
  final bool? passCheck;

  final void Function(String?)? onSave;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final TextInputType textType;

  CustomTextFormField({
    this.controller,
    required this.text,
    required this.hint,
    required this.onSave,
    required this.validator,
    this.enable,
    this.passCheck,
    this.textType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CustomText(
            text: text,
            fontsize: 20,
            color: Color.fromARGB(255, 128, 128, 16),
            fontFamily: 'Poppins-Regular',
          ),
          TextFormField(
            obscureText: passCheck == true ? true : false,
            keyboardType: textType,
            enabled: enable,
            controller: controller,
            onSaved: onSave,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              fillColor: Colors.redAccent,
            ),
          )
        ],
      ),
    );
  }
}
