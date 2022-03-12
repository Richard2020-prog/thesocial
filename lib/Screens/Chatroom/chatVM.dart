import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Constants/Constantcolors.dart';
import 'package:thesocial/Services/auth_services.dart';
import 'package:thesocial/Services/firebaseOperations_services.dart';

class ChatVM with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController chatRoomNameController = TextEditingController();
  File chatRoomImage;
  File get getchatRoomImage => chatRoomImage;
  String chatRoomImageUrl;
  String get getchatRoomImageUrl => chatRoomImageUrl;
  final picker = ImagePicker();
  UploadTask chatRoomImageUploadTask;
  String chatRoomId;
  String get getchatRoomId => chatRoomId;

  Future getChatRoomImage(BuildContext context, ImageSource imageSource) async {
    final chatImagePicked = await picker.pickImage(source: imageSource);

    chatImagePicked == null
        ? print('Select ChatRoom Image')
        : chatRoomImage = File(chatImagePicked.path);
    print(chatImagePicked.path);

    chatRoomImage != null
        ? Provider.of<ChatVM>(context, listen: false).showImageChatroom(context)
        : print('Error Getting ChatImage');
    notifyListeners();
  }

  Future chatRoomImageToFirebaseStorage() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('chatrooms/${chatRoomImage.path}/${TimeOfDay.now()}');

    chatRoomImageUploadTask = imageReference.putFile(chatRoomImage);

    await chatRoomImageUploadTask.whenComplete(() {
      print('Image Has Been Uploaded To Storage');
    });

    imageReference.getDownloadURL().then((imageUrl) {
      chatRoomImageUrl = imageUrl;
      print(chatRoomImageUrl);
    });

    notifyListeners();
  }

  showImageSourceSheet(BuildContext context) {
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
                          getChatRoomImage(context, ImageSource.camera);
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
                          getChatRoomImage(context, ImageSource.gallery);
                        }),
                  ],
                )
              ],
            ),
          );
        });
  }

  showImageChatroom(BuildContext context) {
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
                    child: Image.file(chatRoomImage),
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
                            showImageSourceSheet(context);
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
                            chatRoomImageToFirebaseStorage().whenComplete(() {
                              showSheetChatData(context);
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

  showSheetChatData(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
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
                    height: 100,
                    width: 100,
                    child: Image.file(
                      chatRoomImage,
                      fit: BoxFit.contain,
                    )),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          controller: chatRoomNameController,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter ChatRoom Name',
                            hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                          backgroundColor: constantColors.blueGreyColor,
                          child: Icon(
                            FontAwesomeIcons.plus,
                            color: constantColors.yellowColor,
                          ),
                          onPressed: () async {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .uploadChatRoomData(
                                    context, chatRoomNameController.text, {
                              'roomimage': getchatRoomImageUrl,
                              'time': Timestamp.now(),
                              'roomname': chatRoomNameController.text,
                              'adminName': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getUsername,
                              'adminImage': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getUserImage,
                              'adminEmail': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getUserEmail,
                              'userUid': Provider.of<AuthServiceVM>(context,
                                      listen: false)
                                  .userUid
                            }).whenComplete(() {
                              Navigator.of(context).pop();
                            });
                          })
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  showChatRoomMembers(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
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
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: constantColors.blueColor,
                      ),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Members',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: constantColors.yellowColor,
                      ),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Admin',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: constantColors.transperant,
                        backgroundImage:
                            NetworkImage(documentSnapshot['adminImage']),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          documentSnapshot['adminName'],
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
