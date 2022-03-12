import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Constants/Constantcolors.dart';
import 'package:thesocial/Services/auth_services.dart';
import 'package:thesocial/Services/firebaseOperations_services.dart';

class MessagesVM with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  sendMessage(BuildContext context, TextEditingController messageController,
      DocumentSnapshot documentSnapshot) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(documentSnapshot.id)
        .collection('messages')
        .add({
      'message': messageController.text,
      'time': Timestamp.now(),
      'userUid': Provider.of<AuthServiceVM>(context, listen: false).userUid,
      'name':
          Provider.of<FirebaseOperations>(context, listen: false).getUsername,
      'image':
          Provider.of<FirebaseOperations>(context, listen: false).getUserImage,
    });
  }

  retrieveMessages(
      BuildContext context, DocumentSnapshot documentSnapshot, String adminId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(documentSnapshot.id)
          .collection('messages')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return new ListView(
              reverse: true,
              children:
                  snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 60, bottom: 20),
                          child: Row(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.2,
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.8,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Provider.of<AuthServiceVM>(context,
                                                    listen: false)
                                                .userUid ==
                                            documentSnapshot['userUid']
                                        ? constantColors.blueGreyColor
                                            .withOpacity(0.8)
                                        : constantColors.blueGreyColor),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 140,
                                        child: Row(
                                          children: [
                                            Text(
                                              documentSnapshot['name'],
                                              style: TextStyle(
                                                  color:
                                                      constantColors.greenColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Provider.of<AuthServiceVM>(context,
                                                            listen: false)
                                                        .userUid ==
                                                    adminId
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Icon(
                                                      FontAwesomeIcons
                                                          .chessKing,
                                                      color: constantColors
                                                          .yellowColor,
                                                      size: 12,
                                                    ),
                                                  )
                                                : Container(
                                                    width: 0,
                                                    height: 0,
                                                  )
                                          ],
                                        ),
                                      ),
                                      Text(
                                        documentSnapshot['message'],
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                            top: 15,
                            child: Provider.of<AuthServiceVM>(context,
                                            listen: false)
                                        .userUid ==
                                    documentSnapshot['userUid']
                                ? Container(
                                    child: Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            size: 18,
                                          ),
                                          onPressed: () {},
                                          color: constantColors.blueColor,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            FontAwesomeIcons.trashAlt,
                                            size: 18,
                                          ),
                                          onPressed: () {},
                                          color: constantColors.redColor,
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    width: 0,
                                    height: 0,
                                  )),
                        Positioned(
                            left: 40,
                            child: Provider.of<AuthServiceVM>(context,
                                            listen: false)
                                        .userUid ==
                                    documentSnapshot['userUid']
                                ? Container(
                                    width: 0,
                                    height: 0,
                                  )
                                : CircleAvatar(
                                    radius: 15,
                                    backgroundColor: constantColors.darkColor,
                                    backgroundImage:
                                        NetworkImage(documentSnapshot['image']),
                                  ))
                      ],
                    ),
                  ),
                );
              }).toList());
        }
      },
    );
  }
}
