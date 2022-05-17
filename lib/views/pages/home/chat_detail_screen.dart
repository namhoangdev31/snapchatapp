import 'dart:io';

import 'package:snapchatapp/firebase/chat_services.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:snapchatapp/firebase/storage_services.dart';
import 'package:snapchatapp/views/pages/home/video_call.dart';
import '../../../database/loading_model.dart';
import '../../../firebase/storage_services.dart';
import '../../../widgets/colors.dart';
import '../../../widgets/text.dart';
import '../../widgets/text.dart';

class ChatDetailScreen extends StatefulWidget {
  final String peopleID;
  final String peopleName;
  final String ChatID;
  final String peopleImage;
  final BuildContext? contextBackPage;
  const ChatDetailScreen({
    Key? key,
    required this.peopleID,
    required this.peopleName,
    required this.peopleImage,
    required this.ChatID,
    this.contextBackPage,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState(
      this.peopleID, this.peopleName, this.ChatID, this.peopleImage);
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final peopleID;
  final peopleName;
  final peopleImage;
  final ChatID;
  final currentUserID = FirebaseAuth.instance.currentUser?.uid;
  var chatDocID;
  final TextEditingController _textEditingController = TextEditingController();
  _ChatDetailScreenState(
      this.peopleID, this.peopleName, this.ChatID, this.peopleImage);

  void sendMessage(String message, String peopleChatID, String type) {
    if (message == '') return;
    chats.doc(ChatID).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uID': currentUserID,
      'content': message,
      'type': type
    }).then((value) async {
      _textEditingController.text = '';

      try {
        List<dynamic> data = await ChatService.getUserPeopleChatID(
            currentUserID: currentUserID.toString());
        List<String>? listPeoPleChatID =
            (data).map((e) => e as String).toList();
        if (listPeoPleChatID != null) {
          for (int i = 0; i < listPeoPleChatID.length; i++) {
            if (peopleChatID == listPeoPleChatID[i]) {
              return;
            }
          }
          final CollectionReference users =
              FirebaseFirestore.instance.collection('users');
          users.doc(currentUserID).update({
            'myChatPeopleID': FieldValue.arrayUnion([peopleChatID]),
          });
        }
      } catch (e) {
        final CollectionReference users =
            FirebaseFirestore.instance.collection('users');
        users.doc(currentUserID).update({
          'myChatPeopleID': FieldValue.arrayUnion([peopleChatID]),
        });
      }
    });
  }

  bool isSender(String sender) {
    return sender == currentUserID;
  }

  Alignment getAligment(sender) {
    if (sender == currentUserID) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  Future<File?> getImage(ImageSource src) async {
    var _picker = await ImagePicker().pickImage(source: src);
    if (_picker != null) {
      File? imageFile = File(_picker.path);
      return imageFile;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    context.read<LoadingModel>().isLoading = false;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              child: CircleAvatar(
                backgroundImage: NetworkImage(peopleImage),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Container(
              child: CustomText(
                alignment: Alignment.center,
                fontsize: 20,
                maxLines: 2,
                text: peopleName,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ],
        ),
        elevation: 0,
        toolbarHeight: 150,
        shadowColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            widget.contextBackPage?.read<LoadingModel>().changeBack();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: MyColors.mainColor,
        actions: [
        ],
      ),
      backgroundColor: MyColors.mainColor,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .doc(ChatID)
              .collection('messages')
              .orderBy('createdOn', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            //Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            if (snapshot.hasData) {
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black87.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(
                                1, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListView(
                          reverse: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            var data = document.data()! as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: data['type'] == 'image'
                                            ? Container(
                                                width: 200,
                                                height: 200,
                                                alignment: isSender(
                                                        data['uID'].toString())
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                                child: Image.network(
                                                  data['content'],
                                                  fit: BoxFit.cover,
                                                ))
                                            : BubbleSpecialThree(
                                                text: data['content'],
                                                color: isSender(
                                                        data['uID'].toString())
                                                    ? MyColors.secondColor
                                                    : Colors.grey,
                                                tail: true,
                                                isSender: isSender(
                                                    data['uID'].toString()),
                                                textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontFamily: 'Poppins'),
                                              ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        data['createdOn'] == null
                                            ? DateTime.now().toString()
                                            : DateFormat.yMMMd()
                                                .add_jm()
                                                .format(
                                                    data['createdOn'].toDate()),
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Consumer<LoadingModel>(
                    builder: (_, isLoadingImage, __) {
                      if (isLoadingImage.isLoading) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () async {
                                context.read<LoadingModel>().changeLoading();
                                File? fileImage =
                                    await getImage(ImageSource.camera);
                                if (fileImage == null) {
                                  context.read<LoadingModel>().changeLoading();
                                } else {
                                  String fileName =
                                      await StorageServices.uploadImage(
                                          fileImage);
                                  sendMessage(fileName, peopleID, 'image');
                                  try {
                                    context
                                        .read<LoadingModel>()
                                        .changeLoading();
                                  } catch (e) {}
                                }
                              },
                              icon: Icon(
                                Icons.enhance_photo_translate,
                                color: MyColors.mainColor,
                              )),
                          IconButton(
                              onPressed: () async {
                                context.read<LoadingModel>().changeLoading();
                                File? fileImage =
                                    await getImage(ImageSource.gallery);
                                if (fileImage == null) {
                                  context.read<LoadingModel>().changeLoading();
                                } else {
                                  String fileName =
                                      await StorageServices.uploadImage(
                                          fileImage);
                                  sendMessage(fileName, peopleID, 'image');
                                  try {
                                    context
                                        .read<LoadingModel>()
                                        .changeLoading();
                                  } catch (e) {}
                                }
                              },
                              icon: Icon(Icons.image_outlined,
                                  color: MyColors.mainColor)),
                          IconButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => videocall()));
                              },
                              icon: Icon(
                                Icons.call,
                                color: Colors.lightBlue,
                              )),
                          Expanded(
                            child: Container(
                              height: 45,
                              child: TextField(
                                controller: _textEditingController,
                                textAlignVertical: TextAlignVertical.bottom,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: MyColors.mainColor,
                                    ),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  hintText: "Type here ...",
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      sendMessage(_textEditingController.text,
                                          peopleID, 'text');
                                    },
                                    icon: Icon(
                                      Icons.send_rounded,
                                      color: MyColors.mainColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: Text('Failed!'),
            );
          }),
    );
  }
}
