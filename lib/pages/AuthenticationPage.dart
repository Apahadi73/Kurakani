import 'dart:io';

import 'package:Kura/widgets/authorization/AuthForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import "package:firebase_storage/firebase_storage.dart";
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //an instance of firebase auth
  final _firebaseAuth = FirebaseAuth.instance;

  // text editing controllers
  final _emailController = new TextEditingController();
  final _passwordController = TextEditingController();

  //holds future returned by firebase sign in attempt
  AuthResult _authResult;

  //bool for managing loading spinner
  bool _isLoading = false;

  //receives form data from AuthForm widget and authenticates the data using Firebase Authentication
  void _submitAuthform(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext authFormContext,
    File imageFile,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        _authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
      } else {
        _authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim());

        // perform image upload here
        final imageRef = FirebaseStorage.instance.ref().child('userImages').child(_authResult.user.uid + '.jpg');
        await imageRef.putFile(imageFile).onComplete;
        final url = await imageRef.getDownloadURL();

        // save usernames after the user signs in
        await Firestore.instance.collection("users").document(_authResult.user.uid).setData({"userName": username, "email": email, 'avatarUrl': url});
      }
    } on PlatformException catch (error) {
      //platformexception is when invalid email/password is submitted
      String message = "An error occured, please check your credentials.";

      if (error.message != null) {
        message = error.message;
      }

      Scaffold.of(authFormContext).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 3),
      ));

      setState(() {
        _isLoading = false;
      });
    }
    //following errors are for the developers
    catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
    // disposing controllers
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        submitFormData: _submitAuthform,
        isLoading: _isLoading,
      ),
    );
  }
}
