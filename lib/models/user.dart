class User {
  final String username, uid, email, photoUrl, bio;
  final List following, followers;

  const User({
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
}
