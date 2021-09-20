import 'package:chatting_app/call_index.dart';
import 'package:chatting_app/login_profile.dart';
import 'package:chatting_app/sign_in.dart';
import 'package:chatting_app/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import './call.dart';

import 'database.dart';

class Chatting extends StatefulWidget {
  String myuid,
      receiverImage,
      receiver,
      receiveruid,
      userEmail,
      receiverEmail,
      userImage;
  Chatting(this.myuid, this.receiverImage, this.receiver, this.receiveruid,
      this.userEmail, this.receiverEmail, this.userImage);
  @override
  _ChattingState createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {
  String chatRoomId, messageId = '';
  TextEditingController _message = TextEditingController();

  // ScrollController _scrollController = ScrollController();
  //
  // _scrollToBottom() {
  //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);}

  getMyInfo() async {
    chatRoomId = getChatRoomId(widget.receiveruid, widget.myuid);
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  getAndSetMessages() async {}
  doThisLaunch() async {
    await getMyInfo();
    getAndSetMessages();
  }

  final _channelController = 'connect';
  bool _validateError = false;
  ClientRole _role = ClientRole.Broadcaster;

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.isNotEmpty) {
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.notification);
      await _handleCameraAndMic(Permission.microphone);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: _channelController,
            role: _role,
          ),
        ),
      );
    }
  }
  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  @override
  void initState() {
    doThisLaunch();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      appBar: AppBar(
        backgroundColor: Color(0xFFc25d15),
        elevation: 0,
        title: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>User_Profile(widget.receiverImage, widget.receiverEmail, widget.receiver)));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: widget.receiverImage != null ? NetworkImage(widget.receiverImage) : AssetImage('assets/images/blue.png'),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.015,
              ),
              Text(widget.receiver),
            ],
          ),
        ),
        actions: [
          FlatButton(
              onPressed: () {
                onJoin();
                setState(() {
                  //print(widget.userimage);
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => Call_Index()),
                  //     (route) => false);
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>Call_Index()));
                  //_role = value;
                });
              },
              child: Icon(
                Icons.video_call_outlined,
                color: Colors.white,
              ))
        ],
      ),
      body: Container(
          child: Column(children: [
        Expanded(
          child: Container(
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('chatRooms')
                    .document(chatRoomId)
                    .collection('Messages')
                    .orderBy('messageTime', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Loading...');
                  } else
                    return ListView(
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        children: snapshot.data.documents.map((document) {
                          return Column(
                              crossAxisAlignment:
                                  widget.userEmail != document['senderEmail']
                                      ? CrossAxisAlignment.start
                                      : CrossAxisAlignment.end,
                              children: [
                                // CircleAvatar(
                                //   radius: 20,
                                //   backgroundImage: NetworkImage(document['receiverImage']??''),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: widget.userEmail !=
                                                    document['senderEmail']
                                                ? Colors.blue.shade500
                                                : Color(0xFF3d403d)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                document['Message'] ?? '',
                                                style:
                                                    TextStyle(color: Colors.white,fontSize: 15),

                                              ),
                                              //Text(DateFormat.yMMMd().add_jm().format(document['messageTime'].toDate()),)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Text(DateFormat.yMd().add_jm().format(document['messageTime'].toDate()),)
                                    ],
                                  ),
                                ),
                              ]);
                        }).toList());
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 5),
          child: Container(
            //height: MediaQuery.of(context).size.height * 0.06,
            //width: 1500,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _message,
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: "Type your message",
                      hintStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide:
                            BorderSide(color: Colors.black, width: 3.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 3.0,
                        ),
                      ),
                    ),
                    // onChanged: (input) {
                    //   setState(() {
                    //     _message = input;
                    //   });
                    // },
                  ),
                ),
                FlatButton(
                  onPressed: () async {
                    FirebaseUser user =
                        await FirebaseAuth.instance.currentUser();
                    Firestore.instance
                        .collection('chatRooms')
                        .document(chatRoomId)
                        .collection('Messages')
                        .document()
                        .setData({
                      'Message': _message.text,
                      //'receiverImage': widget.receiverImage,
                      //'senderImage': widget.userImage,
                      'senderEmail': widget.userEmail,
                      'receiverEmail': widget.receiverEmail,
                      'messageTime': DateTime.now(),
                    }).then((value) => _message.text = '');
                  },
                  child: Icon(
                    Icons.send,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        )
      ])),
    );
  }
  Widget timeView(time) {
    return Text(DateFormat.yMMMd().add_jm().format(time),
        style: TextStyle(fontSize: 8));
  }
}
