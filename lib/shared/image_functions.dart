import 'dart:io';
import 'dart:math' as Math;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

class ImageFunctions {
  static final FirebaseStorage _storageRef =
      FirebaseStorage(storageBucket: "gs://bodycoach-702a0.appspot.com");

  static Future<File> _compressImage(File imageFile) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000);

    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    Im.Image smallerImage = Im.copyResize(image,
        width: 2160); // choose the size here, it will maintain aspect ratio

    File compressedImage = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(smallerImage, quality: 100));


    return compressedImage;
  }

  static Future<String> uploadSentImage(File file, String _path) async {
    String photoId = Uuid().v4();
    _path += '/$photoId';
    try {
      // compress image
      File compressedFile = await _compressImage(file);
      // get storage reference
      var storageRef = _storageRef.ref().child(_path);

      // upload task
      var uploadTask = storageRef.putFile(compressedFile);

      // complete task
      var completeTask = await uploadTask.onComplete;
      String downloadUrl = await completeTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw e;
    }
  }
}
