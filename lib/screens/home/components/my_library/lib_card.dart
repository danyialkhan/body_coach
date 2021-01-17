import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/screens/home/views/workout_view.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';

class LibCard extends StatelessWidget {
  final CategoryModel categoryModel;
  final String userName;
  final String imgUrl;
  LibCard({
    this.categoryModel,
    this.imgUrl,
    this.userName,
  });
  @override
  Widget build(BuildContext context) {
    var _mq = MediaQuery.of(context).size;
    return GFListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => WorkOutView(
              title: categoryModel.title,
              imageUrl: categoryModel.imgUrl,
              catId: categoryModel.catId,
              ownerId: categoryModel.ownerId,
              userName: userName,
              userImage: imgUrl,
              desc: categoryModel.description,
            ),
          ),
        );
      },
      titleText: categoryModel.title,
      subtitle: Text(categoryModel.description),
      color: whiteShad,
      avatar: GFImageOverlay(
        width: _mq.width * 0.2,
        height: _mq.width * 0.2,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
        boxFit: BoxFit.fill,
        image: categoryModel.imgUrl == null
            ? AssetImage('assets/picture.png')
            : CachedNetworkImageProvider(categoryModel.imgUrl),
      ),
    );
  }
}
