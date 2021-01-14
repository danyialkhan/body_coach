import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
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

  Request({
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

  Map<String, dynamic> toJsonReq() => {
    'req-status': reqStatus,
  };

  Request fromJson(Map<String, dynamic> data) => Request(
    id: id,
    subId: data['subId'] ?? null,
    subName: data['subName'] ?? null,
    subscribedName: data['subscribedName'] ?? null,
    subscribedId: data['subscribedId'] ?? null,
    subImgUrl: data['subImg'] ?? null,
    subscribedImgUrl: data['subscribedImg'] ?? null,
    joinedTime: data['joined-time'] ?? null,
    subCat: data['sub-cat'] ?? null,
    reqStatus: data['req-status'] ?? null,
  );
}

enum SubscriptionRequestStatus {
  PENDING,
  ACCEPTED,
  DECLINE,
  NOT_APPLIED,
}