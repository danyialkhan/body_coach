import 'dart:io';

import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';

class ImageSelector extends StatelessWidget {
  final Function getImage;
  final File image;
  final bool isLink;
  final String imgLink;

  ImageSelector({this.getImage, this.image, this.isLink, this.imgLink});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => getImage(),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width * 0.15),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[400],
          ),
          child: (image == null && !isLink)
              ? Icon(
                  Icons.add,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width * 0.08,
                )
              : (isLink
                  ? Image.network(imgLink ?? pEmptyImage)
                  : Image.file(
                      image,
                      width: 300,
                      height: 300,
                    )),
        ),
      ),
    );
  }
}
