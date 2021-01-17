import 'package:body_coach/models/category_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel course;
  CategoryCard({this.course});
  @override
  Widget build(BuildContext context) {
    var _mq = MediaQuery.of(context).size;
    return Container(
      width: _mq.width * 0.4,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: course?.imgUrl == null
              ? AssetImage('assets/picture.png')
              : CachedNetworkImageProvider(course?.imgUrl),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 15, top: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.black38
              ),
              child: Text(
                course?.title ?? '',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
