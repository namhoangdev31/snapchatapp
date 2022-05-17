import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../views/pages/home/chat_detail_screen.dart';

class ChatService {
  static getChatID(
      {required BuildContext context,
      required String peopleID,
      required String currentUserID,
      required String peopleImage,
      required String peopleName}) {
    CollectionReference chats = FirebaseFirestore.instance.collection('chats');
    String chatDocID;
    chats
        .where('users', isEqualTo: {peopleID: null, currentUserID: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              chatDocID = querySnapshot.docs.single.id;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatDetailScreen(
                          peopleID: peopleID,
                          peopleName: peopleName,
                          ChatID: chatDocID,
                          peopleImage: peopleImage,
                          contextBackPage: context,
                        )),
              );
            } else {
              chats.add({
                'users': {currentUserID: null, peopleID: null}
              }).then((value) {
                chatDocID = value.id;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatDetailScreen(
                            peopleID: peopleID,
                            peopleName: peopleName,
                            ChatID: chatDocID,
                            peopleImage: peopleImage,
                            contextBackPage: context,
                          )),
                );
              });
            }
          },
        )
        .catchError((e) {});
  }

  static Future getUserPeopleChatID({required String currentUserID}) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final result = await users.doc(currentUserID).get();
    return result.get('myChatPeopleID');
  }

  static Future getUserPeopleChat({required String currentUserID}) async {
    List<dynamic> data = await ChatService.getUserPeopleChatID(
        currentUserID: currentUserID.toString());
    List<String>? listPeoPleChatID = (data).map((e) => e as String).toList();
    FirebaseFirestore.instance
        .collection('users')
        .where('uID', whereIn: listPeoPleChatID)
        .snapshots();
    return await FirebaseFirestore.instance
        .collection('users')
        .where('uID', whereIn: listPeoPleChatID)
        .snapshots();
  }
}
