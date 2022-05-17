import 'package:flutter/material.dart';

class GenderModel extends ChangeNotifier {
  String gender;

  GenderModel({this.gender = 'Male'});

  changeMale() {
    if (gender == 'Male') {
      gender = 'Female';
    } else {
      gender = 'Male';
    }
    notifyListeners();
  }
}

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text("Male"), value: "Male"),
    DropdownMenuItem(child: Text("Female"), value: "Female"),
  ];
  return menuItems;
}
