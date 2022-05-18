import 'dart:io';

import 'package:snapchatapp/database/loading_model.dart';
import 'package:snapchatapp/firebase/auth_service.dart';
import 'package:snapchatapp/firebase/storage_services.dart';
import 'package:snapchatapp/firebase/user_service.dart';
import 'package:snapchatapp/views/pages/home/edit_user_screen.dart';
import 'package:snapchatapp/views/widgets/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:snapchatapp/widgets/custom_button.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../widgets/colors.dart';
import '../../../widgets/text.dart';
import '../../../widgets/video_player_item.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  // File? imageFile;

  @override
  void initState() {
    super.initState();
    // print('Current UserID:${FirebaseAuth.instance.currentUser?.uid}');
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<File?> getImage() async {
    var _picker = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_picker != null) {
      File? imageFile = File(_picker.path);
      return imageFile;
    }
    return null;
  }

  Stream<QuerySnapshot> getUserImage() async* {
    final currentUserID = await FirebaseAuth.instance.currentUser?.uid;
    yield* FirebaseFirestore.instance
        .collection('users')
        .where('uID', isEqualTo: currentUserID)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: UserService.getUserInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width / 8,
                    // ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditUserInfoScreen()),
                        );
                      },
                      iconSize: 25,
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                    ),
                    Center(
                      child: CustomText(
                        fontsize: 40,
                        text: '${snapshot.data.get('fullName')}',
                        fontFamily: 'Poppins-Regular',
                        color: Color.fromARGB(255, 128, 128, 16),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        AuthService.Logout(context: context);
                      },
                      iconSize: 25,
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 100,
                  width: 100,
                  child: Stack(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: getUserImage(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Consumer<LoadingModel>(
                                builder: (_, isLoadingImage, __) {
                                  if (isLoadingImage.isLoading) {
                                    return const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else {
                                    return CircleAvatar(
                                      backgroundColor: MyColors.mainColor,
                                      backgroundImage: NetworkImage(snapshot
                                          .data?.docs.first['avartaURL']),
                                    );
                                  }
                                },
                              );
                            }),
                      ),
                      Positioned(
                        bottom: -16,
                        right: -15,
                        child: IconButton(
                          onPressed: () async {
                            context.read<LoadingModel>().changeLoading();
                            File? fileImage = await getImage();
                            if (fileImage == null) {
                              context.read<LoadingModel>().changeLoading();
                            } else {
                              String fileName =
                                  await StorageServices.uploadImage(fileImage);
                              UserService.editUserImage(
                                  context: context, ImageStorageLink: fileName);
                              context.read<LoadingModel>().changeLoading();
                            }
                          },
                          icon: const Icon(
                            Icons.cloud_upload_outlined,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                CustomText(
                  alignment: Alignment.center,
                  fontsize: 25,
                  text: '${snapshot.data.get('email')}',
                  fontFamily: 'Poppins-Regular',
                  color: Color.fromARGB(255, 128, 128, 16),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: TabBar(
                    controller: _tabController,
                    // indicatorColor: Colors.green,
                    // labelColor: Colors.red,
                    indicator: MaterialIndicator(
                      height: 3,
                      topLeftRadius: 0,
                      topRightRadius: 0,
                      bottomLeftRadius: 5,
                      bottomRightRadius: 5,
                      horizontalPadding: 16,
                      tabPosition: TabPosition.bottom,
                    ),
                    tabs: const <Widget>[
                      Tab(
                        icon: Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.ondemand_video,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: MediaQuery.of(context).size.height - 363,
                  width: MediaQuery.of(context).size.width,
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, top: 22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 14,
                                    text: 'Full Name ',
                                    fontFamily: 'Poppins',
                                    color: Colors.black26,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 20,
                                    text: '${snapshot.data.get('fullName')}',
                                    fontFamily: 'Montserrat',
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 14,
                                    text: 'Phone Number ',
                                    fontFamily: 'Poppins',
                                    color: Colors.black26,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 20,
                                    text: '${snapshot.data.get('phone')}',
                                    fontFamily: 'Montserrat',
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 14,
                                    text: 'Age',
                                    fontFamily: 'Poppins',
                                    color: Colors.black26,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 20,
                                    text: '${snapshot.data.get('age')}',
                                    fontFamily: 'Montserrat',
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 14,
                                    text: 'Gender',
                                    fontFamily: 'Poppins',
                                    color: Colors.black26,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 20,
                                    text: '${snapshot.data.get('gender')}',
                                    fontFamily: 'Montserrat',
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 14,
                                    text: 'Email',
                                    fontFamily: 'Poppins',
                                    color: Colors.black26,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomText(
                                    alignment: Alignment.centerLeft,
                                    fontsize: 20,
                                    text: '${snapshot.data.get('email')}',
                                    fontFamily: 'Montserrat',
                                    color: Colors.black87,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        child: const Center(
                            child: VideoPlayerItem(
                          videoUrl:
                              'https://firebasestorage.googleapis.com/v0/b/appsnapchat-a5efe.appspot.com/o/images%2Fy2meta.com%20-%20Ta%20V%C3%A0%20N%C3%A0ng-(1080p).mp4?alt=media&token=b39724df-1a69-4935-b88f-62a5cf5ed003',
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
