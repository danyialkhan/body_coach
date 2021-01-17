import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/models/subscribers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final String uId;
  final String catId;
  final vidId;

  CategoryService({
    this.catId,
    this.uId,
    this.vidId,
  });

  CollectionReference _catRef = Firestore.instance.collection('Categories');

  Future createCategory({
    String title,
    int type,
    String price,
    String ownerId,
    String imgUrl,
    bool featured,
    String desc,
  }) async {
    try {
      DocumentReference doc = await _catRef.add(CategoryModel(
        subType: type,
        price: price,
        ownerId: uId,
        title: title,
        imgUrl: imgUrl,
        isFeatured: featured,
        description: desc,
        createdTime: Timestamp.now(),
      ).toJson());
      return doc.documentID;
    } catch (e) {
      throw e;
    }
  }

  Future<List<dynamic>> updateStudentToList({String sId}) async {
    try {
      CategoryModel model = await getCategory();

      if (model?.students != null && model.students.isNotEmpty) {
        model.students.add(sId);
      } else {
        model = CategoryModel(students: [sId], title: model.title);
      }

      _catRef.document(catId).updateData(model.toJsonStu());
      return model?.students;
    } catch (e) {
      print('UPDATE STUDENT LIST ERR: $e');
      return null;
    }
  }

  Future setStudentToList({String sId}) async {
    try {
      CategoryModel model = await getCategory();

      if (model != null) {
        if (model.students != null || model.students.isNotEmpty) {
          model.students.add(sId);
        } else {
          model = CategoryModel(students: [sId]);
        }
      }

      _catRef.document(catId).setData(model.toJsonStu());
    } catch (e) {
      print(e);
    }
  }

  Future<CategoryModel> getCategory() async {
    try {
      QuerySnapshot snapshot = await _catRef.getDocuments();

      DocumentSnapshot documentSnapshot = snapshot.documents
          .firstWhere((element) => element.documentID == catId);
      if (documentSnapshot == null) return null;
      return CategoryModel(catId: documentSnapshot.documentID)
          .fromJson(documentSnapshot.data);
    } catch (e) {
      print('GET CAT ERROR: $e');
      return null;
    }
  }

  Future<List<Video>> getPreviewVideos() async {
    try {
      QuerySnapshot snapshot = await _catRef
          .document(catId)
          .collection('videos')
          .where('is-preview', isEqualTo: true)
          .getDocuments();

      return snapshot.documents
          .map((e) => Video(id: e.documentID).fromJson(e.data))
          .toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Video>> getAllVideos() async {
    try {
      QuerySnapshot snapshot =
          await _catRef.document(catId).collection('videos').getDocuments();

      return snapshot.documents
          .map((e) => Video(id: e.documentID).fromJson(e.data))
          .toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future deleteCategory() async {
    try {
      await _catRef.document(catId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future updateCategory({
    String title,
    int type,
    String price,
    String ownerId,
    String imgUrl,
    bool featured,
    String desc,
    Timestamp creationTIme,
  }) async {
    try {
      await _catRef.document(catId).updateData(CategoryModel(
            subType: type,
            price: price,
            ownerId: uId,
            title: title,
            imgUrl: imgUrl,
            isFeatured: featured,
            description: desc,
            createdTime: creationTIme,
          ).toJson());
    } catch (e) {
      throw e;
    }
  }

  Future addVideos({
    String title,
    String hr,
    String min,
    String sec,
    String link,
    bool isPreview,
  }) async {
    try {
      await _catRef.document(catId).collection('videos').add(Video(
            catId: catId,
            title: title,
            hr: hr,
            link: link,
            min: min,
            sec: sec,
            isPreview: isPreview,
          ).toJson());
    } catch (e) {
      print(e);
    }
  }

  Future updateVideos({
    String title,
    String hr,
    String min,
    String sec,
    String link,
    bool isPreview,
  }) async {
    try {
      await _catRef
          .document(catId)
          .collection('videos')
          .document(vidId)
          .updateData(Video(
            catId: catId,
            title: title,
            hr: hr,
            link: link,
            min: min,
            sec: sec,
            isPreview: isPreview,
          ).toJson());
    } catch (e) {
      throw e;
    }
  }

  Future deleteVideo() async {
    try {
      await _catRef
          .document(uId)
          .collection('Courses')
          .document(catId)
          .collection('videos')
          .document(vidId)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List<dynamic>> addSubscriber({
    String name,
    String subscribed,
    String subImg,
    String subscribedImg,
  }) async {
    try {
      await _catRef
          .document(catId)
          .collection('subscribers')
          .document(uId)
          .setData(Subscribers(
            subId: uId,
            subName: name,
            subscribedName: subscribed,
            subscribedId: catId,
            subImgUrl: subImg,
            subscribedImgUrl: subscribedImg,
            joinedTime: Timestamp.now(),
          ).toJson());

      return await updateStudentToList(sId: uId);
    } catch (e) {
      print('ADD SUB ERROR: $e');
      return null;
    }
  }

  Future removeSubscriber() async {
    CategoryModel model = await getCategory();

    if (model != null) {
      if (model.students != null) {
        if (model.students.isNotEmpty) {
          model.students.remove(uId);
        }
      }
    }

    await _catRef.document(catId).updateData(model.toJsonStu());

    try {
      await _catRef
          .document(catId)
          .collection('subscribers')
          .document(uId)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  List<Subscribers> _getSubscribers(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((e) => Subscribers(id: e.documentID).fromJson(e.data))
        .toList();
  }

  Stream<List<Subscribers>> getSubscribers() {
    return _catRef
        .document(catId)
        .collection('subscribers')
        .snapshots()
        .map(_getSubscribers);
  }

  List<CategoryModel> _modelsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((e) => CategoryModel(catId: e.documentID).fromJson(e.data))
        .toList();
  }

  Stream<List<CategoryModel>> categoriesStream() {
    return _catRef
        .where('ownerId', isEqualTo: uId)
        .snapshots()
        .map(_modelsFromSnapshot);
  }

  int _getCount(DocumentSnapshot snapshot) {
    return CategoryModel(
          students: snapshot.data['students'],
        ).students?.length ??
        0;
  }

  Stream<int> studentCount() {
    return _catRef.document(catId).snapshots().map(_getCount);
  }

  Stream<List<CategoryModel>> topFiveCategoriesStream() {
    return _catRef.limit(5).snapshots().map(_modelsFromSnapshot);
  }

  Stream<List<CategoryModel>> allCategoriesStream() {
    return _catRef.limit(5).snapshots().map(_modelsFromSnapshot);
  }

  Stream<List<CategoryModel>> topFiveFeaturedCategoriesStream() {
    return _catRef
        .where('isFeatured', isEqualTo: true)
        .limit(5)
        .snapshots()
        .map(_modelsFromSnapshot);
  }

  Stream<List<CategoryModel>> allFeaturedCategoriesStream() {
    return _catRef
        .where('isFeatured', isEqualTo: true)
        .limit(5)
        .snapshots()
        .map(_modelsFromSnapshot);
  }

  List<Video> _videosFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((e) => Video(id: e.documentID).fromJson(e.data))
        .toList();
  }

  Stream<List<Video>> previewVideosStream() {
    return _catRef
        .document(catId)
        .collection('videos')
        .where('is-preview', isEqualTo: true)
        .snapshots()
        .map(_videosFromSnapshot);
  }

  Stream<List<Video>> allVideosStream() {
    return _catRef
        .document(catId)
        .collection('videos')
        .snapshots()
        .map(_videosFromSnapshot);
  }
}
