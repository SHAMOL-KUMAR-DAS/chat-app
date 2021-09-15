import 'package:chatting_app/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';

class Chatting extends StatefulWidget {
  String userid, sender, senderuid;
  Chatting(this.userid, this.sender, this.senderuid);
  @override
  _ChattingState createState() => _ChattingState(this.userid, this.sender, this.senderuid);
}

class _ChattingState extends State<Chatting> {
  String _message;
  String userid, sender, senderuid;
  _ChattingState(this.userid, this.sender, this.senderuid);

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3d403d),
      appBar: AppBar(
        backgroundColor: Color(0xFF3d403d),
        elevation: 0,
        actions: [
          FlatButton(
              onPressed: () {
                setState(() {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Sign_in()), (route) => false);
                });
              },
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
              children: [
        StreamBuilder(
            stream: Firestore.instance.collection('chat').document(userid).collection('Message').document(senderuid
            ).collection('Individual').orderBy('messageTime', descending: false).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Text('Loading...');
              } else
              return ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: snapshot.data.documents.map((document) {
                    return ListTile(
                        title: Text(
                          document['Message'] ?? '',
                          style: TextStyle(color: Colors.white),
                        ),);
                  }).toList());
            }),
                StreamBuilder(
                    stream: Firestore.instance.collection('chat').orderBy('messageTime', descending: false).snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Text('Loading...');
                      } else
                        return ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: snapshot.data.documents.map((document) {
                              return ListTile(
                                title: Text(
                                  document['Message'] ?? '',
                                  style: TextStyle(color: Colors.white),
                                ),);
                            }).toList());
                    }),
      ])),
      bottomSheet: Container(
        color: Color(0xFF3d403d),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Center(
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: "Type your message",
                    hintStyle: TextStyle(color: Color(0xFFe5ff00)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white, width: 3.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 3.0,
                      ),
                    ),
                  ),
                  onChanged: (input) {
                    setState(() {
                      _message = input;
                    });
                  },
                ),
              ),
            ),
            FlatButton(
                onPressed: () async{
                  FirebaseUser user = await FirebaseAuth.instance.currentUser();
                  // Firestore.instance.collection('chat').document(userid).collection(user.uid).document().setData(
                  Firestore.instance.collection('chat').document().setData(
                      {
                        'Message': _message,
                        'messageTime': DateTime.now()
                      }).then((value) => null);
                },
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }
}
