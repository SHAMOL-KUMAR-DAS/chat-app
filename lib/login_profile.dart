import 'package:chatting_app/all_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login_Profile extends StatefulWidget {
  String imageurl, fname, address, gmail, mobile;
  Login_Profile(this.imageurl, this.fname, this.address, this.gmail, this.mobile);
  @override
  _Login_ProfileState createState() => _Login_ProfileState();
}

class _Login_ProfileState extends State<Login_Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius:120,
              backgroundImage: NetworkImage(widget.imageurl),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(widget.fname,style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900
              ),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(widget.gmail,style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
              ),),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 10),
            //   child: Text(widget.address,style: TextStyle(
            //       fontSize: 20,
            //       fontWeight: FontWeight.w500
            //   ),),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 10),
            //   child: Text(widget.mobile,style: TextStyle(
            //       fontSize: 20,
            //       fontWeight: FontWeight.w500
            //   ),),
            // )
          ],
        ),
      ),
    );
  }
}
