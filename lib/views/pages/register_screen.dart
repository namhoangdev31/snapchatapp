import 'package:snapchatapp/firebase/auth_service.dart';
import 'package:flutter/material.dart';

import '../../widgets/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/textformfield.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _registerFormKey = GlobalKey<FormState>();

  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  String? validateEmail(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (!isValidEmail(value)) {
      return "Wrong Email !";
    } else {
      return null;
    }
  }

  doRegister(BuildContext context) {
    bool isValidate = _registerFormKey.currentState!.validate();
    if (isValidate) {
      AuthService.registerFetch(
        context: context,
        email: emailController.text,
        password: passwordController.text,
        fullName: nameController.text,
      );
    }
  }

  String? validatePassword(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (value.length <= 5) {
      return "Your password is so short !";
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (value != passwordController.text) {
      return "Your confirmation password does not match !";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      'assets/images/icon.png',
                      alignment: Alignment.center,
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 4 / 6,
                        width: MediaQuery.of(context).size.width - 32,
                        child: Form(
                          key: _registerFormKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomTextFormField(
                                  controller: nameController,
                                  text: 'Full-Name',
                                  hint: 'Nguyen Hoang Nam',
                                  onSave: (value) {},
                                  validator: (value) {
                                    return validatePassword(value!);
                                  }),
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                  controller: emailController,
                                  text: 'E-mail',
                                  hint: 'nguyennam@gmail.com',
                                  onSave: (value) {},
                                  validator: (value) {
                                    return validateEmail(value!);
                                  }),
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                  controller: passwordController,
                                  passCheck: true,
                                  text: 'Password',
                                  hint: 'enter your password',
                                  onSave: (value) {},
                                  validator: (value) {
                                    return validatePassword(value!);
                                  }),
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                  controller: confirmPasswordController,
                                  passCheck: true,
                                  text: 'Confirm Password',
                                  hint: 'enter again',
                                  onSave: (value) {},
                                  validator: (value) {
                                    return validateConfirmPassword(value!);
                                  }),
                              const SizedBox(height: 20),
                              CustomButton(
                                onPress: () {
                                  doRegister(context);
                                },
                                text: 'SIGN UP',
                                color: MyColors.secondColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
