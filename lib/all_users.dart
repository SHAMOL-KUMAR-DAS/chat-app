import 'package:chatting_app/Configure/config_color.dart';
import 'package:chatting_app/auth.dart';
import 'package:chatting_app/chatpage.dart';
import 'package:chatting_app/Signing/sign_in.dart';
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
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: colors,
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
                      //backgroundImage: NetworkImage(imageurl),
                      backgroundImage: imageurl != null ? NetworkImage(imageurl) : AssetImage('assets/images/blue.png'),
                    ),

                  ],
                );
              },
            ),
          ),
        ),
        title: Text('Messaging'),
        centerTitle: true,
        actions: [
          FlatButton(
              onPressed: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Sign_in()), (route) => false);
              },
              child: Icon(Icons.logout,color: Colors.white,))],
      ),
      body: StreamBuilder(
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
                      if (user.email == document['E-Mail']) {
                        return Container(
                          height: 0,
                          width: 0,
                        );
                      }
                      else {
                        //print(document['E-Mail']);
                        return ListTile(
                          title: FlatButton(
                            onPressed: () {
                              String userid = document.documentID;
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

                                Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 5),
                                  child: Text(
                                    document['First_Name'] ?? '',
                                    style: TextStyle(color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),

                                Text(
                                  document['Last_Name'] ?? '',
                                  style: TextStyle(color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
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
