import 'package:flutter/material.dart';
import 'package:instagram_clone_app/utils/colors.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: IconButton(
    //     onPressed: () {},
    //     icon: const Icon(Icons.upload),
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Post to"),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () {},
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage("https://picsum.photos/200/300"),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
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
                         image: NetworkImage("https://picsum.photos/200/300"),
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
