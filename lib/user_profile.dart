import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User_Profile extends StatefulWidget {
  String receiverImage, receiverEmail, receiver;
  User_Profile(this.receiverImage, this.receiverEmail, this.receiver);
  @override
  _User_ProfileState createState() => _User_ProfileState();
}

class _User_ProfileState extends State<User_Profile> {

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
              radius: 120,
              backgroundImage: widget.receiverImage != null ? NetworkImage(widget.receiverImage) : AssetImage('assets/images/blue.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(widget.receiver,style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900
              ),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(widget.receiverEmail,style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
              ),),
            )
          ],
        ),
      ),
    );
  }
}
