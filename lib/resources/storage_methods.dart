import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // adding image to firebase storage
  Future<String> uploadImageToStorage(String folderName, Uint8List file, bool isPost) async {
    Reference ref = _firebaseStorage.ref().child(folderName).child(_firebaseAuth.currentUser!.uid);
    if (isPost) {
      String uuid = const Uuid().v1();
      ref.child(uuid);
    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
