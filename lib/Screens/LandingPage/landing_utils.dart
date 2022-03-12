import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Constants/Constantcolors.dart';
import 'package:thesocial/Screens/LandingPage/landing_service.dart';

class LandingUtils with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  final picker = ImagePicker();
  File userImage;
  File get getUserImage => userImage;

  String userImageUrl;
  String get getUserImageUrl => userImageUrl;

  Future pickUserImage(BuildContext context, ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    pickedFile == null
        ? print('Select Your image')
        : userImage = File(pickedFile.path);
    print(userImage.path);

    userImage != null
        ? Provider.of<LandingService>(context, listen: false)
            .showUserImage(context)
        : print('Error Getting userImage');

    notifyListeners();
  }

  Future selectImageMethod(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(color: constantColors.blueGreyColor),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            'Gallery',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            pickUserImage(context, ImageSource.gallery)
                                .whenComplete(() {
                              Navigator.of(context).pop();
                              Provider.of<LandingService>(context,
                                      listen: false)
                                  .showUserImage(context);
                            });
                          }),
                      MaterialButton(
                          color: constantColors.redColor,
                          child: Text(
                            'Camera',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            pickUserImage(context, ImageSource.camera)
                                .whenComplete(() {
                              Navigator.of(context).pop();
                              Provider.of<LandingService>(context,
                                      listen: false)
                                  .showUserImage(context);
                            });
                          })
                    ],
                  )
                ],
              ));
        });
  }
}
