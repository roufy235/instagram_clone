import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone_app/models/post.dart';
import 'package:instagram_clone_app/resources/storage_methods.dart';
import 'package:instagram_clone_app/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(Uint8List file, String description, String uid, String username, String profileImage) async {
    String res = 'some error occurred';
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage(postCollectionName, file, true);
      String postId = const Uuid().v1();
      PostModel post = PostModel(
          username: username, uid: uid,
          description: description,
          postId: postId, datePublished: DateTime.now(),
          postUrl: photoUrl, profileImage: profileImage,
        likes: []
      );
      _firebaseFirestore.collection(postCollectionName).doc(postId).set(post.toJson());
      return 'success';
    } catch(err) {
      res = err.toString();
    }
    return res;
  }


  Future<void> likePosts(String postId, String uid, List likes) async {
    try {
      if(likes.contains(uid)) {
        await _firebaseFirestore.collection(postCollectionName).doc(postId).update({
          'likes' : FieldValue.arrayRemove([uid])
        });
      } else {
        await _firebaseFirestore.collection(postCollectionName).doc(postId).update({
          'likes' : FieldValue.arrayUnion([uid])
        });
      }
    } catch(e) {
      print(e.toString());
    }
  }
}
