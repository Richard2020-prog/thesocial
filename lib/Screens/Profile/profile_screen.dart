import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Constants/Constantcolors.dart';
import 'package:thesocial/Screens/LandingPage/landing_screen.dart';
import 'package:thesocial/Screens/Profile/profileVM.dart';
import 'package:thesocial/Services/auth_services.dart';

class ProfileScreen extends StatefulWidget {
  // const ProfileScreen({ Key? key }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              EvaIcons.settings2Outline,
              color: constantColors.lightBlueColor,
            ),
            onPressed: () {}),
        actions: [
          IconButton(
              icon: Icon(
                EvaIcons.logOutOutline,
                color: constantColors.greenColor,
              ),
              onPressed: () {
                Provider.of<ProfileVM>(context, listen: false)
                    .logOutDialog(context);
              })
        ],
        centerTitle: true,
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
            text: TextSpan(
                text: 'My ',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                children: <TextSpan>[
              TextSpan(
                text: 'Profile',
                style: TextStyle(
                    color: constantColors.blueColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
            ])),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: constantColors.blueGreyColor.withOpacity(0.6)),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(
                    Provider.of<AuthServiceVM>(context, listen: false).userUid,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return new Column(
                    children: [
                      Provider.of<ProfileVM>(context, listen: false)
                          .profileHeader(context, snapshot),
                      Provider.of<ProfileVM>(context, listen: false)
                          .divider(context),
                      Provider.of<ProfileVM>(context, listen: false)
                          .recentlyAdded(context, snapshot),
                      Provider.of<ProfileVM>(context, listen: false)
                          .footerProfile(context, snapshot)
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
