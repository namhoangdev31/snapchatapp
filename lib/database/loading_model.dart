import 'package:flutter/material.dart';

class LoadingModel extends ChangeNotifier {
  bool isLoading;
  bool isBack;

  LoadingModel({this.isLoading = false, this.isBack = false});

  changeLoading() {
    if (isLoading == false) {
      isLoading = true;
    } else {
      isLoading = false;
    }
    notifyListeners();
  }

  changeBack() {
    if (isBack == false) {
      isBack = true;
    } else {
      isBack = false;
    }
    notifyListeners();
  }
}
