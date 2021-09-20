import 'package:chatting_app/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'database.dart';

class User_Info extends StatefulWidget {
  String _email;
  User_Info(this._email);
  @override
  _User_InfoState createState() => _User_InfoState(this._email);
}

class _User_InfoState extends State<User_Info> {
  String _email;
  _User_InfoState(this._email);

  String _fname, _lname, _address,_mobile;

  final CollectionReference brewcollection = Firestore.instance.collection('chat');
  String uid;


  Future<void> sendData()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await DataBaseUserService(uid: user.uid).UpdateUserData(
      _fname, _lname, _address, _mobile, this._email,
    );
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Sign_in()));
  }

  sendImage() async {
    var storageImage = FirebaseStorage.instance.ref().child(_image.path);
    var task = storageImage.putFile(_image);
    String imgurl = await (await task.onComplete).ref.getDownloadURL();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await DataBaseUserService(uid: user.uid).updateuserimage(imgurl);
  }
  File _image;
  Future cameraImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  Future galleryImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFfff5f5),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Create Your Profile",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: _image == null? Text(""):Image.file(_image),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: (){
                        cameraImage();
                      },
                      child: Icon(Icons.camera_alt_outlined),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
                    FloatingActionButton(
                      onPressed: (){
                        galleryImage();
                      },
                      child: Icon(Icons.photo_library_outlined),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "First Name",
                        hintText: "Mr. Abdul"),
                    onChanged: (input){
                      setState(() {
                        _fname=input;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "Last Name",
                        hintText: "Kuddus"),
                    onChanged: (input){
                      setState(() {
                        _lname=input;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: "Address",
                        hintText: "Kampala Uganda"),
                    onChanged: (input){
                      setState(() {
                        _address=input;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration:
                    InputDecoration(
                        labelText: "Mobile No",
                        hintText: "01x10203040"
                    ),
                    onChanged: (input){
                      setState(() {
                        _mobile=input;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                FlatButton(
                    color: Color(0xFFff503d),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    onPressed: () {
                      sendData();
                      sendImage();
                    },
                    child: Text("Save Information",style: (TextStyle(color: Colors.white,fontSize: 18)),))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
