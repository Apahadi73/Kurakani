import 'package:Kura/widgets/chat/Messages.dart';
import 'package:Kura/widgets/chat/NewMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//conversation page for our app
class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    // adding firebase cloud function service that helps us automate the cloud message push functionality
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (message) {
        print(message);
        return;
      },
      onLaunch: (message) {
        print(message);
        return;
      },
      onResume: (message) {
        print(message);
        return;
      },
    );
    _firebaseMessaging.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    // connection instance of our collection
    // final ourCollection = Firestore.instance.collection("chatsCollection/njL8D0tAvHCm3N1rJKXn/messages");

    return Scaffold(
      appBar: AppBar(
        title: Text("KuraKani"),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Log Out"),
                    ],
                  ),
                ),
                value: "logOut",
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == "logOut") {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),

      //our messages
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
