import 'package:chatting_app/chatpage.dart';
import 'package:chatting_app/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';

class All_Users extends StatefulWidget {
  @override
  _All_UsersState createState() => _All_UsersState();
}

class _All_UsersState extends State<All_Users> {
  String fname,lname,imageurl;

  _fetch()async{
    final firebaseUser = await FirebaseAuth.instance.currentUser();
    if(firebaseUser!=null)
      await Firestore.instance.collection('chat').document().get().then((ds){
        fname=ds.data['First_Name'];
        lname=ds.data['Last_Name'];
        imageurl = ds.data['Image'];
      }).catchError((e){
        print(e);
      });
  }

  FirebaseUser user;
  Future<void> getUserData() async {
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userData;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFe37c22),
      appBar: AppBar(
        backgroundColor: Color(0xFFe37c22),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Center(child: Text('Messaging')),
        actions: [
          FlatButton(
              onPressed: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Sign_in()), (route) => false);
              },
              child: Icon(Icons.logout,color: Colors.white,))],
      ),
      body:
      StreamBuilder(
          stream: Firestore.instance.collection('chat').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Text(
                'Loading...',
                style: TextStyle(color: Colors.white),
              );
            } else {
              return
                ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: snapshot.data.documents.map((document) {
                      // if(user.email != document['E-Mail'] ?? "") {
                      //print(document['E-Mail'] ?? "");
                      // print('Shamol Kumar ${user.email}');
                      if (user.email == document['E-Mail']) {
                        return Container(
                          height: 0,
                          width: 0,
                        );
                      }
                      else {
                        //print(document['E-Mail']);
                        return Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.07,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          //color: Colors.red,
                          child:ListTile(
                            title: FlatButton(
                              onPressed: () {
                                String userid = document.documentID;
                                //if(document[''])
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => Chatting(userid,document['First_Name'],user.uid)));
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage: NetworkImage(
                                        document['Image'] ?? ""
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    document['First_Name'] ?? '',
                                    style: TextStyle(color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(width: 5,),
                                  Text(
                                    document['Last_Name'] ?? '',
                                    style: TextStyle(color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),

                            // FlatButton(
                            //     color: Colors.white,
                            //     shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius
                            //             .circular(20)
                            //     ),
                            //     onPressed: () {
                            //       String userid = document
                            //           .documentID;
                            //       Navigator.push(context,
                            //           MaterialPageRoute(
                            //               builder: (context) =>
                            //                   Order_History(
                            //                       userid)));
                            //     },
                            //     child: Text('Order History'))
                          ),
                        );
                      }
                    }).toList());
            }
          }
      ),
    );
  }
}
