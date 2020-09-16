import 'dart:io';

import 'package:flutter/material.dart';
import "package:image_picker/image_picker.dart";

//picks images from the user and builds image avatar for the user
class ImagePickerWidget extends StatefulWidget {
  final void Function(File pickedImage) imagePickerFunction; //received from authform
  ImagePickerWidget({@required this.imagePickerFunction});
  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePickerWidget> {
  File _image;
  final picker = ImagePicker();

// gets image
  Future getImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 150,
    );

    setState(() {
      _image = File(pickedFile.path);
    });

    widget.imagePickerFunction(_image); //callback to the authform widget
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: _image != null ? FileImage(_image) : null,
          radius: 45,
        ),
        FlatButton.icon(
          onPressed: getImage,
          icon: Icon(Icons.image),
          label: Text("Add an image avatar"),
        ),
      ],
    );
  }
}
