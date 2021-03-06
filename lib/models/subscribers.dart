import 'package:cloud_firestore/cloud_firestore.dart';

class Subscribers {
  final String id;
  final String subId;
  final String subName;
  final String subscribedName;
  final String subscribedId;
  final String subImgUrl;
  final String subscribedImgUrl;
  final Timestamp joinedTime;
  final String subCat;
  final int reqStatus;

  Subscribers({
    this.id,
    this.subId,
    this.subName,
    this.subscribedName,
    this.subscribedId,
    this.subImgUrl,
    this.subscribedImgUrl,
    this.joinedTime,
    this.subCat,
    this.reqStatus,
  });

  Map<String, dynamic> toJson() => {
    'subName': subName,
    'subId': subId,
    'subscribedName': subscribedName,
    'subscribedId': subscribedId,
    'subImg': subImgUrl,
    'subscribedImg': subscribedImgUrl,
    'joined-time': joinedTime,
    'sub-cat': subCat,
    'req-status': reqStatus,
  };

  Subscribers fromJson(Map<String, dynamic> data) => Subscribers(
    id: id,
    subId: data['subId'],
    subName: data['subName'],
    subscribedName: data['subscribedName'],
    subscribedId: data['subscribedId'],
    subImgUrl: data['subImg'],
    subscribedImgUrl: data['subscribedImg'],
    joinedTime: data['joined-time'],
    subCat: data['sub-cat'],
    reqStatus: data['req-status'],
  );
}
