import 'package:body_coach/screens/admin/create_categories/add_videos.dart';
import 'package:flutter/material.dart';

class EditVideo extends StatelessWidget {
  final String uId;
  final String catId;
  final String hr;
  final String min;
  final String sec;
  final String link;
  final String title;
  final String vidId;

  EditVideo(
      {this.vidId,
      this.sec,
      this.min,
      this.link,
      this.hr,
      this.title,
      this.uId,
      this.catId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Video'),
      ),
      body: AddVideoLink(
        title: title,
        uId: uId,
        catId: catId,
        hr: hr,
        link: link,
        min: min,
        sec: sec,
        vidId: vidId,
        updateVideo: true,
      ),
    );
  }
}
