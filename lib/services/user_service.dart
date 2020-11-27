import 'package:body_coach/models/subscribers.dart';
import 'package:body_coach/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final String uId;
  UserService({this.uId});

  CollectionReference _usersRef = Firestore.instance.collection("Users");

  // Save user Data in FireStore
  Future updateUser({
    String name,
    String email,
    String mobileNumber,
    String address,
    String country,
    String city,
    String imgUrl,
    DateTime dob,
    String isoCode,
    int gender,
  }) async {
    try {
      if (_usersRef == null) return;
      await _usersRef.document(uId).updateData(UserProfile(
              uId: uId,
              name: name,
              mobileNumber: mobileNumber,
              imgUrl: imgUrl,
              email: email,
              dob: dob,
              country: country,
              city: city,
              address: address,
              isoCode: isoCode,
              gender: gender)
          .toJson());
    } catch (e) {
      throw e;
    }
  }

  // Save user Data in FireStore
  Future saveUser({
    String name,
    String email,
    String mobileNumber,
    String address,
    String country,
    String city,
    String imgUrl,
    DateTime dob,
    String isoCode,
    int gender,
  }) async {
    try {
      if (_usersRef == null) return;
      await _usersRef.document(uId).setData(UserProfile(
              uId: uId,
              name: name,
              mobileNumber: mobileNumber,
              imgUrl: imgUrl,
              dob: dob,
              country: country,
              city: city,
              address: address,
              isoCode: isoCode,
              gender: gender)
          .toJson());
    } catch (e) {
      throw e;
    }
  }

  Future updateUserProfileImageLink({
    String imgUrl,
  }) async {
    try {
      if (_usersRef == null) return;
      await _usersRef.document(uId).updateData(UserProfile(
            uId: uId,
            imgUrl: imgUrl,
          ).toJsonImg());
    } catch (e) {
      throw e;
    }
  }

  Future addSubscribedCategory({
    String name,
    String id,
    String subscribed,
    String subImg,
    String subscribedImg,
  }) async {
    try {
      await _usersRef
          .document(uId)
          .collection('subscriptions')
          .document(id)
          .setData(Subscribers(
            subName: name,
            subId: id,
            subscribedName: subscribed,
            subscribedId: uId,
            subImgUrl: subImg,
            subscribedImgUrl: subscribedImg,
          ).toJson());
    } catch (e) {
      print(e);
    }
  }

  Future addUserSubscriptions({
    String name,
    String id,
    String subscribed,
    String subImg,
    String subscribedImg,
  }) async {
    try {
      await _usersRef
          .document(uId)
          .collection('user_subscriptions')
          .document(id)
          .setData(Subscribers(
            subName: name,
            subId: id,
            subscribedName: subscribed,
            subscribedId: uId,
            subImgUrl: subImg,
            subscribedImgUrl: subscribedImg,
          ).toJson());
    } catch (e) {
      print(e);
    }
  }

  Future removeUserSubscriptions({String id}) async {
    try {
      await _usersRef
          .document(uId)
          .collection('user_subscriptions')
          .document(id)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  Future removeSubscribedCategory({String id}) async {
    try {
      await _usersRef
          .document(uId)
          .collection('subscriptions')
          .document(id)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  bool _isSubscribed(DocumentSnapshot snapshot) {
    return snapshot.data != null;
  }

  Stream<bool> checkSubscribed({String catId}) {
    return _usersRef
        .document(uId)
        .collection('subscriptions')
        .document(catId)
        .snapshots()
        .map(_isSubscribed);
  }

  List<Subscribers> _getSubscriptions(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((e) => Subscribers(id: e.documentID).fromJson(e.data)).toList();
  }

  Stream<List<Subscribers>> getSubscriptions({String catId}) {
    return _usersRef
        .document(uId)
        .collection('subscriptions')
        .snapshots()
        .map(_getSubscriptions);
  }

  Stream<List<Subscribers>> getALlSubscribers({String catId}) {
    return _usersRef
        .document(uId)
        .collection('user_subscriptions')
        .snapshots()
        .map(_getSubscriptions);
  }

  // Ger User Data from fireStore
  Future<UserProfile> getUser() async {
    try {
      if (_usersRef == null) return null;
      DocumentSnapshot documentSnapshot = await _usersRef.document(uId).get();
      return UserProfile(uId: documentSnapshot.documentID)
          .fromJson(documentSnapshot.data);
    } catch (e) {
      throw e;
    }
  }

  // get user profile stream
  UserProfile _getDocumentStream(DocumentSnapshot snapshot) {
    return UserProfile(uId: snapshot.documentID).fromJson(snapshot.data);
  }

  Stream<UserProfile> getUserStream() {
    if (_usersRef == null) return null;
    return this._usersRef.document(uId).snapshots().map(_getDocumentStream);
  }
}
