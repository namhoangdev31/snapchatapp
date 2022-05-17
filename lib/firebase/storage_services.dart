import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageServices {
  static Future<String> uploadImage(File? imageFileX) async {
    String fileName = Uuid().v1();
    var ref =
        FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');
    var uploadTask = await ref.putFile(imageFileX!);
    String ImageURL = await uploadTask.ref.getDownloadURL();
    return ImageURL;
  }
}
