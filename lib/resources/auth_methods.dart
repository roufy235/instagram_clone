import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // sign up user
  Future<String> signUpUser({
    required String email, required String password,
    required String username, required String bio,
    //required Uint8List file
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty /*|| file != null*/) {
        // register the user
       UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

       String uid = userCredential.user!.uid;
       print(uid);
       // add user to firestore database
        await _firebaseFirestore.collection("users").doc(uid).set({
          'uid' : uid,
          'username' : username,
          'email' : email,
          'bio' : bio,
          'followers' : [],
          'following' : [],
        });
        res = "success";
      } else {
        res = "";
      }
    } catch(err) {
      res = err.toString();
    }
    return res;
  }
}
