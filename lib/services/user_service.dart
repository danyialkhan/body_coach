import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/models/subscribers.dart';
import 'package:body_coach/models/user_profile.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final String uId;
  UserService({this.uId});

  CollectionReference _usersRef = Firestore.instance.collection("Users");

  String _myStudents = "my_students";
  String _myCourses = "my_courses";

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
              email: email,
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

  Future sendRequest({
    String name,
    String id,
    String subscribed,
    String subImg,
    String subscribedImg,
    String catId,
  }) async {
    try {} catch (e) {
      print('SEND REQ ERR: $e');
    }
  }

  Future addSubscribedCategory({
    String name,
    String id,
    String subscribed,
    String subImg,
    String subscribedImg,
    String catId,
  }) async {
    try {
      await _usersRef
          .document(uId)
          .collection(_myCourses)
          .document(id)
          .setData(Subscribers(
            subName: name,
            subId: id,
            subscribedName: subscribed,
            subscribedId: uId,
            subImgUrl: subImg,
            subscribedImgUrl: subscribedImg,
            joinedTime: Timestamp.now(),
            subCat: catId,
          ).toJson());
    } catch (e) {
      print(e);
    }
  }

  Future addMyStudent({
    String name,
    String id,
    String subscribed,
    String subImg,
    String subscribedImg,
    String catId,
    String catName,
    List<dynamic> students,
  }) async {
    try {
      await _usersRef
          .document(uId)
          .collection(_myStudents)
          .document(catId)
          .collection('students')
          .document(id)
          .setData(Subscribers(
            subName: name,
            subId: id,
            subscribedName: subscribed,
            subscribedId: uId,
            subImgUrl: subImg,
            subscribedImgUrl: subscribedImg,
            joinedTime: Timestamp.now(),
            subCat: catId,
          ).toJson());

      await _usersRef
          .document(uId)
          .collection(_myStudents)
          .document(catId)
          .collection('students')
          .document(id)
          .setData(
              CategoryModel(students: students, title: catName).toJsonStu());
    } catch (e) {
      print(e);
    }
  }

  Future removeMyStudent({String id, String catId}) async {
    try {
      await _usersRef
          .document(uId)
          .collection(_myStudents)
          .document(catId)
          .collection('students')
          .document(id)
          .delete();

      CategoryModel model = await CategoryService(catId: catId).getCategory();

      await _usersRef
          .document(uId)
          .collection(_myStudents)
          .document(catId)
          .setData(
            CategoryModel(
              students: model.students,
              title: model.title,
            ).toJsonStu(),
          );
    } catch (e) {
      print(e);
    }
  }

  Future removeSubscribedCategory({String id}) async {
    try {
      await _usersRef
          .document(uId)
          .collection(_myCourses)
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
        .collection(_myCourses)
        .document(catId)
        .snapshots()
        .map(_isSubscribed);
  }

  List<Subscribers> _getSubscriptions(QuerySnapshot snapshot) {
    print('Length: ${snapshot.documents.length}');
    return snapshot.documents
        .map((e) => Subscribers(id: e.documentID).fromJson(e.data))
        .toList();
  }

  Stream<List<Subscribers>> getSubscriptions({String catId}) {
    return _usersRef
        .document(uId)
        .collection(_myCourses)
        .snapshots()
        .map(_getSubscriptions);
  }

  Stream<List<Subscribers>> getAllStudents({String catId}) {
    return _usersRef
        .document(uId)
        .collection(_myStudents)
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
    return _usersRef.document(uId).snapshots().map(_getDocumentStream);
  }

  List<Subscribers> _librariesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((e) => Subscribers().fromJson(e.data))
        .toList();
  }

  Stream<List<Subscribers>> userLibraryStream() {
    return _usersRef
        .document(uId)
        .collection('my_courses')
        .limit(5)
        .snapshots()
        .map(_librariesFromSnapshot);
  }

  Stream<List<Subscribers>> userAllLibraryStream() {
    return _usersRef
        .document(uId)
        .collection('my_courses')
        .snapshots()
        .map(_librariesFromSnapshot);
  }
}
