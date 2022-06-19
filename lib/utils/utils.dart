import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


const String userCollectionName = 'users';
const String postCollectionName = 'posts';

pickImage(ImageSource imageSource) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: imageSource);
  if (file != null) {
    return await file.readAsBytes();
  }
  print("No image selected");
}

showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content))
  );
}
