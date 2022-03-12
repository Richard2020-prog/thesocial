import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Constants/Constantcolors.dart';
import 'package:thesocial/Screens/LandingPage/landingVM.dart';

class LandingScreen extends StatefulWidget {
  // const LandingScreen({ Key? key }) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: constantColors.whiteColor,
      body: Stack(
        children: [
          bodyColour(),
          Provider.of<LandingVM>(context, listen: false).bodyImage(context),
          Provider.of<LandingVM>(context, listen: false).tagLineText(context),
          Provider.of<LandingVM>(context, listen: false).mainButtons(context),
          Provider.of<LandingVM>(context, listen: false).privacyText(context),
        ],
      ),
    );
  }

  bodyColour() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [
            0.5,
            0.9
          ],
              colors: [
            constantColors.darkColor,
            constantColors.blueGreyColor
          ])),
    );
  }
}
