import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImagePath with ChangeNotifier {
  File _path;

  File get path {
    return _path;
  }

  void setPath(File path) {
    _path = path;
    notifyListeners();
  }

  void clear() {
    _path = null;
    notifyListeners();
  }
}

final picker = ImagePicker();

Future imgFromCamera(BuildContext context) async {
  try {
    var image = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    ImagePath imgPath = Provider.of<ImagePath>(context, listen: false);
    imgPath.setPath(File(image.path));
  } catch (err) {
    print(err);
    return null;
  }
}

Future imgFromGallery(BuildContext context) async {
  try {
    var image = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    print(image.path);

    ImagePath imgPath = Provider.of<ImagePath>(context, listen: false);
    imgPath.setPath(File(image.path));
  } catch (err) {
    print(err);
    return null;
  }
}

Future<void> getImage(BuildContext context) async {
  try {
    var image = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      ImagePath imgPath = Provider.of<ImagePath>(context, listen: false);
      imgPath.setPath(File(image.path));
    }
  } catch (err) {
    print(err);
  }
}

Future<void> showPicker(context) async {
  await showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return SafeArea(
        child: Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Photo Library'),
                  onTap: () async {
                    await imgFromGallery(context);
                    Navigator.of(context).pop();
                  }),
              new ListTile(
                leading: new Icon(Icons.photo_camera),
                title: new Text('Camera'),
                onTap: () async {
                  await imgFromCamera(context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
