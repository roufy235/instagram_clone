import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_app/models/user.dart';
import 'package:instagram_clone_app/providers/user_provider.dart';
import 'package:instagram_clone_app/resources/firestore_methods.dart';
import 'package:instagram_clone_app/utils/colors.dart';
import 'package:instagram_clone_app/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _selectedImage;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void _selectImage(BuildContext context) async {
    return showDialog(context: context, builder: (context) {
      return SimpleDialog(
        title: const Text('Create a post'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Take a photo'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.camera);
              setState(() {
                _selectedImage = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Choose from gallery'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.gallery);
              setState(() {
                _selectedImage = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    });
  }

  void _postImage(String uid, String username, String profileImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _selectedImage!,
          _descriptionController.text,
          uid,
          username,
          profileImage
      );

      setState(() {
        _isLoading = false;
      });
      if (res == 'success') {
        showSnackBar(context, "Posted!");
        _clearSelectedImage();
      } else {
        showSnackBar(context, res);
      }
    } catch(err) {
      showSnackBar(context, err.toString());
    }
  }

  void _clearSelectedImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {

    final UserModel userModel = Provider.of<UserProvider>(context).getUser;

    return _selectedImage == null ? Center(
      child: IconButton(
        onPressed: () => _selectImage(context),
        icon: const Icon(Icons.upload),
      ),
    ) : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          onPressed: _clearSelectedImage,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Post to"),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () => _postImage(
                userModel.uid, userModel.username, userModel.photoUrl
              ),
              child: const Text(
                  'Post',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              )
          )
        ],
      ),
      body: Column(
        children: [
          _isLoading ? const LinearProgressIndicator()
              : const Padding(padding: EdgeInsets.only(top: 0)),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(userModel.photoUrl),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: "write a caption...",
                    border: InputBorder.none
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487/451,
                  child: Container(
                     decoration: BoxDecoration(
                       image: DecorationImage(
                         image: MemoryImage(_selectedImage!),
                         fit: BoxFit.fill,
                         alignment: FractionalOffset.topCenter
                       ),
                     ),
                  ),
                ),
              ),
              const Divider()
            ],
          )
        ],
      ),
    );
  }
}
