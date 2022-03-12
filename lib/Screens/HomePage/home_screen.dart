import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Constants/Constantcolors.dart';
import 'package:thesocial/Screens/Chatroom/chat_screen.dart';
import 'package:thesocial/Screens/Feed/feed_screen.dart';
import 'package:thesocial/Screens/HomePage/homeVM.dart';
import 'package:thesocial/Screens/Profile/profile_screen.dart';
import 'package:thesocial/Services/firebaseOperations_services.dart';

class HomeScreen extends StatefulWidget {
  // const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ConstantColors constantColors = ConstantColors();
  PageController homepagecontroller = PageController();
  int pageIndex = 0;

  @override
  void initState() {
    Provider.of<FirebaseOperations>(context, listen: false)
        .getUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: constantColors.darkColor,
        body: PageView(
          controller: homepagecontroller,
          children: [FeedScreen(), ChatScreen(), ProfileScreen()],
          onPageChanged: (page) {
            setState(() {
              pageIndex = page;
            });
          },
        ),
        bottomNavigationBar: Provider.of<HomeVM>(context, listen: false)
            .bottomNavigationBar(context, pageIndex, homepagecontroller));
  }
}
