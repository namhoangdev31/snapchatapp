import 'package:snapchatapp/views/pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:snapchatapp/views/pages/login_screen.dart';

import '../../../widgets/RéuableButton.dart';
import '../../../widgets/video_player_item.dart';


//Constants

const Color scaffoldColor = Color(0xFFFFFC00);
const Color loginButtonColor = Colors.white;
const Color signupButtonColor = Color(0xFF0EAEFE);

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/icon.png"))),
              ),
              Text(
                "APP CHAT FOR EVERYONE",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                "Design by NGUYỄN HOÀNG NAM",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: ReusableButton(
                          btnHeight: 60,
                          btnWidth: 130,
                          btnColour: loginButtonColor,
                          btnCircularRadius: 80,
                          btnChild: Text(
                            "Log in",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        },
                        child: ReusableButton(
                          btnHeight: 60,
                          btnWidth: 130,
                          btnColour: signupButtonColor,
                          btnCircularRadius: 80,
                          btnChild: Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
