import 'package:chatting_app/Configure/config_button.dart';
import 'package:chatting_app/Configure/config_color.dart';
import 'package:chatting_app/user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OTPVerification extends StatefulWidget {

  String _email;
  OTPVerification(this._email);

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {

  final TextEditingController _otpController = TextEditingController();

  void verifyOTP()async{
    var res = EmailAuth.validate(receiverMail: widget._email, userOTP: _otpController.text);
    if(res){
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>User_Info(widget._email)));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>User_Info(widget._email)), (route) => false);
    }else{
      showDialog(context: context, builder: (BuildContext context) {
        return  AlertDialog(
          title:  Text("Invalid OTP"),
          content:  Text("Please Type Valid OTP"),
        );
      }
      );
    }
  }

  final FocusNode _pinFocus = FocusNode();
  BoxDecoration pinOtpDecoration = BoxDecoration(
    color: colors,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: Colors.grey
    )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Center(
        child: Container(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: PinPut(
            fieldsCount: 6,
            textStyle: TextStyle(fontSize: 25, color: Colors.white),
            eachFieldWidth: 40.0,
            eachFieldHeight: 50.0,
            focusNode: _pinFocus,
            controller: _otpController,
            submittedFieldDecoration: pinOtpDecoration,
            selectedFieldDecoration: pinOtpDecoration,
            followingFieldDecoration: pinOtpDecoration,
            pinAnimationType: PinAnimationType.rotation,
            autovalidateMode: AutovalidateMode.always,
            onSubmit: (otp)async{
              verifyOTP();
            },
          ),
        ),
      ),

    );
  }
}
