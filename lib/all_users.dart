import 'package:chatting_app/auth.dart';
import 'package:chatting_app/chatpage.dart';
import 'package:chatting_app/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';
import 'login_profile.dart';

class All_Users extends StatefulWidget {
  @override
  _All_UsersState createState() => _All_UsersState();
}
String fname, lname, address, gmail, imageurl, mobile;
_fetch()async{
  final firebaseUser = await FirebaseAuth.instance.currentUser();
  if(firebaseUser!=null)
    await Firestore.instance.collection('chat').document(firebaseUser.uid).get().then((ds){
      fname=ds.data['First_Name'];
      lname = ds.data['Last_Name'];
      address=ds.data['Address'];
      gmail=ds.data['E-Mail'];
      imageurl = ds.data['Image'];
      mobile = ds.data['Mobile'];

    }).catchError((e){
      print(e);
    });
}

class _All_UsersState extends State<All_Users> {
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
        leading: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Login_Profile(imageurl,fname,address,gmail,mobile)));
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 5,left: 5),
            child: FutureBuilder(
              future: _fetch(),
              builder: (context,snapshot){
                if(snapshot.connectionState!= ConnectionState.done)
                  return Text("",style: TextStyle(color: Colors.white),);
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 22.0,
                      backgroundImage: NetworkImage(imageurl),
                    ),

                  ],
                );
              },
            ),
          ),
        ),
        title: Center(child: Text('Messaging')),
        actions: [
          FlatButton(
              onPressed: (){
                //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Sign_in()), (route) => false);
                AuthMethods().signOut().then((s){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Sign_in()),result: (route) => false);
                });
              },
              child: Icon(Icons.logout,color: Colors.white,))],
      ),
      body:
      Column(
        children: [
          // Container(
          //   height: MediaQuery.of(context).size.height * 0.05,
          //   margin: EdgeInsets.all(10),
          //   padding: EdgeInsets.symmetric(horizontal: 20),
          //   decoration: BoxDecoration(
          //     border: Border.all(
          //       color: Colors.grey,
          //       width: 2.5,
          //       style: BorderStyle.solid,
          //     ),
          //     borderRadius: BorderRadius.circular(25)
          //   ),
          //   child: Row(
          //     children: [
          //       Expanded(
          //           child: TextFormField(decoration: InputDecoration(
          //         hintText: "Search User",
          //         border: InputBorder.none
          //         //labelText: "Search",
          //       ),)),
          //       Icon(Icons.search)
          //     ],
          //   ),
          // ),
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
                          //print('Shamol Kumar ${fname}');
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
                                    //print(user.uid);
                                    //if(document[''])
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => Chatting(userid,document['Image'],document['First_Name'],user.uid,user.email,document['E-Mail'],user.photoUrl)));
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
        ],
      ),
    );
  }
}
