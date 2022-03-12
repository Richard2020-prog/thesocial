import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Constants/Constantcolors.dart';
import 'package:thesocial/Screens/Chatroom/chatVM.dart';
import 'package:thesocial/Screens/Messages/messages_screen.dart';

class ChatScreen extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  // const ChatScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              EvaIcons.plus,
              color: constantColors.lightBlueColor,
            ),
            onPressed: () {
              Provider.of<ChatVM>(context, listen: false)
                  .showImageSourceSheet(context);
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
        backgroundColor: constantColors.darkColor.withOpacity(0.6),
        title: RichText(
            text: TextSpan(
                text: 'Chat ',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                children: <TextSpan>[
              TextSpan(
                text: 'Room',
                style: TextStyle(
                    color: constantColors.blueColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
            ])),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: constantColors.blueGreyColor,
          child: Icon(
            FontAwesomeIcons.plus,
            color: constantColors.greenColor,
          ),
          onPressed: () {
            Provider.of<ChatVM>(context, listen: false)
                .showImageSourceSheet(context);
          }),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return new ListView(
              children:
                  snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).pushReplacement(PageTransition(
                        child:
                            MessagesScreen(documentSnapshot: documentSnapshot),
                        type: PageTransitionType.leftToRight));
                  },
                  onLongPress: () {
                    Provider.of<ChatVM>(context, listen: false)
                        .showChatRoomMembers(context, documentSnapshot);
                  },
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: constantColors.transperant,
                    backgroundImage:
                        NetworkImage(documentSnapshot['roomimage']),
                  ),
                  title: Text(
                    documentSnapshot['roomname'],
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  subtitle: Text(
                    'New Message',
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  trailing: Text(
                    '2 hours ago',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
