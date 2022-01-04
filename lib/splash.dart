import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatting_app/Configure/config_color.dart';
import 'package:chatting_app/Signing/sign_in.dart';
import 'package:chatting_app/all_users.dart';
import 'package:chatting_app/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimatedSplashScreen extends StatefulWidget {

  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  SharedPreferences prefs;

  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  // startTime() async {
  //   var _duration = new Duration(seconds: 3);
  //   return Timer(_duration, _loadUserInfo);
  // }
  //
  // _loadUserInfo() async {

  // }
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Sign_in()), (route) => false);
        // FutureBuilder(
        //     future: AuthMethods().getCurrentUser(),
        //     builder: (context, AsyncSnapshot<dynamic> snapshot){
        //       if(snapshot.hasData){
        //         //return All_Users();
        //         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => All_Users()), (route) => false);
        //       } else{
        //         //return Sign_in();
        //         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Sign_in()), (route) => false);
        //       }
        //     });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          new Image.asset(
            'assets/images/splash.png',
          ),
          Spacer(),
          WavyAnimatedTextKit(
            textStyle: TextStyle(
                fontSize: 23,
                color: colors,
                fontWeight: FontWeight.w400
            ),
            text: ["Shamol Chatting App"],
            isRepeatingAnimation: true,
          ),
          Spacer(),
        ],
      ),
    );
  }
}