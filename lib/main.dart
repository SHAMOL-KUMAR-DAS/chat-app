import 'package:chatting_app/all_users.dart';
import 'package:chatting_app/auth.dart';
import 'package:chatting_app/splash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Signing/sign_in.dart';

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
              //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => All_Users()), (route) => false);
            } else{
              return Sign_in();
              //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Sign_in()), (route) => false);
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }
}