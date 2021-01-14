import 'package:body_coach/models/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestService {
  final String sender;
  final String catId;
  final String receiver;
  final String reqId;

  RequestService({
    this.catId,
    this.receiver,
    this.sender,
    this.reqId,
  });

  CollectionReference _reqRef = Firestore.instance.collection('Categories');

  Future createRequest({
    String name,
    String trainer,
    String senderImg,
    String trainerImg,
  }) async {
    try {
      await _reqRef
          .document(catId)
          .collection('Requests')
          .document(reqId)
          .setData(Request(
            reqStatus: SubscriptionRequestStatus.PENDING.index,
            joinedTime: Timestamp.now(),
            subscribedImgUrl: trainerImg,
            subImgUrl: senderImg,
            subName: name,
            subscribedName: trainer,
            subId: sender,
            subscribedId: receiver,
            subCat: catId,
          ).toJson());
    } catch (e) {
      print('CREATE REQ ERR: $e');
    }
  }

  Future<Request> getRequest() async {
    try {
      DocumentSnapshot snapshot = await _reqRef
          .document(catId)
          .collection('Requests')
          .document(reqId)
          .get();

      if (snapshot.data == null) return null;

      return Request(id: snapshot.documentID).fromJson(snapshot.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future removeRequest() async {
    try {
      await _reqRef
          .document(catId)
          .collection('Requests')
          .document(reqId)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  Future updateRequestStatus({SubscriptionRequestStatus status}) async {
    try {
      await _reqRef
          .document(catId)
          .collection('Requests')
          .document(reqId)
          .updateData(Request(reqStatus: status.index).toJsonReq());
    } catch (e) {
      print(e);
    }
  }

  Request _requestStatusStreamFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot.data == null
        ? Request(reqStatus: 3)
        : Request(id: snapshot.documentID).fromJson(snapshot.data);
  }

  Stream<Request> requestStatusStream() {
    return _reqRef
        .document(catId)
        .collection('Requests')
        .document(reqId)
        .snapshots()
        .map(_requestStatusStreamFromSnapshot);
  }

  List<Request> _requestsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((e) => Request(id: e.documentID).fromJson(e.data))
        .toList();
  }

  Stream<List<Request>> requestsStream() {
    return _reqRef
        .document(catId)
        .collection('Requests')
        .where('req-status', isEqualTo: 0)
        .snapshots()
        .map(_requestsFromSnapshot);
  }

  int _count(QuerySnapshot snapshot) {
    if (snapshot.documents == null) return 0;
    return snapshot.documents.isEmpty ? 0 : snapshot.documents.length;
  }

  Stream<int> countRequests() {
    return _reqRef
        .document(catId)
        .collection('Requests')
        .where('req-status', isEqualTo: 0)
        .snapshots()
        .map(_count);
  }
}
