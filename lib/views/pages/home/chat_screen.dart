import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../firebase/chat_services.dart';
import '../../../database/loading_model.dart';
import '../../../firebase/chat_services.dart';
import '../../../widgets/colors.dart';
import '../../../widgets/text.dart';
import '../../widgets/text.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);
  final currentUserID = FirebaseAuth.instance.currentUser?.uid;
  Stream<QuerySnapshot> currentUserStream() async* {
    List<dynamic> data = await ChatService.getUserPeopleChatID(
        currentUserID: currentUserID.toString());
    List<String>? listPeoPleChatID = (data).map((e) => e as String).toList();
    if (listPeoPleChatID == null) {
      yield* FirebaseFirestore.instance
          .collection('users')
          .where('uID', isEqualTo: 'udisao')
          .snapshots();
    } else {
      yield* FirebaseFirestore.instance
          .collection('users')
          .where('uID', whereIn: listPeoPleChatID)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white30,
            elevation: 0,
            centerTitle: true,
            leading: const Text(''),
            title: const Text(
              'SNAPCHAT',
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 40,
                fontFamily: 'Poppins',
              ),
            )),
        backgroundColor: Colors.white30,
        body: Column(
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
                      offset: const Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 12.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.people_rounded,
                            color: Colors.lightBlueAccent,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          CustomText(
                            alignment: Alignment.bottomLeft,
                            fontsize: 30,
                            text: 'Friends',
                            fontFamily: 'Popins',
                            color: Colors.lightBlueAccent,
                          ),
                        ],
                      ),
                    ),
                    Consumer<LoadingModel>(
                      builder: (_, isBack, __) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 3,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: currentUserStream(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Have no chatted people' ,);
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.black12,
                                  ),
                                ),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext ctx, int index) {
                                  final item = snapshot.data!.docs[index];
                                  return InkWell(
                                    onTap: () {
                                      ChatService.getChatID(
                                        context: context,
                                        peopleID: item['uID'],
                                        currentUserID: currentUserID.toString(),
                                        peopleName: item['fullName'],
                                        peopleImage: item['avartaURL'],
                                      );
                                    },
                                    child: ListTile(
                                      leading: Container(
                                        width: 48,
                                        height: 48,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        alignment: Alignment.center,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            item['avartaURL'],
                                          ),
                                        ),
                                      ),
                                      title: CustomText(
                                        alignment: Alignment.centerLeft,
                                        fontsize: 16,
                                        text: item['fullName'],
                                        fontFamily: 'Poppins',
                                        color: Colors.black54,
                                      ),
                                      subtitle: CustomText(
                                        alignment: Alignment.centerLeft,
                                        fontsize: 14,
                                        text: 'Age :${item['age']}',
                                        fontFamily: 'Poppins',
                                        color: Colors.black26,
                                      ),
                                      trailing: Wrap(spacing: 20, children: [
                                        InkWell(
                                          onTap: () {},
                                          child: const Icon(
                                            Icons.chat,
                                            color: Colors.grey,
                                          ),
                                        )
                                      ]),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
