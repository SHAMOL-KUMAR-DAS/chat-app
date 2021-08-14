import 'package:chatting_app/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chatting extends StatefulWidget {
  @override
  _ChattingState createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {
  String _message;
  Firestore firestore = Firestore.instance;

  FirebaseUser user;
  Future<void> getUserData() async {
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userData;
      print(userData.email);
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3d403d),
      appBar: AppBar(
        backgroundColor: Color(0xFF3d403d),
        elevation: 0,
        title: Center(
            child: Text(
          "Chat Page",
          style: TextStyle(color: Colors.white),
        )),
        actions: [
          FlatButton(
              onPressed: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Sign_in()));
                });
              },
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        StreamBuilder(
            stream: Firestore.instance.collection('chat').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Text('Loading...');
              }
              return ListView(
                  shrinkWrap: true,
                  children: snapshot.data.documents.map((document) {
                    return ListTile(
                        title: Text(
                          document['Message'] ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          document['email'] ?? '',
                          style: TextStyle(color: Colors.white),
                        ));
                  }).toList());
            }),
        SizedBox(height: MediaQuery.of(context).size.height * 0.5),
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
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: "Type your message",
                    hintStyle: TextStyle(color: Colors.white),
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
                onPressed: () {
                  setState(() {
                    firestore.collection('chat').add({
                      'Message': _message,
                      'email': user.email,
                    });
                  });
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
