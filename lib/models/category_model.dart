import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String ownerId;
  final String catId;
  final String title;
  final String imgUrl;
  final int subType;
  final String price;
  final Timestamp createdTime;
  final List<dynamic> videos;
  final bool isFeatured;

  CategoryModel({
    this.ownerId,
    this.catId,
    this.title,
    this.imgUrl,
    this.price,
    this.subType,
    this.createdTime,
    this.videos,
    this.isFeatured,
  });

  Map<String, dynamic> toJson() => {
        'ownerId': ownerId,
        'title': title,
        'imgUrl': imgUrl,
        'subType': subType,
        'price': price,
        'createdTime': createdTime,
    'isFeatured': isFeatured,
      };

  CategoryModel fromJson(Map<String, dynamic> data) => CategoryModel(
        imgUrl: data['imgUrl'],
        title: data['title'],
        ownerId: data['ownerId'],
        price: data['price'],
        subType: data['subType'],
        createdTime: data['createdTime'],
        isFeatured: data['isFeatured'],
        catId: catId,
      );
}

class Video {
  final String link;
  final String title;
  final String hr;
  final String min;
  final String sec;
  final String catId;
  final String id;

  Video({
    this.title,
    this.hr,
    this.link,
    this.min,
    this.sec,
    this.catId,
    this.id,
  });

  Map<String, dynamic> toJson() => {
        'link': link,
        'title': title,
        'hr': hr,
        'min': min,
        'sec': sec,
        'catId': catId,
      };

  Video fromJson(Map<String, dynamic> data) => Video(
        sec: data['sec'],
        min: data['min'],
        link: data['link'],
        hr: data['hr'],
        title: data['title'],
        catId: data['catId'],
        id: id,
      );
}

class AllVideos with ChangeNotifier {
  List<Video> _allVideos = [];

  List<Video> get videos {
    List<Video> copied = [];
    _allVideos.forEach((element) {
      copied.add(element);
    });
    return copied;
  }

  void setVideo(Video vid) {
    _allVideos.add(vid);
    notifyListeners();
  }

  void setVideoList(List<Video> videos) {
    _allVideos = videos;
    notifyListeners();
  }

  void clear() {
    _allVideos.clear();
    notifyListeners();
  }
}
