class Subscribers {
  final String id;
  final String subId;
  final String subName;
  final String subscribedName;
  final String subscribedId;
  final String subImgUrl;
  final String subscribedImgUrl;

  Subscribers({
    this.id,
    this.subId,
    this.subName,
    this.subscribedName,
    this.subscribedId,
    this.subImgUrl,
    this.subscribedImgUrl,
  });

  Map<String, dynamic> toJson() => {
    'subName': subName,
    'subId': subId,
    'subscribedName': subscribedName,
    'subscribedId': subscribedId,
    'subImg': subImgUrl,
    'subscribedImg': subscribedImgUrl,
  };

  Subscribers fromJson(Map<String, dynamic> data) => Subscribers(
    id: id,
    subId: data['subId'],
    subName: data['subName'],
    subscribedName: data['subscribedName'],
    subscribedId: data['subscribedId'],
    subImgUrl: data['subImg'],
    subscribedImgUrl: data['subscribedImg'],
  );

}
