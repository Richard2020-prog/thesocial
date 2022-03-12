import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Constants/Constantcolors.dart';
import 'package:thesocial/Screens/Feed/feedVM.dart';

class FeedScreen extends StatefulWidget {
  // const FeedScreen({ Key? key }) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: Provider.of<FeedVM>(context, listen: false).appBar(context),
      body: Provider.of<FeedVM>(context, listen: false).feedBody(context),
    );
  }
}
