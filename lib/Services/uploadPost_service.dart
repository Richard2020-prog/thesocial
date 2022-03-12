import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Constants/Constantcolors.dart';
import 'package:thesocial/Screens/Feed/feedVM.dart';
import 'package:thesocial/Services/auth_services.dart';
import 'package:thesocial/Services/firebaseOperations_services.dart';

class UploadPostVM with ChangeNotifier {
  TextEditingController captionController = TextEditingController();
  ConstantColors constantColors = ConstantColors();

  File imageToUpload;
  String imageToUploadUrl;

  String get getImageToUploadUrl => imageToUploadUrl;
  File get getImageToUpload => imageToUpload;
  final picker = ImagePicker();
  UploadTask imageToPostUploadTask;

  Future imagePost(BuildContext context, ImageSource source) async {
    final pickedImageToPost = await picker.pickImage(source: source);

    pickedImageToPost == null
        ? print('Select Your Image')
        : imageToUpload = File(pickedImageToPost.path);
    print(pickedImageToPost.path);

    imageToUpload != null
        ? Provider.of<UploadPostVM>(context, listen: false)
            .showChosenImage(context)
        : print('Error Getting Image');
    notifyListeners();
  }

  Future uploadImageToPostFirebaseStorage() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${imageToUpload.path}/${TimeOfDay.now()}');

    imageToPostUploadTask = imageReference.putFile(imageToUpload);

    await imageToPostUploadTask.whenComplete(() {
      print('Image Has Been Uploaded To Storage');
    });

    imageReference.getDownloadURL().then((imageUrl) {
      imageToUploadUrl = imageUrl;
      print(imageToUploadUrl);
    });

    notifyListeners();
  }

  showImageToUploadSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: constantColors.blueGreyColor),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          'Camera',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          imagePost(context, ImageSource.camera);
                        }),
                    MaterialButton(
                        color: constantColors.redColor,
                        child: Text(
                          'Gallery',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          imagePost(context, ImageSource.gallery);
                        }),
                  ],
                )
              ],
            ),
          );
        });
  }

  showChosenImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                  child: Container(
                    height: 200,
                    width: 400,
                    child: Image.file(imageToUpload),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            'Reselect Image',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            showImageToUploadSheet(context);
                          }),
                      MaterialButton(
                          color: constantColors.redColor,
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            uploadImageToPostFirebaseStorage().whenComplete(() {
                              editPostSheet(context);
                              print('Image Uploaded');
                            });
                          })
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            IconButton(
                                icon: Icon(Icons.image_aspect_ratio),
                                color: constantColors.greenColor,
                                onPressed: () {}),
                            IconButton(
                                icon: Icon(Icons.fit_screen),
                                color: constantColors.yellowColor,
                                onPressed: () {}),
                          ],
                        ),
                      ),
                      Container(
                        height: 150,
                        width: 300,
                        child: Image.file(
                          imageToUpload,
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset('Assets/sunflower.png'),
                      ),
                      Container(
                        height: 50,
                        width: 5,
                        color: constantColors.blueColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          height: 100,
                          width: 300,
                          child: TextField(
                            maxLength: 100,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            maxLengthEnforced: true,
                            maxLines: 5,
                            controller: captionController,
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Add A Caption',
                              hintStyle: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                    color: constantColors.blueColor,
                    child: Text(
                      'Share',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    onPressed: () async {
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .uploadUserPost(captionController.text, {
                        'caption': captionController.text,
                        'postImage': imageToUploadUrl,
                        'username': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getUsername,
                        'userImage': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getUserImage,
                        'userUid':
                            Provider.of<AuthServiceVM>(context, listen: false)
                                .getUserId,
                        'time': Timestamp.now(),
                        'useremail': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getUserEmail
                      }).whenComplete(() async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(Provider.of<AuthServiceVM>(context,
                                    listen: false)
                                .userUid)
                            .collection('posts')
                            .add({
                          'caption': captionController.text,
                          'postImage': imageToUploadUrl,
                          'username': Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getUsername,
                          'userImage': Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getUserImage,
                          'userUid':
                              Provider.of<AuthServiceVM>(context, listen: false)
                                  .getUserId,
                          'time': Timestamp.now(),
                          'useremail': Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getUserEmail
                        });
                      }).whenComplete(() {
                        Navigator.of(context).pop();
                      });
                    })
              ],
            ),
          );
        });
  }
}
