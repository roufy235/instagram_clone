import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone_app/models/user.dart';
import 'package:instagram_clone_app/resources/storage_methods.dart';
import 'package:instagram_clone_app/utils/utils.dart';

class AuthMethods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;


  // get user data
  Future<UserModel> getUserDetails() async {
    User currentUser = _firebaseAuth.currentUser!;
    DocumentSnapshot userDetails =  await _firebaseFirestore.collection(userCollectionName).doc(currentUser.uid).get();
    return UserModel.fromSnapshot(userDetails);
  }


  // sign in
  Future<String> signInUser({required String email, required String password}) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential userCredential = await _firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password);
        String uid = userCredential.user!.uid;
        res = "success";
      } else {
        res = "All fields are required";
      }
    } on FirebaseAuthException catch(err) {
      if (err.code == "invalid-email") {
        res = "Invalid email address";
      } else if (err.code == "weak-password") {
        res = "Your password should be at least 6 characters";
      } else if (err.code == "wrong-password") {
        res = "Your password is incorrect";
      } else if (err.code == "user-not-found") {
        res = "Account not available. Check your email and password";
      } else {
        res = err.code;
      }
    } catch(err) {
      res = err.toString();
    }

    return res;
  }

  // sign up user
  Future<String> signUpUser({
    required String email, required String password,
    required String username, required String bio,
    required Uint8List? file
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty ||
          bio.isNotEmpty || file != null) {
        // register the user
        UserCredential userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        String uid = userCredential.user!.uid;
        print(uid);
        String photoUrl = await StorageMethods().uploadImageToStorage(
            "profilePics", file!, false
        );

        UserModel user = UserModel(
            username: username,
            uid: uid,
            email: email,
            photoUrl: photoUrl,
            followers: [],
            following: [],
            bio: bio
        );
        // add user to firestore database
        await _firebaseFirestore.collection(userCollectionName).doc(uid).set(user.toJson());
        res = "success";
      } else {
        res = "All fields are required";
      }
    } on FirebaseAuthException catch(err) {
      if (err.code == "invalid-email") {
        res = "Invalid email address";
      } else if (err.code == "weak-password") {
        res = "Your password should be at least 6 characters";
      } else if (err.code == "email-already-in-use") {
        res = "Email already exists";
      } else {
        res = err.code;
      }
    } catch(err) {
      res = err.toString();
    }
    return res;
  }
}
