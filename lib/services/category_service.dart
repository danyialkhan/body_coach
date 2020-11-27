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
  }) async {
    try {
      DocumentReference doc = await _catRef.add(CategoryModel(
        subType: type,
        price: price,
        ownerId: uId,
        title: title,
        imgUrl: imgUrl,
        isFeatured: featured,
        createdTime: Timestamp.now(),
      ).toJson());
      return doc.documentID;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Video>> getVideos() async {
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
  }) async {
    try {
      await _catRef.document(catId).updateData(CategoryModel(
            subType: type,
            price: price,
            ownerId: uId,
            title: title,
            imgUrl: imgUrl,
            isFeatured: featured,
            createdTime: Timestamp.now(),
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
  }) async {
    try {
      await _catRef.document(catId).collection('videos').add(Video(
            catId: catId,
            title: title,
            hr: hr,
            link: link,
            min: min,
            sec: sec,
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

  Future addSubscriber({
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
          ).toJson());
    } catch (e) {
      print(e);
    }
  }

  Future removeSubscriber() async {
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
        .map((e) => Subscribers(id: e.documentID).fromJson(e.data)).toList();
  }

  Stream<List<Subscribers>> getSubscribers() {
    return _catRef
        .document(catId)
        .collection('subscribers')
        .snapshots()
        .map(_getSubscribers);
  }

  List<CategoryModel> _modelsFromSnapshot(QuerySnapshot snapshot) {
    print(snapshot.documents.length);
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

  Stream<List<CategoryModel>> featuredCategoriesStream() {
    return _catRef
        .where('ownerId', isEqualTo: uId)
        .where('isFeatured', isEqualTo: true)
        .snapshots()
        .map(_modelsFromSnapshot);
  }
}
