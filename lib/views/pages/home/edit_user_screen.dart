import 'package:snapchatapp/database/gender_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/text.dart';
import '../../../firebase/user_service.dart';
import '../../../widgets/textformfield.dart';

class EditUserInfoScreen extends StatelessWidget {
  EditUserInfoScreen({Key? key}) : super(key: key);

  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController ageController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  final _editUserFormKey = GlobalKey<FormState>();

  late String genderInfo = 'Male';

  doEdit(BuildContext context) {
    bool isValidate = _editUserFormKey.currentState!.validate();
    if (isValidate) {
      UserService.editUserFetch(
          context: context,
          phone: phoneController.text,
          fullName: nameController.text,
          gender: genderInfo,
          age: ageController.text);
    }
  }

  String? validateFullName(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (value.length >= 50) {
      return "Your name is so dark !";
    } else {
      return null;
    }
  }

  String? validatePhone(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (value.length != 10) {
      return "Your phone number is wrong !";
    } else {
      return null;
    }
  }

  String? validateAge(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (value.length >= 3) {
      return "Your age is so dark !";
    } else {
      try {
        int age = int.parse(value);
        return null;
      } catch (e) {
        return 'Age Format is wrong';
      }
    }
  }

  String? validateConfirmPassword(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (value != ageController.text) {
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
                  Positioned(
                    top: MediaQuery.of(context).size.height / 10,
                    left: MediaQuery.of(context).size.width / 3,
                    child: Center(
                      child: CustomText(
                        text: 'Edit Info',
                        fontsize: 40,
                        color: Color.fromARGB(255, 128, 128, 16),
                        fontFamily: 'Poppins-Regular',
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 0,
                    child: IconButton(
                      iconSize: 40,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
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
                          key: _editUserFormKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomTextFormField(
                                  controller: nameController,
                                  text: 'Full Name',
                                  hint: 'Nguyen Hoang Nam',
                                  onSave: (value) {
                                    //controller.userPwd = value!;
                                  },
                                  validator: (value) {
                                    return validateFullName(value!);
                                  }),
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                  controller: phoneController,
                                  text: 'Phone Number',
                                  hint: '0369377230',
                                  onSave: (value) {},
                                  validator: (value) {
                                    return validatePhone(value!);
                                  }),
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                  controller: ageController,
                                  textType: TextInputType.number,
                                  text: 'Age',
                                  hint: '22',
                                  onSave: (value) {},
                                  validator: (value) {
                                    return validateAge(value!);
                                  }),
                              const SizedBox(height: 20),
                              CustomText(
                                text: 'Gender',
                                fontsize: 20,
                                color: Color.fromARGB(255, 128, 128, 16),
                                fontFamily: 'Poppins-Regular',
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Consumer<GenderModel>(
                                  builder: (_, genderUser, __) {
                                    return DropdownButton(
                                      value: genderUser.gender,
                                      items: dropdownItems,
                                      onChanged: (Object? value) {
                                        genderUser.changeMale();
                                        genderInfo =
                                            context.read<GenderModel>().gender;
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomButton(
                                onPress: () {
                                  doEdit(context);
                                },
                                text: 'SAVE',
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
