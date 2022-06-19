import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String username, uid, description,
      postId, postUrl, profileImage;
  final List likes;
  final DateTime datePublished;

  const PostModel({
    required this.username,
    required this.uid,
    required this.likes,
    required this.description,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profileImage
  });

  Map<String, dynamic> toJson() => {
    "username" : username,
    "uid" : uid,
    "likes" : likes,
    "description" : description,
    "postId" : postId,
    "datePublished" : datePublished,
    "profileImage" : profileImage,
    "postUrl" : postUrl
  };

  static PostModel fromSnapshot(DocumentSnapshot snapshot)  {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return PostModel(
        username: data['username'],
        likes: data['likes'],
        uid: data['uid'],
        description: data['description'],
        datePublished: data['datePublished'],
        profileImage: data['profileImage'],
        postId: data['postId'],
        postUrl: data['postUrl']
    );
  }
}
