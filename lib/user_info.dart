import 'package:chatting_app/Configure/config_button.dart';
import 'package:chatting_app/Signing/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'Configure/config_color.dart';
import 'database.dart';

class User_Info extends StatefulWidget {
  String _email;
  User_Info(this._email);
  @override
  _User_InfoState createState() => _User_InfoState();
}

class _User_InfoState extends State<User_Info> {

  var fname = TextEditingController();
  var lname = TextEditingController();
  var address = TextEditingController();
  var mobile = TextEditingController();

  final CollectionReference brewcollection = Firestore.instance.collection('chat');
  String uid;


  Future<void> sendData()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await DataBaseUserService(uid: user.uid).UpdateUserData(
      fname.text, lname.text, address.text, mobile.text, widget._email,
    );
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>Sign_in()));
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Sign_in()), (route) => false);
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
        backgroundColor: backColor,
        appBar: AppBar(
          backgroundColor: colors,
          title: Text('Your Information',),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(top: 25, bottom: 25, left: 25, right: 25),
          child: SingleChildScrollView(
            child: Column(
              children: [

                //First Name
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: TextFormField(
                    controller: fname,
                    style: TextStyle(fontSize: 20, color: Color(0xFF777878)),
                    autofillHints: [AutofillHints.name],
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      hintText: 'Enter First Name',
                      fillColor: Color(0xFFffffff),
                      filled: true,
                      labelStyle: TextStyle(fontSize: 16),
                      hintStyle: TextStyle(fontSize: 16),
                      prefixIcon: Icon(Icons.account_circle),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: colors,
                            width: 2
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color(0xFFfffff),
                          width: 2.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.only(top: 10, left: 20),
                      //suffixIcon: name.text.length > 0 ? Icon(Icons.done) : Icon(Icons.pin)
                    ),
                  ),
                ),

                //Last Name
                TextFormField(
                  controller: lname,
                  style: TextStyle(fontSize: 20, color: Color(0xFF777878)),
                  autofillHints: [AutofillHints.name],
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    hintText: 'Enter Last Name',
                    fillColor: Color(0xFFffffff),
                    filled: true,
                    labelStyle: TextStyle(fontSize: 16),
                    hintStyle: TextStyle(fontSize: 16),
                    prefixIcon: Icon(Icons.account_circle),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          color: colors,
                          width: 2
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFFfffff),
                        width: 2.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(top: 10, left: 20),
                    //suffixIcon: name.text.length > 0 ? Icon(Icons.done) : Icon(Icons.pin)
                  ),
                ),

                //Mobile No
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: TextFormField(
                    controller: mobile,
                    style: TextStyle(fontSize: 20, color: Color(0xFF777878)),
                    autofillHints: [AutofillHints.telephoneNumber],
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    autofocus: false,
                    decoration: InputDecoration(
                      counter: Offstage(),
                      labelText: 'Mobile No',
                      hintText: 'Enter Mobile No',
                      fillColor: Color(0xFFffffff),
                      filled: true,
                      labelStyle: TextStyle(fontSize: 16),
                      hintStyle: TextStyle(fontSize: 16),
                      prefixIcon: Icon(Icons.account_circle),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: colors,
                            width: 2
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color(0xFFfffff),
                          width: 2.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.only(top: 10, left: 20),
                      //suffixIcon: name.text.length > 0 ? Icon(Icons.done) : Icon(Icons.pin)
                    ),
                  ),
                ),

                //Address
                TextFormField(
                  controller: address,
                  style: TextStyle(fontSize: 20, color: Color(0xFF777878)),
                  autofillHints: [AutofillHints.name],
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: 'Enter Your Address',
                    fillColor: Color(0xFFffffff),
                    filled: true,
                    labelStyle: TextStyle(fontSize: 16),
                    hintStyle: TextStyle(fontSize: 16),
                    prefixIcon: Icon(Icons.account_circle),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          color: colors,
                          width: 2
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFFfffff),
                        width: 2.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(top: 10, left: 20),
                    //suffixIcon: name.text.length > 0 ? Icon(Icons.done) : Icon(Icons.pin)
                  ),
                ),

                //Image
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 30),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width *0.7,
                    decoration: BoxDecoration(
                      color: Color(0xFFffffff),
                      border: Border.all(
                          width: 1,
                          color: colors
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _image != null ? Stack(
                        children:[
                          Center(child: Image.file(_image,)),
                          Positioned(
                              right: -2,
                              top: -9,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.black.withOpacity(0.5),
                                    size: 18,
                                  ),
                                  onPressed: () => setState(() {
                                    _image = null;
                                  })))
                        ]) :
                    Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 50),
                      child: Column(
                        children: [
                          Text('Select Your Image'),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton(
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  cameraImage();
                                },
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Color(0xFFe37c22),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              FloatingActionButton(
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  galleryImage();
                                },
                                child: Icon(Icons.photo_library_outlined,
                                    color: Color(0xFFe37c22)),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //Save
                ButtonConfig(
                  text: 'Save Information',
                  press: () {
                    if (fname.text != '' && mobile.text != '') {
                      sendData();
                      sendImage();
                    }
                    else if(fname.text == ''){
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: Text('Enter Your First Name'),
                            );
                          }
                      );
                    }
                    else if(mobile.text == ''){
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: Text('Please Enter Your Mobile No'),
                            );
                          }
                      );
                    }
                  }
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
