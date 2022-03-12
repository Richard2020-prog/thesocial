import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:thesocial/Constants/Constantcolors.dart';
import 'package:thesocial/Screens/LandingPage/landing_screen.dart';

class SplashScreen extends StatefulWidget {
  // const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ConstantColors constantColors = ConstantColors();

  @override
  void initState() {
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context,
            PageTransition(
                child: LandingScreen(), type: PageTransitionType.leftToRight)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: Center(
        child: RichText(
            text: TextSpan(
                text: 'the',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontFamily: 'Poppins',
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
                children: <TextSpan>[
              TextSpan(
                  text: 'Social',
                  style: TextStyle(
                      color: constantColors.blueColor,
                      fontFamily: 'Poppins',
                      fontSize: 34,
                      fontWeight: FontWeight.bold))
            ])),
      ),
    );
  }
}
