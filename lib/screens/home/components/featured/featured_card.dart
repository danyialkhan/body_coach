import 'package:body_coach/models/data/fitness_app_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FeaturedCard extends StatelessWidget {
  final String imageUrl;
  final String level;
  final String title;
  final String equipment;
  final String category;
  final String duration;
  final List<WorkOutContent> workoutContent;
  final String students;
  final String star;
  final String catId;
  final String userName;
  final String ownerId;
  final String userImg;
  final String desc;

  FeaturedCard(
      {this.title,
      this.imageUrl,
      this.category,
      this.duration,
      this.equipment,
      this.workoutContent,
      this.students,
      this.level,
      this.star,
      this.userName,
      this.ownerId,
      this.userImg,
        this.desc,
      this.catId});

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        bottom: 15,
      ),
      height: mq.height * 0.3,
      width: mq.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        //color: Color(0xFFF1F1F1),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(imageUrl),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.black38
              ),
              child: Text(
                title ?? '',
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
