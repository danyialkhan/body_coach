import 'package:body_coach/models/user.dart';
import 'package:body_coach/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Auth with ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future logOut() async {
    return await _auth.signOut().catchError((e) {
      throw e;
    });
  }

  User _userFromFirebaseUser(FirebaseUser firebaseUser) {
    return firebaseUser == null ? null : User(uId: firebaseUser.uid);
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future signUp(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      await UserService(uId: user.uid).saveUser(
        gender: 0,
        imgUrl: null,
        email: email,
        mobileNumber: '0000-000-000',
        name: 'user',
      );

      return _userFromFirebaseUser(user);
    } catch (e) {
      throw e;
    }
  }

  Future signIn(String email, String password) async {
    return await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((logInUser) {
      FirebaseUser user = logInUser.user;
      return _userFromFirebaseUser(user);
    }).catchError((e) {
      throw e;
    });
  }

}