import 'package:Kura/widgets/chat/Message.dart';
import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

//displays messages
class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(), //gets current user data from firebase auth
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          //gets stream and order by "createdTime" in descending way
          stream: Firestore.instance.collection("chat").orderBy("createdTime", descending: true).snapshots(),
          builder: (context, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final chatDocuments = chatSnapshot.data.documents; //chat collection from firebase
            return ListView.builder(
              reverse: true, //starts building widget from bottom to top
              itemBuilder: (ctx, index) => Message(
                message: chatDocuments[index]["message"],
                isMe: chatDocuments[index]["userId"] == futureSnapshot.data.uid,
                key: ValueKey(chatDocuments[index].documentID),
                userName: chatDocuments[index]["userName"],
                avatarUrl: chatDocuments[index]["userImage"],
              ),
              itemCount: chatDocuments.length,
            );
          },
        );
      },
    );
  }
}
