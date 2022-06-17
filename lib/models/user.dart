import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String username, uid, email, photoUrl, bio;
  final List following, followers;

  const UserModel({
    required this.username,
    required this.uid,
    required this.email,
    required this.photoUrl,
    required this.followers,
    required this.following,
    required this.bio
  });

  Map<String, dynamic> toJson() => {
    "username" : username,
    "uid" : uid,
    "email" : email,
    "bio" : bio,
    "photoUrl" : photoUrl,
    "following" : following,
    "followers" : followers
  };

  static UserModel fromSnapshot(DocumentSnapshot snapshot)  {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
        username: data['username'],
        uid: data['uid'],
        email: data['email'],
        photoUrl: data['photoUrl'],
        followers: data['followers'],
        following: data['following'],
        bio: data['bio']
    );
  }
}
