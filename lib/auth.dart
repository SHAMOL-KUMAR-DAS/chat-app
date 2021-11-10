//For Google Signing In

import 'package:chatting_app/database.dart';
import 'package:chatting_app/sharedpref_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'all_users.dart';

class AuthMethods{
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser(){
    return auth.currentUser();
  }

  signInWithGoogle(BuildContext context) async{
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount _googleSignInAccount = await _googleSignIn.signIn();

    final GoogleSignInAuthentication _googleSignInAuthentication = await _googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _googleSignInAuthentication.idToken,
        accessToken: _googleSignInAuthentication.accessToken);

    final result  = await _firebaseAuth.signInWithCredential(
        credential);
    final userDetails = result;

    if(result != null){
      SharedPreferenceHelper().saveUserEmail(userDetails.email);
      SharedPreferenceHelper().saveUserID(userDetails.uid);
      SharedPreferenceHelper().saveUserName(userDetails.displayName);
      SharedPreferenceHelper().saveUserProfilePic(userDetails.photoUrl);
      SharedPreferenceHelper().saveUserMobile(userDetails.phoneNumber);

      Map<String, dynamic> userInfoMap = {
        "First_Name": userDetails.displayName,
        "Mobile": userDetails.phoneNumber,
        "E-Mail": userDetails.email,
        "User_Name": userDetails.email.replaceAll("@gmail.com", ""),
        "Image": userDetails.photoUrl
      };

      //After Google sign in which page visible
      DatabaseMethods().addUserInfo(userDetails.uid, userInfoMap).then((value) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>All_Users()));
      });
    }
  }
}