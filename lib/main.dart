import 'package:chatting_app/all_users.dart';
import 'package:chatting_app/auth.dart';
import 'package:chatting_app/Signing/sign_in.dart';
import 'package:chatting_app/chatpage.dart';
import 'package:chatting_app/login_profile.dart';
import 'package:chatting_app/otp_verification.dart';
import 'package:chatting_app/user_info.dart';
import 'package:flutter/material.dart';
import 'package:chatting_app/splash.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.solwayTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.teal,
      ),
      home:
      FutureBuilder(
          future: AuthMethods().getCurrentUser(),
          builder: (context, AsyncSnapshot<dynamic> snapshot){
            if(snapshot.hasData){
              return All_Users();
            } else{
              return Sign_in();
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }
}