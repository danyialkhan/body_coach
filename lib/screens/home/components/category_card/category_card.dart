import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/shared/constants.dart';
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
          image: course.imgUrl == null
              ? AssetImage('assets/picture.png')
              : NetworkImage(course.imgUrl),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 15, top: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              course.title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "5 Courses",
              style: TextStyle(
                  color: kPrimaryLightColor, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
