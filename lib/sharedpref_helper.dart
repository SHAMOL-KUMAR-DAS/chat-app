// For Google Signing In

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{

  static String userName = 'USERNAME';
  static String userEmail = 'USEREMAIL';
  static String userID = 'USERID';
  static String userProfilePic = 'USERPROFILEPIC';
  static String userMobile = 'USERMOBILE';

  //save user data
  saveUserName(String getUserName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userName , getUserName);
  }
  saveUserEmail(String getUserEmail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmail , getUserEmail);
  }
  saveUserID(String getUserID) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userID , getUserID);
  }
  saveUserProfilePic(String getUserProfile) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfilePic , getUserProfile);
  }
  saveUserMobile(String getUserMobile) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userMobile , getUserMobile);
    //return prefs.getString(userMobile, getUserMobile);
  }

  //get user data
  Future<String> getUserName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userName);
  }
  Future<String> getUserEmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmail);
  }
  Future<String> getUserID() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userID);
  }
  Future<String> getUserProfile() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfilePic);
  }
  Future<String> getUserMobile() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userMobile);
  }
}
