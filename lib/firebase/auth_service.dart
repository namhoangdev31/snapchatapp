import 'package:snapchatapp/firebase/user_service.dart';
import 'package:snapchatapp/views/pages/home/initial_screen.dart';
import 'package:snapchatapp/views/pages/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../views/pages/home/home_screen.dart';
import '../widgets/snackbar.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  static loginFetch(
      {required BuildContext context,
      required email,
      required password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final storage = FlutterSecureStorage();
      String? uID = userCredential.user?.uid.toString();
      await storage.write(key: 'uID', value: uID);
      String? value = await storage.read(key: 'uID');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      getSnackBar(
        'Login',
        'Login Success.',
        Colors.lightBlue,
      ).show(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        getSnackBar(
          'Login',
          'No user found for that email.',
          Colors.yellowAccent,
        ).show(context);
        //print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print(e.code);

        getSnackBar(
                'Login', 'Wrong password provided for that user.', Colors.red)
            .show(context);
        //print('Wrong password provided for that user.');
      }
    }
  }

  static Logout({required BuildContext context}) async {
    try {
      FirebaseAuth.instance.signOut();
      final storage = FlutterSecureStorage();
      await storage.deleteAll();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InitialScreen()),
      );
      getSnackBar(
        'Logout',
        'Logout Success.',
        Colors.lightBlue,
      ).show(context);
    } catch (e) {}
  }

  static registerFetch(
      {required BuildContext context,
      required email,
      required password,
      required fullName}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print('${userCredential.user?.uid}');
      await UserService.addUser(
          UID: userCredential.user?.uid, fullName: fullName, email: email);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      getSnackBar(
        'Register',
        'Register Success.',
        Colors.lightBlue,
      ).show(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //print('The password provided is too weak.');
        getSnackBar(
          'Register',
          'The password provided is too weak.',
          Colors.yellowAccent,
        ).show(context);
      } else if (e.code == 'email-already-in-use') {
        getSnackBar(
          'Register',
          'The account already exists for that email.',
          Colors.yellowAccent,
        ).show(context);
        //print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
