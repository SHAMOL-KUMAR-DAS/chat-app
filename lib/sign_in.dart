import 'package:chatting_app/chatpage.dart';
import 'package:chatting_app/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Sign_in extends StatefulWidget {
  @override
  _Sign_inState createState() => _Sign_inState();
}

class _Sign_inState extends State<Sign_in> {
  String _email, _password;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool hidePassword = true;

  Future<void> SignIn() async {
    final formstate = _formkey.currentState;
    if (formstate.validate()) {
      formstate.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Chatting()));
      } catch (e) {
        print(e.message);
      }
    }
  }

  bool _obscureText = true;

  //String _password;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Get Started",
            style: TextStyle(
                fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Form(
        key: _formkey,
        //scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.04,
                  // ),
                  Text("Start with signing in"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Image(
                      image: NetworkImage(
                          "https://cdn.pixabay.com/photo/2012/04/18/14/28/buddy-37197_1280.png",
                          scale: 10)),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child:
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "E-Mail",
                        //prefixIcon: Icon(Icons.supervised_user_circle)

                      ),
                      onSaved: (input) {
                        setState(() {
                          _email = input;
                        });
                      },
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Please Enter Your Email";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  Column(
                    children: [
                      //SizedBox(width: MediaQuery.of(context).size.width*0.2,),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: TextFormField(
                          onSaved: (input){
                            setState(() {
                              _password=input;
                            });
                          },
                          validator: (input){
                            if(input.length<6){
                              return "Password is too small";
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black),
                          obscureText: hidePassword,

                          decoration: InputDecoration(
                              labelText: "Password",
                              suffixIcon: InkWell(
                                  onTap: VisiblePassword,
                                  child: Icon(Icons.visibility,color: Colors.black,)),
                              labelStyle: TextStyle(color: Colors.black),
                              ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  FlatButton(
                      color: Colors.blue,
                      minWidth: MediaQuery.of(context).size.width * 0.5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        setState(() {
                          SignIn();
                        });
                      },
                      child: Text("Sign In")),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                  ),
                  Text("Don't have an Account?"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  FlatButton(
                      color: Colors.blue,
                      minWidth: MediaQuery.of(context).size.width * 0.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Sign_up()));
                      },
                      child: Text("Sign Up"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void VisiblePassword(){
    if(hidePassword == true){
      hidePassword = false;
    }
    else{
      hidePassword = true;
    }
    setState(() {

    });
  }
}