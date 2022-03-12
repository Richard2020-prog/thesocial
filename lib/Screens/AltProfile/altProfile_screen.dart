import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Constants/Constantcolors.dart';
import 'package:thesocial/Screens/AltProfile/altProfileVM.dart';

class AltProfileScreen extends StatelessWidget {
  // const AltProfileScreen({ Key? key }) : super(key: key);
  final String userUid;
  AltProfileScreen({this.userUid});
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Provider.of<AltProfileVM>(context, listen: false).appBar(context),
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
                  .doc(userUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return new Column(
                    children: [
                      Provider.of<AltProfileVM>(context, listen: false)
                          .profileHeader(context, snapshot, userUid),
                      Provider.of<AltProfileVM>(context, listen: false)
                          .divider(context),
                      Provider.of<AltProfileVM>(context, listen: false)
                          .recentlyAdded(context, snapshot),
                      Provider.of<AltProfileVM>(context, listen: false)
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
