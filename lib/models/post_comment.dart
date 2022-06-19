import 'package:cloud_firestore/cloud_firestore.dart';

class PostCommentModel {
  final String profilePic, name, uid, text, commentId;
  final datePublished;
  const PostCommentModel({
    required this.profilePic,
    required this.uid,
    required this.name,
    required this.text,
    required this.commentId,
    required this.datePublished
  });

  Map<String, dynamic> toJson() => {
    "profilePic" : profilePic,
    "uid" : uid,
    "name" : name,
    "text" : text,
    "commentId" : commentId,
    "datePublished" : datePublished
  };

  static PostCommentModel fromSnapshot(DocumentSnapshot snapshot)  {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return PostCommentModel(
        profilePic: data['profilePic'],
        uid: data['uid'],
        name: data['name'],
        text: data['text'],
        commentId: data['commentId'],
        datePublished: data['datePublished']
    );
  }
}
