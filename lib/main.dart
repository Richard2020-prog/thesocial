import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Constants/Constantcolors.dart';
import 'package:thesocial/Screens/AltProfile/altProfileVM.dart';
import 'package:thesocial/Screens/Chatroom/chatVM.dart';
import 'package:thesocial/Screens/Feed/feedVM.dart';
import 'package:thesocial/Screens/HomePage/homeVM.dart';
import 'package:thesocial/Screens/LandingPage/landingVM.dart';
import 'package:thesocial/Screens/LandingPage/landing_service.dart';
import 'package:thesocial/Screens/LandingPage/landing_utils.dart';
import 'package:thesocial/Screens/Messages/messagesVM.dart';
import 'package:thesocial/Screens/Profile/profileVM.dart';
import 'package:thesocial/Screens/splash_screen.dart';
import 'package:thesocial/Services/auth_services.dart';
import 'package:thesocial/Services/firebaseOperations_services.dart';
import 'package:thesocial/Services/uploadPost_service.dart';
import 'package:thesocial/Utils/postOperations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        child: MaterialApp(
          title: 'theSocial',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              accentColor: constantColors.blueColor,
              fontFamily: 'Poppins',
              canvasColor: Colors.transparent),
          home: SplashScreen(),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => LandingVM()),
          ChangeNotifierProvider(create: (_) => AuthServiceVM()),
          ChangeNotifierProvider(create: (_) => LandingService()),
          ChangeNotifierProvider(create: (_) => LandingUtils()),
          ChangeNotifierProvider(create: (_) => FirebaseOperations()),
          ChangeNotifierProvider(create: (_) => HomeVM()),
          ChangeNotifierProvider(create: (_) => ProfileVM()),
          ChangeNotifierProvider(create: (_) => FeedVM()),
          ChangeNotifierProvider(create: (_) => UploadPostVM()),
          ChangeNotifierProvider(create: (_) => PostOperations()),
          ChangeNotifierProvider(create: (_) => AltProfileVM()),
          ChangeNotifierProvider(create: (_) => ChatVM()),
          ChangeNotifierProvider(create: (_) => MessagesVM()),
        ]);
  }
}
