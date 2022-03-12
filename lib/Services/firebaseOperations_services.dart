import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Screens/LandingPage/landing_utils.dart';
import 'package:thesocial/Services/auth_services.dart';

class FirebaseOperations with ChangeNotifier {
  String username;
  String email;
  String image;

  String get getUsername => username;
  String get getUserEmail => email;
  String get getUserImage => image;

  UploadTask uploadTask;
  Future uploadUserImage(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userImage/${Provider.of<LandingUtils>(context, listen: false).getUserImage.path}/${TimeOfDay.now()}');

    uploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserImage);
    await uploadTask.whenComplete(() {
      print('Image Has Been Uploaded');
    });

    imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).userImageUrl =
          url.toString();

      print(
          'The userImageUrl => ${Provider.of<LandingUtils>(context, listen: false).userImageUrl}');
      notifyListeners();
    });
  }

  Future createUser(BuildContext context, dynamic data) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<AuthServiceVM>(context, listen: false).userUid)
        .set(data);
  }

  Future getUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<AuthServiceVM>(context, listen: false).userUid)
        .get()
        .then((doc) {
      print('Fetching User Data...');
      username = doc.data()['username'];
      email = doc.data()['email'];
      image = doc.data()['image'];
      print(username);
      print(email);
      print(image);
      notifyListeners();
    });
  }

  Future uploadUserPost(String postId, dynamic data) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future deleteUser(String userUid, String collection) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(userUid)
        .delete();
  }

  Future updateCaption(String postId, dynamic data) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }

  Future followUser(
    String followingUid,
    String followingDocId,
    dynamic followingData,
    String followerUid,
    String followerDocId,
    dynamic followerData,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followerDocId)
          .set(followerData);
    });
  }

  Future uploadChatRoomData(
    BuildContext context,
    String chatRoomId,
    dynamic chatRoomdata,
  ) async {
    await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .set(chatRoomdata);
  }
}
