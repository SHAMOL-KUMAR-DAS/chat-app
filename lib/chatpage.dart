import 'dart:math';

import 'package:chatting_app/CALL/call_utilities.dart';
import 'package:chatting_app/CALL/permissions.dart';
import 'package:chatting_app/Configure/config_color.dart';
import 'package:chatting_app/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  getMyInfo() async {
    chatRoomId = getChatRoomId(widget.myuid, widget.receiveruid);
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
  @override
  void initState() {
    doThisLaunch();
    super.initState();
  }

  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: colors,

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
                width: size.width * 0.02,
              ),
              Text(widget.receiver),
            ],
          ),
        ),
        actions: [
          FlatButton(
              onPressed: () async{
                var callChannelName = Random().nextInt(100000).toString();

                await Permissions.cameraAndMicrophonePermissionsGranted()
                    ? CallUtils.dial(
                    currUserId: widget.receiveruid  ,
                    currUserName: widget.userEmail.replaceAll('@gmail.com', ''),
                    receiverId: widget.myuid,
                    receiverName: widget.receiver,
                    channelName: callChannelName,
                    tokenId: 'callToken',
                    context: context) : {};
              },
              child: Image(image: AssetImage('assets/images/video_call.png'),height: 20,color: Colors.white,)
          )
        ],
      ),
      body: Column(children: [
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
                                            ? colors
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
                                  Text(DateFormat.yMd().add_jm().format(document['messageTime'].toDate()),style: TextStyle(fontSize: 8),)
                                ],
                              ),
                            ),
                          ]);
                    }).toList());
            }),
      ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: size.height * 0.06,
                padding: EdgeInsets.only(left: 10, right: 25, bottom: 10),
                child: TextFormField(
                  controller: _message,
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    fillColor: textFormColor,
                    filled: true,
                    contentPadding: EdgeInsets.only(left: 20, top: 1, bottom: 1),
                    hintText: "Type your message",
                    hintStyle: TextStyle(color: Colors.black,fontSize: 12),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(
                              color: colors,
                              width: 1
                          ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: colors,
                        width: 1,
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
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 10,right: 15),
              child: GestureDetector(
                onTap: () async {
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
                  color: colors,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
  Widget timeView(time) {
    return Text(DateFormat.yMMMd().add_jm().format(time),
        style: TextStyle(fontSize: 6));
  }
}
