import 'package:chatting_app/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Sign_up extends StatefulWidget {
  @override
  _Sign_upState createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> {

  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _otpController = TextEditingController();
  //
  // void sendOTP() async {
  //   EmailAuth.sessionName = 'Test Session';
  //   var res = await EmailAuth.sendOtp(receiverMail: _emailController.text);
  //   if(res){
  //     print('OTP Sent');
  //   }else{
  //     print('We could not send the OTP');
  //   }
  // }
  //
  // void verifyOTP()async{
  //   var res = EmailAuth.validate(receiverMail: _emailController.text, userOTP: _otpController.text);
  //   if(res){
  //     print('OTP Verified');
  //   }else{
  //     print('Invalid OTP');
  //   }
  // }

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

  bool hidenpass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Stay With Sign Up",
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _cformkey,
          child: Center(
          child: Column(
            children: [
              Image(image: AssetImage('assets/images/sign.png')),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.05,
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 30,right: 30),
                child: TextFormField(
                  //controller: _emailController,
                  decoration: InputDecoration(
                      hintText: "E-Mail",
                    // suffixIcon: TextButton(
                    //   child: Text("Send OTP"),
                    //   onPressed: (){
                    //     sendOTP();
                    //   },
                    // )
                  ),
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
              // Padding(
              //   padding: const EdgeInsets.only(left: 30,right: 30),
              //   child: TextFormField(
              //     //obscureText: hidenpass,
              //     controller: _otpController,
              //     decoration: InputDecoration(
              //         hintText: "OTP",
              //         // suffixIcon: InkWell(
              //         //   onTap: _togglePassView,
              //         //   child: Icon(Icons.visibility),
              //         // )
              //     ),
              //     onTap: (){
              //       verifyOTP();
              //     },
              //     // onSaved: (input){
              //     //   setState(() {
              //     //     _cpassword=input;
              //     //   });
              //     // },
              //     // validator: (input){
              //     //   if(input.length<6){
              //     //     return "Please Enter a Password more than 5";
              //     //   }
              //     //   return null;
              //     // },
              //   ),
              // ),
              // FlatButton(
              //     color: Colors.red,
              //     minWidth: MediaQuery.of(context).size.width * 0.5,
              //     onPressed: () {
              //       setState(() {
              //         Sign_Up();
              //       });
              //     },
              //     child: Text("Verify OTP")),
              // SizedBox(height: MediaQuery.of(context).size.height*0.04,),
              Padding(
                padding: const EdgeInsets.only(left: 30,right: 30),
                child: TextFormField(
                  obscureText: hidenpass,
                  decoration: InputDecoration(
                      hintText: "Password",
                    suffixIcon: InkWell(
                      onTap: _togglePassView,
                      child: Icon(Icons.visibility),
                    )
                  ),
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
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              FlatButton(
                  color: Colors.red,
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
    );
  }
  void _togglePassView(){
    if(hidenpass == true){
      hidenpass = false;
    }else{
      hidenpass = true;
    }
    setState(() {
      
    });
  }
}
