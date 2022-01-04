import 'package:chatting_app/Configure/config_button.dart';
import 'package:chatting_app/Configure/config_color.dart';
import 'package:chatting_app/all_users.dart';
import 'package:chatting_app/auth.dart';
import 'package:email_auth/email_auth.dart';
import 'package:chatting_app/chatpage.dart';
import 'package:chatting_app/Signing/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class Sign_in extends StatefulWidget {
  @override
  _Sign_inState createState() => _Sign_inState();
}

showLoaderDialog(BuildContext context){
  AlertDialog alert=AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}

class _Sign_inState extends State<Sign_in> {

  var email = TextEditingController();
  var password = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Future<void> SignIn() async {
    final formstate = _formkey.currentState;
    if (formstate.validate()) {
      formstate.save();
      try {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => All_Users()), (route) => false);
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email.text, password: password.text);
      } catch (e) {
        print(e.message);
      }
    }
  }

  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backColor,
        body: Form(
          key: _formkey,
          //scrollDirection: Axis.vertical
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    Image(image: AssetImage('assets/images/front.png'), height: 200,),

                    Padding(
                      padding: const EdgeInsets.only(top: 35, bottom: 15),
                      child: TextFormField(
                        controller: email,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: [AutofillHints.email],
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 5, bottom: 5, left: 20),
                            fillColor: textFormColor,
                            filled: true,
                            labelText: "Email",
                            hintText: 'Enter Your Email',
                            prefixIcon: Icon(Icons.email),
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
                            )
                          ),
                        ),
                    ),

                    TextFormField(
                      controller: password,
                      style: TextStyle(fontSize: 18),
                      obscureText: _obscureText,
                      autofillHints: [AutofillHints.password],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                        fillColor: textFormColor,
                          filled: true,
                          labelText: 'Password',
                          hintText: 'Enter Your Password',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: InkWell(
                            //onTap: VisiblePassword,
                            onTap: _toggle,
                            child: _obscureText
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: backColor,
                                width: 1
                              ),
                            borderRadius: BorderRadius.circular(16)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: colors,
                              width: 1
                            ),
                              borderRadius: BorderRadius.circular(16)
                          ),

                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 25, bottom: 15),
                      child: ButtonConfig(
                        text: 'Sign In',
                        press: (){
                          showLoaderDialog(context);
                          SignIn();
                        },
                      ),
                    ),

                    Text(
                      "Don't have an Account?",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),

                    ButtonConfig(
                      text: 'Sign Up',
                      press: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Sign_up()));
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 25,),
                      child: Text(
                        "OR",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),

                    Container(
                      width: size.width,
                      child: SignInButton(
                          Buttons.Google,
                          onPressed: () {
                        AuthMethods().signInWithGoogle(context);
                      }),
                    ),
                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }
}
