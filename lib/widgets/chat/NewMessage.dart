import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  // our message state variable
  String _message = "";
  //message controller
  final _controller = new TextEditingController();

  // send message to the cloud firestore and adds the message to the chat collection
  void _sendMessage() async {
    FocusScope.of(context).unfocus();

    //gets current user
    final user = await FirebaseAuth.instance.currentUser();

    //gets current userName before sending the message to the firestore
    final userData = await Firestore.instance.collection("users").document(user.uid).get();

    // adds time stamp field
    Firestore.instance.collection("chat").add({"message": _message, "createdTime": Timestamp.now(), "userId": user.uid, "userName": userData["userName"], 'userImage': userData["avatarUrl"]});
    _controller.clear(); //clears the text editing controller
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: PlatformTextField(
              keyboardType: TextInputType.emailAddress,
              controller: _controller,
              autocorrect: false,
              obscureText: false,
              onChanged: (message) {
                setState(() {
                  _message = message;
                });
              },
              onSubmitted: (value) {
                _sendMessage();
              },
              material: (context, android) => MaterialTextFieldData(
                decoration: InputDecoration(labelText: "Type your message here ... "),
              ),
              cupertino: (_, ios) => CupertinoTextFieldData(
                placeholder: "Type your message here ... ",
              ),
            ),
          ),
          IconButton(
            color: Theme.of(context).accentColor,
            icon: Image.asset("assets/send.png"),
            onPressed: _message.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
