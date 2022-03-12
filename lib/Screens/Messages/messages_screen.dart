import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Constants/Constantcolors.dart';
import 'package:thesocial/Screens/Chatroom/chat_screen.dart';
import 'package:thesocial/Screens/HomePage/home_screen.dart';
import 'package:thesocial/Screens/Messages/messagesVM.dart';
import 'package:thesocial/Services/auth_services.dart';

class MessagesScreen extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  MessagesScreen({@required this.documentSnapshot});
  final ConstantColors constantColors = ConstantColors();
  TextEditingController messageController = TextEditingController();
  // const MessagesScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: constantColors.whiteColor,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(PageTransition(
                child: HomeScreen(), type: PageTransitionType.fade));
          },
        ),
        actions: [
          Provider.of<AuthServiceVM>(context, listen: false).userUid ==
                  documentSnapshot['userUid']
              ? IconButton(
                  icon: Icon(EvaIcons.moreVerticalOutline), onPressed: () {})
              : Container(
                  width: 0,
                  height: 0,
                ),
          IconButton(
              icon: Icon(
                EvaIcons.logOutOutline,
                color: constantColors.redColor,
              ),
              onPressed: () {})
        ],
        centerTitle: true,
        backgroundColor: constantColors.darkColor.withOpacity(0.6),
        title: Container(
          width: MediaQuery.of(context).size.width * 0.51,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(documentSnapshot['roomimage']),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      documentSnapshot['roomname'],
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '2 members',
                      style: TextStyle(
                          color: constantColors.blueGreyColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AnimatedContainer(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                duration: Duration(seconds: 3),
                curve: Curves.bounceIn,
                child: Provider.of<MessagesVM>(context, listen: false)
                    .retrieveMessages(
                        context, documentSnapshot, documentSnapshot['userUid']),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: constantColors.transperant,
                          backgroundImage: AssetImage('Assets/sunflower.png'),
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TextField(
                            controller: messageController,
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: 'Drop A Message',
                              hintStyle: TextStyle(
                                  color: constantColors.greenColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      FloatingActionButton(
                          backgroundColor: constantColors.blueColor,
                          child: Icon(
                            Icons.send_sharp,
                            color: constantColors.whiteColor,
                          ),
                          onPressed: () {
                            if (messageController.text.isNotEmpty) {
                              Provider.of<MessagesVM>(context, listen: false)
                                  .sendMessage(context, messageController,
                                      documentSnapshot);
                            }
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
