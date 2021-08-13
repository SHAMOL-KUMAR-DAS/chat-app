import 'package:chatting_app/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Sign_up extends StatefulWidget {
  @override
  _Sign_upState createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> {

  String _cemail, _cpassword;
  final GlobalKey<FormState> _cformkey=GlobalKey<FormState>();

  Future<void> Sign_Up()async{
    final cformkey=_cformkey.currentState;

    if(cformkey.validate()){
      cformkey.save();
      try{
        FirebaseUser newuser=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _cemail, password: _cpassword);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Sign_in()));
      }catch(e){
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _cformkey,
        child: Center(
        child: Card(
          elevation: 25,
          color: Color(0xFF21eb57),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                //NetworkImage(url)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Text(
                  "Create Your Account",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30,right: 30),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "E-Mail"),
                    onSaved: (input){
                      setState(() {
                        _cemail=input;
                      });
                    },
                    validator: (input){
                      if(input.isEmpty){
                        return "Please Enter an E-Mail";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.04,),
                Padding(
                  padding: const EdgeInsets.only(left: 30,right: 30),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Password"),
                    onSaved: (input){
                      setState(() {
                        _cpassword=input;
                      });
                    },
                    validator: (input){
                      if(input.length<6){
                        return "Please Enter a Password more than 5";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                FlatButton(
                    color: Colors.white,
                    minWidth: MediaQuery.of(context).size.width * 0.5,
                    onPressed: () {
                      setState(() {
                        Sign_Up();
                      });
                    },
                    child: Text("Create Account")),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
