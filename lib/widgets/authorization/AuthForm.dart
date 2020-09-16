import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import "dart:io";

import '../ImagePickerWidget.dart';

//manages the initial authorization form
class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext buildContext,
    File imageFile,
  ) submitFormData; //this is a callback we get from AuthPage

  final isLoading;

  AuthForm({
    @required this.submitFormData,
    @required this.isLoading,
  });

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //global form key
  //followings are used to store value received from textfields' onsaved action
  String _userEmail;
  String _username;
  String _userPassword;
  File _userImageFile;

  // textfield controllers
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  //helps us switch between login and sign up textfields display
  bool _isLogin = true;
  bool _isValid = false;

  // disposes texteditingCOntrollers
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
  }

  // builds all the textfields for the authform
  Widget _buildTextField(BuildContext context, String label, TextEditingController textEditingController, bool isObscured) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: PlatformTextField(
        keyboardType: TextInputType.emailAddress,
        controller: textEditingController,
        key: ValueKey(label),
        autocorrect: false,
        obscureText: isObscured,
        maxLines: 1,
        material: (context, android) => MaterialTextFieldData(
          decoration: InputDecoration(labelText: label),
        ),
        cupertino: (_, ios) => CupertinoTextFieldData(
          placeholder: label,
        ),
      ),
    );
  }

// checks the validity of each textfields
  bool _validateFields() {
    _isValid = true;
    // provide values to the state fields
    _userEmail = _emailController.text;
    _userPassword = _passwordController.text;
    _username = _userNameController.text;
    if (_userEmail.isEmpty || !_userEmail.contains("@")) {
      print("invalid email");
      _isValid = false;
    }
    if (_userPassword.isEmpty || _userPassword.length <= 6) {
      print("invalid password");
      _isValid = false;
    }
    if (_isLogin) {
      return _isValid;
    } else if (!_isLogin && _username.isEmpty) {
      print("invalid userName");
      _isValid = false;
    }
    // if valid, then saved the form data and we have user image file
    else if (_userImageFile == null && !_isLogin) {
      print("please pick an image");
      _isValid = false;
    }
    return _isValid;
  }

// submits form data to the callback from the auth page
  void _submitForm(BuildContext context) {
    bool isFormValid = _validateFields();
    print(isFormValid);
    //closes the soft keyboard after formstate is saved
    FocusScope.of(context).unfocus();

    if (isFormValid) {
      //we use submitFormData callback to send data back to the AuthPage
      widget.submitFormData(
        _userEmail,
        _userPassword,
        _username,
        _isLogin,
        context,
        _userImageFile,
      );
    }
  }

// receives image from Imagepicker
  void _imagePicker(File image) {
    _userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                if (!_isLogin)
                  // Image avatar
                  ImagePickerWidget(
                    imagePickerFunction: _imagePicker,
                  ),
                // email address
                if (!_isLogin) _buildTextField(context, "user name", _userNameController, false),
                _buildTextField(context, "email", _emailController, false),
                _buildTextField(context, "password", _passwordController, true),

                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  PlatformButton(
                    child: Text(_isLogin ? "Log In" : "Sign Up"),
                    onPressed: () {
                      return _submitForm(context);
                    }, //submits the form state
                  ),
                PlatformButton(
                    onPressed: () {
                      // toggles the _isLogin bool value
                      setState(() {
                        _isLogin = !_isLogin; //this has affect on UI, so setState has to be called
                      });
                    },
                    child: Text(_isLogin ? "Create New Account" : "I already have an account"))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
