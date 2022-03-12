import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Constants/Constantcolors.dart';
import 'package:thesocial/Screens/AltProfile/altProfile_screen.dart';
import 'package:thesocial/Screens/HomePage/home_screen.dart';
import 'package:thesocial/Services/auth_services.dart';
import 'package:thesocial/Services/firebaseOperations_services.dart';
import 'package:thesocial/Utils/postOperations.dart';

class AltProfileVM with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            EvaIcons.arrowIosBackOutline,
            color: constantColors.lightBlueColor,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(PageTransition(
                child: HomeScreen(), type: PageTransitionType.bottomToTop));
          }),
      actions: [
        IconButton(
            icon: Icon(
              EvaIcons.moreVertical,
              color: constantColors.greenColor,
            ),
            onPressed: () {})
      ],
      centerTitle: true,
      backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
      title: RichText(
          text: TextSpan(
              text: 'The ',
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              children: <TextSpan>[
            TextSpan(
              text: 'Social',
              style: TextStyle(
                  color: constantColors.blueColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
          ])),
    );
  }

  Widget profileHeader(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> snapshot, String userUid) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 220,
                width: 180,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                          backgroundColor: constantColors.transperant,
                          backgroundImage:
                              NetworkImage(snapshot.data['image'])),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(snapshot.data['username'],
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            EvaIcons.email,
                            color: constantColors.greenColor,
                            size: 10,
                          ),
                          Text(snapshot.data['email'],
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              checkFollowersSheet(context, snapshot);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: constantColors.darkColor,
                                  borderRadius: BorderRadius.circular(15)),
                              height: 70,
                              width: 80,
                              child: Column(
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(snapshot.data['userUid'])
                                        .collection('followers')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Text(
                                          snapshot.data.docs.length.toString(),
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                  Text(
                                    'Followers',
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          GestureDetector(
                            onTap: () {
                              checkFollowingSheet(context, snapshot);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: constantColors.darkColor,
                                  borderRadius: BorderRadius.circular(15)),
                              height: 70,
                              width: 80,
                              child: Column(
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(snapshot.data['userUid'])
                                        .collection('following')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Text(
                                          snapshot.data.docs.length.toString(),
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                  Text(
                                    'Following',
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
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
                        decoration: BoxDecoration(
                            color: constantColors.darkColor,
                            borderRadius: BorderRadius.circular(15)),
                        height: 70,
                        width: 80,
                        child: Column(
                          children: [
                            Text(
                              '0',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Posts',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                    color: constantColors.blueColor,
                    child: Text(
                      'Follow',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .followUser(
                              userUid,
                              Provider.of<AuthServiceVM>(context, listen: false)
                                  .userUid,
                              {
                                'email': Provider.of<FirebaseOperations>(
                                        context,
                                        listen: false)
                                    .getUserEmail,
                                'username': Provider.of<FirebaseOperations>(
                                        context,
                                        listen: false)
                                    .getUsername,
                                'image': Provider.of<FirebaseOperations>(
                                        context,
                                        listen: false)
                                    .getUserImage,
                                'userUid': Provider.of<AuthServiceVM>(context,
                                        listen: false)
                                    .userUid,
                                'time': Timestamp.now()
                              },
                              Provider.of<AuthServiceVM>(context, listen: false)
                                  .userUid,
                              userUid,
                              {
                                'username': snapshot.data['username'],
                                'email': snapshot.data['email'],
                                'image': snapshot.data['image'],
                                'userUid': snapshot.data['userUid'],
                                'time': Timestamp.now()
                              })
                          .whenComplete(() {
                        followNotification(context, snapshot.data['username']);
                      });
                    }),
                MaterialButton(
                    color: constantColors.redColor,
                    child: Text(
                      'Message',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {})
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget divider(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 25,
        width: MediaQuery.of(context).size.width,
        child: Divider(
          color: constantColors.whiteColor,
        ),
      ),
    );
  }

  Widget recentlyAdded(BuildContext context, dynamic snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                FontAwesomeIcons.userAstronaut,
                color: constantColors.yellowColor,
                size: 16,
              ),
              Text(
                'Recently Added',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.darkColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(15)),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data['userUid'])
                .collection('followers')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return new ListView(
                    children: snapshot.data.docs
                        .map((DocumentSnapshot documentSnapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return new Container(
                      height: 60,
                      width: 60,
                      child: Image.network(documentSnapshot['image']),
                    );
                  }
                }).toList());
              }
            },
          ),
        )
      ],
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: constantColors.darkColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5)),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(snapshot.data['userUid'])
              .collection('posts')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return new GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  children: snapshot.data.docs
                      .map((DocumentSnapshot documentSnapshot) {
                    return GestureDetector(
                      onTap: () {
                        showPostDetails(context, documentSnapshot);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        child: FittedBox(
                          child: Image.network(documentSnapshot['postImage']),
                        ),
                      ),
                    );
                  }).toList());
            }
          },
        ),
      ),
    );
  }

  followNotification(BuildContext context, String name) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Text(
                    'Followed $name',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )
                ],
              ),
            ),
          );
        });
  }

  checkFollowingSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12)),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data['userUid'])
                  .collection('following')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return new ListView(
                      children: snapshot.data.docs
                          .map((DocumentSnapshot documentSnapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return new ListTile(
                        trailing: documentSnapshot['userUid'] ==
                                Provider.of<AuthServiceVM>(context,
                                        listen: false)
                                    .userUid
                            ? Container(
                                width: 0,
                                height: 0,
                              )
                            : MaterialButton(
                                color: constantColors.blueColor,
                                child: Text(
                                  'Follow',
                                  style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                onPressed: () {}),
                        leading: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacement(PageTransition(
                                    child: AltProfileScreen(
                                      userUid: documentSnapshot['userUid'],
                                    ),
                                    type: PageTransitionType.topToBottom));
                          },
                          child: CircleAvatar(
                              backgroundColor: constantColors.darkColor,
                              backgroundImage:
                                  NetworkImage(documentSnapshot['image'])),
                        ),
                        title: Text(
                          documentSnapshot['username'],
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        subtitle: Text(
                          documentSnapshot['email'],
                          style: TextStyle(
                              color: constantColors.yellowColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      );
                    }
                  }).toList());
                }
              },
            ),
          );
        });
  }

  checkFollowersSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12)),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data['userUid'])
                  .collection('followers')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return new ListView(
                      children: snapshot.data.docs
                          .map((DocumentSnapshot documentSnapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return new ListTile(
                        leading: CircleAvatar(
                            backgroundColor: constantColors.darkColor,
                            backgroundImage:
                                NetworkImage(documentSnapshot['image'])),
                        title: Text(
                          documentSnapshot['username'],
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        subtitle: Text(
                          documentSnapshot['email'],
                          style: TextStyle(
                              color: constantColors.yellowColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      );
                    }
                  }).toList());
                }
              },
            ),
          );
        });
  }

  showPostDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    child: Image.network(documentSnapshot['postImage']),
                  ),
                ),
                Text(
                  documentSnapshot['caption'],
                  style: TextStyle(
                      color: constantColors.yellowColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
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
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
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
                                      .showCommentSheet(
                                          context,
                                          documentSnapshot,
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
        });
  }
}
