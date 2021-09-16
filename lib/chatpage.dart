import 'package:chatting_app/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';

class Chatting extends StatefulWidget {
  String myuid, receiverImage, receiver, receiveruid, userEmail, receiverEmail, userImage;
  Chatting(this.myuid, this.receiverImage, this.receiver, this.receiveruid, this.userEmail, this.receiverEmail, this.userImage);
  @override
  _ChattingState createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {

  String chatRoomId, messageId = '',_message;
  getMyInfo()async{
    chatRoomId = getChatRoomId(widget.receiveruid, widget.myuid);
  }
  getChatRoomId(String a, String b){
    if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
      return "$b\_$a";
    }else{
      return "$a\_$b";
    }
  }
  getAndSetMessages() async{}
  doThisLaunch() async{
    await getMyInfo();
    getAndSetMessages();
  }
  @override
  void initState(){
    doThisLaunch();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      appBar: AppBar(
        backgroundColor: Color(0xFFc25d15),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(widget.receiverImage),),
            SizedBox(width: MediaQuery.of(context).size.width * 0.015,),
            Text(widget.receiver),
          ],
        ),
        actions: [
          FlatButton(
              onPressed: () {
                setState(() {
                  //print(widget.userimage);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Sign_in()),
                      (route) => false);
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
            stream: Firestore.instance
                .collection('chatRooms')
                .document(chatRoomId)
                .collection('Messages')
                .orderBy('messageTime', descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Text('Loading...');
              } else
                return ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: snapshot.data.documents.map((document) {
                      return Column(
                        crossAxisAlignment: widget.userEmail != document['senderEmail']?
                          CrossAxisAlignment.start : CrossAxisAlignment.end,
                        children: [

                          // CircleAvatar(
                          //   radius: 20,
                          //   backgroundImage: NetworkImage(document['receiverImage']??''),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: widget.userEmail != document['senderEmail']
                                    ? Colors.blue.shade500
                                    : Color(0xFF3d403d)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  document['Message'] ?? '',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        // subtitle: Text(
                        //   document['messageTime'] ?? '',
                        //   style: TextStyle(
                        //     color: Colors.white
                        //   ),
                        // ),
                      ]
                      );
                    }).toList());
            }),
      ])),
      bottomSheet:
        Padding(
          padding: const EdgeInsets.only(bottom: 10,left: 5),
          child: Container(
            //height: MediaQuery.of(context).size.height * 0.06,
            //width: 1500,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Type your message",
                    hintStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.black, width: 3.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 3.0,
                      ),
                    ),
                  ),
                  onChanged: (input) {
                    setState(() {
                      _message = input;
                    });
                  },
                ),),
                FlatButton(
                onPressed: () async {
                  FirebaseUser user = await FirebaseAuth.instance.currentUser();
                  Firestore.instance
                      .collection('chatRooms')
                      .document(chatRoomId)
                      .collection('Messages')
                      .document()
                      .setData(
                          {
                            'Message': _message,
                            'receiverImage': widget.receiverImage,
                            'senderImage': widget.userImage,
                            'senderEmail': widget.userEmail,
                            'receiverEmail': widget.receiverEmail,
                            'messageTime': DateTime.now(),

                            //'senderImage': widget.
                      }).then((value) => null);
                },
                child: Icon(
                  Icons.send,
                  color: Colors.black,
                ))
              ],
            ),
          ),
        )
      // Container(
      //   color: Color(0xFFffffff),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       SizedBox(
      //         width: MediaQuery.of(context).size.width * 0.02,
      //       ),
      //       Container(
      //         height: MediaQuery.of(context).size.height * 0.05,
      //         width: MediaQuery.of(context).size.width * 0.75,
      //         child: TextFormField(
      //           style: TextStyle(color: Colors.black),
      //           cursorColor: Colors.black,
      //           decoration: InputDecoration(
      //             hintText: "Type your message",
      //             hintStyle: TextStyle(color: Colors.black),
      //             focusedBorder: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(25.0),
      //               borderSide: BorderSide(color: Colors.black, width: 3.0),
      //             ),
      //             enabledBorder: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(25.0),
      //               borderSide: BorderSide(
      //                 color: Colors.black,
      //                 width: 3.0,
      //               ),
      //             ),
      //           ),
      //           onChanged: (input) {
      //             setState(() {
      //               _message = input;
      //             });
      //           },
      //         ),
      //       ),
      //       FlatButton(
      //           onPressed: () async {
      //             FirebaseUser user = await FirebaseAuth.instance.currentUser();
      //             Firestore.instance
      //                 .collection('chatRooms')
      //                 .document(chatRoomId)
      //                 .collection('Messages')
      //                 .document()
      //                 .setData(
      //                     {
      //                       'Message': _message,
      //                       'receiverImage': widget.receiverImage,
      //                       'senderImage': widget.userImage,
      //                       'senderEmail': widget.userEmail,
      //                       'receiverEmail': widget.receiverEmail,
      //                       'messageTime': DateTime.now(),
      //
      //                       //'senderImage': widget.
      //                 }).then((value) => null);
      //           },
      //           child: Icon(
      //             Icons.send,
      //             color: Colors.black,
      //           ))
      //     ],
      //   ),
      // ),
    );
  }
}
