
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:chatting_app/sign_in.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      // image: Image(image: NetworkImage("https://media.istockphoto.com/photos/lot-of-people-figures-and-comment-clouds-above-their-heads-the-of-picture-id1155407883?s=612x612"),
      //   height: MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context).size.width,),
      seconds: 03,
      navigateAfterSeconds: Sign_in(),
      loadingText: Text("Welcome to Excel IT AI Chatting App"),

    );
  }
}
