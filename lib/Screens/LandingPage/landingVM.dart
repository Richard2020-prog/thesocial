import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Constants/Constantcolors.dart';
import 'package:thesocial/Screens/LandingPage/landing_service.dart';
import 'package:thesocial/Screens/LandingPage/landing_utils.dart';

class LandingVM with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('Assets/login.png'))),
    );
  }

  Widget tagLineText(BuildContext context) {
    return Positioned(
        top: 350,
        left: 10,
        child: Container(
          constraints: BoxConstraints(maxWidth: 170),
          child: RichText(
              text: TextSpan(
                  text: 'Are ',
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontFamily: 'Poppins',
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                TextSpan(
                    text: 'You ',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontFamily: 'Poppins',
                        fontSize: 34,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: 'Social ',
                    style: TextStyle(
                        color: constantColors.blueColor,
                        fontFamily: 'Poppins',
                        fontSize: 34,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: '?',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontFamily: 'Poppins',
                        fontSize: 34,
                        fontWeight: FontWeight.bold))
              ])),
        ));
  }

  Widget mainButtons(BuildContext context) {
    return Positioned(
        top: 500,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  emailSheet(context);
                },
                child: Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: constantColors.yellowColor),
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      EvaIcons.emailOutline,
                      color: constantColors.yellowColor,
                    )),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: constantColors.redColor),
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      EvaIcons.google,
                      color: constantColors.redColor,
                    )),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: constantColors.blueColor),
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      EvaIcons.facebook,
                      color: constantColors.blueColor,
                    )),
              )
            ],
          ),
        ));
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
        top: 600,
        left: 20,
        right: 20,
        child: Container(
          child: Column(
            children: [
              Text(
                "By continuing you agree with theSocial's Terms of",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              Text(
                "Services and Privacy Policy",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              )
            ],
          ),
        ));
  }

  emailSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Provider.of<LandingService>(context, listen: false)
                    .passwordlessSignIn(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Provider.of<LandingService>(context, listen: false)
                              .logInSheet(context);
                        }),
                    MaterialButton(
                        color: constantColors.redColor,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Provider.of<LandingUtils>(context, listen: false)
                              .selectImageMethod(context);
                        }),
                  ],
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18))),
          );
        });
  }
}
