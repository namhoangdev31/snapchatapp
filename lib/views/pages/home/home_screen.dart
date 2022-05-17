import 'package:snapchatapp/views/pages/home/chat_screen.dart';
import 'package:snapchatapp/views/pages/home/user_screen.dart';
import 'package:snapchatapp/views/pages/home/video_screen.dart';
import '../../../widgets/colors.dart';
import '../../../widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _tabIndex = 0;

  void _changeTabIndex(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: IndexedStack(
          index: _tabIndex,
          children: [ChatScreen(), VideoScreen(), UserInfoScreen()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2_fill),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2),
            label: 'People',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_alt_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _tabIndex,
        selectedItemColor: MyColors.mainColor,
        onTap: _changeTabIndex,
      ),
    );
  }
}
