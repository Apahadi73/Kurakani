import 'package:Kura/pages/AuthenticationPage.dart';
import 'package:Kura/pages/ChatPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.blue,
          accentColor: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.blue,
              textTheme: ButtonTextTheme.primary, //makes sure that we have the contrast color
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, userSnapShots) {
          if (userSnapShots.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          //navigates to the chats page if the user is logged in
          if (userSnapShots.hasData) {
            return ChatPage();
          }
          return AuthPage();
        },
      ),
    );
  }
}
