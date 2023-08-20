import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final commonFirebaseStorageRepoProvider = Provider((ref) =>
    CommonFirebaseStorageRepo(firebaseStorage: FirebaseStorage.instance));
class CommonFirebaseStorageRepo
{
  final FirebaseStorage firebaseStorage ;

  CommonFirebaseStorageRepo({required this.firebaseStorage});

  Future<String> storeFileToFireStore(String ref ,File file)async
  {
    UploadTask uploadTask = (await firebaseStorage.ref().child(ref).putFile(file)) as UploadTask;

    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;

  }
}