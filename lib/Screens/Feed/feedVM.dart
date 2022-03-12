import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Constants/Constantcolors.dart';
import 'package:thesocial/Screens/AltProfile/altProfile_screen.dart';
import 'package:thesocial/Screens/Profile/profile_screen.dart';
import 'package:thesocial/Services/auth_services.dart';
import 'package:thesocial/Services/uploadPost_service.dart';
import 'package:thesocial/Utils/postOperations.dart';

class FeedVM with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: constantColors.darkColor.withOpacity(0.6),
      actions: [
        IconButton(
            icon: Icon(
              EvaIcons.camera,
              color: constantColors.greenColor,
            ),
            onPressed: () {
              Provider.of<UploadPostVM>(context, listen: false)
                  .showImageToUploadSheet(context);
            })
      ],
      centerTitle: true,
      title: RichText(
          text: TextSpan(
              text: 'Social ',
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              children: <TextSpan>[
            TextSpan(
              text: 'Feed',
              style: TextStyle(
                  color: constantColors.blueColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
          ])),
    );
  }

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(23), topRight: Radius.circular(23))),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                    height: 300,
                    width: 200,
                    child: Lottie.asset('Assets/loading.json'));
              } else {
                return loadPosts(context, snapshot);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget loadPosts(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
        children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
      Provider.of<PostOperations>(context, listen: false)
          .showImageTime(documentSnapshot['time']);
      return Container(
        height: MediaQuery.of(context).size.height * 0.65,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (documentSnapshot['userUid'] !=
                          Provider.of<AuthServiceVM>(context, listen: false)
                              .userUid) {
                        Navigator.of(context).pushReplacement(PageTransition(
                            child: AltProfileScreen(
                              userUid: documentSnapshot['userUid'],
                            ),
                            type: PageTransitionType.leftToRight));
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: constantColors.blueGreyColor,
                      radius: 20,
                      backgroundImage:
                          NetworkImage(documentSnapshot['userImage']),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              documentSnapshot['caption'],
                              style: TextStyle(
                                color: constantColors.greenColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                              child: RichText(
                                  text: TextSpan(
                                      text: documentSnapshot['username'],
                                      style: TextStyle(
                                        color: constantColors.blueColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      children: <TextSpan>[
                                TextSpan(
                                    text:
                                        '  ${Provider.of<PostOperations>(context, listen: false).getImageTimeUploaded.toString()}',
                                    style: TextStyle(
                                        color: constantColors.lightColor
                                            .withOpacity(0.8)))
                              ])))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.46,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  child: Image.network(
                    documentSnapshot['postImage'],
                    scale: 2,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onLongPress: () {
                              Provider.of<PostOperations>(context,
                                      listen: false)
                                  .showLikeSheet(
                                      context, documentSnapshot['caption']);
                            },
                            onTap: () {
                              print('Adiing Like');
                              Provider.of<PostOperations>(context,
                                      listen: false)
                                  .addLikes(
                                      context,
                                      documentSnapshot['caption'],
                                      Provider.of<AuthServiceVM>(context,
                                              listen: false)
                                          .userUid);
                            },
                            child: Icon(
                              FontAwesomeIcons.heart,
                              size: 22,
                              color: constantColors.redColor,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(documentSnapshot['caption'])
                                  .collection('likes')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      snapshot.data.docs.length.toString(),
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  );
                                }
                              })
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Provider.of<PostOperations>(context,
                                      listen: false)
                                  .showCommentSheet(context, documentSnapshot,
                                      documentSnapshot['caption']);
                            },
                            child: Icon(
                              FontAwesomeIcons.comment,
                              size: 22,
                              color: constantColors.blueColor,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(documentSnapshot['caption'])
                                .collection('comments')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    snapshot.data.docs.length.toString(),
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Icon(
                              FontAwesomeIcons.award,
                              size: 22,
                              color: constantColors.yellowColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              '0',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Provider.of<AuthServiceVM>(context, listen: false)
                                .userUid ==
                            documentSnapshot['userUid']
                        ? IconButton(
                            icon: Icon(
                              EvaIcons.moreVertical,
                              color: constantColors.whiteColor,
                            ),
                            onPressed: () {
                              Provider.of<PostOperations>(context,
                                      listen: false)
                                  .showImageOptionsSheet(
                                      context, documentSnapshot['caption']);
                            })
                        : Container(
                            width: 0,
                            height: 0,
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList());
  }
}
