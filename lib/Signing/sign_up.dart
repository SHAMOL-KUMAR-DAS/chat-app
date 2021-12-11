import 'package:chatting_app/Configure/config_button.dart';
import 'package:chatting_app/Configure/config_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';

import '../otp_verification.dart';

class Sign_up extends StatefulWidget {
  @override
  _Sign_upState createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> {

  var password = TextEditingController();
  var repassword = TextEditingController();

  var _emailController = TextEditingController();
  //final TextEditingController _otpController = TextEditingController();

  void sendOTP() async {
    EmailAuth.sessionName = 'Shamol Kumar Das Chatting App';
    if (RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$').hasMatch(password.text) && password.text == repassword.text) {
      var res = await EmailAuth.sendOtp(receiverMail: _emailController.text);
    if (res) {
      print('Sent OTP Successfully');
    } else {
      showDialog(context: context, builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Please Enter Valid E-Mail"),
        );
      }
      );
    }
  }
    else if(_emailController.text.isEmpty){
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text('Please Enter an Email'),
        );
      });
    }
    else if (password.text.isEmpty) {
      showDialog(context: context, builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Please Enter Password"),
        );
      }
      );
    }
    else if (password.text.isEmpty) {
      showDialog(context: context, builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Please Enter Re-Type Password"),
        );
      }
      );
    }
    else if(!RegExp(r'^.{6,}$').hasMatch(password.text)){
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text('Enter Your Password more than 5 Characters'),
        );
      });
    }
    else if(!RegExp(r'^(?=.*?[A-Z])').hasMatch(password.text)){
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text('Enter an Upper Case'),
        );
      });
    }
    else if(!RegExp(r'^(?=.*?[a-z])').hasMatch(password.text)){
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text('Enter an Lower Case'),
        );
      });
      //print('Enter an Lower Case');
    }
    else if(!RegExp(r'^(?=.*?[0-9])').hasMatch(password.text)){
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text('Enter a Number'),
        );
      });
    }
    else if(!RegExp(r'^(?=.*?[!@#\$&*~])').hasMatch(password.text)){
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter a Special Character'),
        );
      });
    }
    else if (password.text != repassword.text) {
      showDialog(context: context, builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Please Enter Same Password"),
        );
      }
      );
    }
  }

  // void verifyOTP()async{
  //   var res = EmailAuth.validate(receiverMail: _emailController.text, userOTP: _otpController.text);
  //   if(res){
  //     count ++;
  //   }else{
  //     showDialog(context: context, builder: (BuildContext context) {
  //       return new AlertDialog(
  //         title: new Text("Invalid OTP"),
  //         content: new Text("Please Type Valid OTP"),
  //       );
  //     }
  //     );
  //   }
  // }

  final GlobalKey<FormState> _cformkey=GlobalKey<FormState>();
  Future<void> Sign_Up()async{
    final cformkey=_cformkey.currentState;
    if(cformkey.validate()){
      cformkey.save();
      try {
        if (RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$').hasMatch(password.text) && password.text == repassword.text) {
          FirebaseUser newuser = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
              email: _emailController.text, password: password.text);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OTPVerification(_emailController.text)));
        }
      }
      catch(e){
        print(e.message);
        if(e.message == 'The email address is already in use by another account.'){
          showDialog(context: context, builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text("The E-Mail Address is Already in Use"),
            );
          }
          );
        }
      }
    }
  }

  bool hidenpass = true;
  void _togglePassView(){
    setState(() {
      hidenpass = !hidenpass;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backColor,

        body: Container(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //Image
                Image(image: AssetImage('assets/images/sign.png'),height: 250,),

                //Email
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: [AutofillHints.email],
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      fillColor: textFormColor,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                      hintText: "Please Enter Email",
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail_outline),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: backColor
                        ),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          width: 1,
                          color: colors
                        )
                      )
                    ),
                    validator: (input){
                      if(input.isEmpty){
                        return "Please Enter an E-Mail";
                      }
                      return null;
                    },
                  ),
                ),

                //Password
                Form(
                  key: _cformkey,
                  child: TextFormField(
                    controller: password,
                    obscureText: hidenpass,
                    autofillHints: [AutofillHints.password],
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      fillColor: textFormColor,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                      labelText: 'Password',
                      hintText: "Please Enter Password",
                      prefixIcon: Icon(Icons.lock_outline),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: backColor
                        ),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: colors
                        ),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      suffixIcon: InkWell(
                        //onTap: VisiblePassword,
                        onTap: _togglePassView,
                        child: hidenpass? Icon(Icons.visibility_off):Icon(Icons.visibility),
                      ),
                    ),
                  ),
                ),

                //RePassword
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 30),
                  child: TextFormField(
                    controller: repassword,
                    obscureText: hidenpass,
                    autofillHints: [AutofillHints.password],
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      fillColor: textFormColor,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                      prefixIcon: Icon(Icons.lock_outline),
                      labelText: 'Confirm Password',
                      hintText: "Re Type Password",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: backColor
                        ),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: colors
                        ),
                        borderRadius: BorderRadius.circular(15)
                      ),
                    ),
                    validator: (input) {
                      if (input.length<6) {
                        showDialog(context: context, builder: (BuildContext context) {
                          return new AlertDialog(
                            title: new Text("Your Password is too Small"),
                            content: Text('Enter Password more than 5'),
                          );
                        }
                        );
                      }
                      return null;
                    },
                  ),
                ),

                //Create Account
                ButtonConfig(
                  text: 'Create Account',
                  press: (){
                    Sign_Up();
                    sendOTP();
                  },
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
