import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthServiceVM with ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String userUid;
  String get getUserId => userUid;

  Future signUpWithEmail(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    User user = userCredential.user;
    userUid = user.uid;
    print('Created Account Uid => $userUid');
    notifyListeners();
  }

  Future logInWithEmail(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    User user = userCredential.user;
    userUid = user.uid;
    print(userUid);
    notifyListeners();
  }

  Future signOut() {
    return FirebaseAuth.instance.signOut();
  }
}
