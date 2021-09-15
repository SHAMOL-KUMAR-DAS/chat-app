import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBaseUserService{
  String uid;
  DataBaseUserService({this.uid});

  final CollectionReference user = Firestore.instance.collection('chat');

  Future UpdateUserData(String _fname, _lname, _address, _mobile, _email) async{
    return await user.document(uid).setData({
      'First_Name': _fname,
      'Last_Name': _lname,
      'Address': _address,
      'Mobile': _mobile,
      'E-Mail': _email,
    });
  }
  Future updateuserimage(String image) async{
    return await user.document(uid).updateData({
      'Image': image,
    });
  }
}

class DatabaseMethods{
  Future addUserInfo(String userId, Map<String, dynamic> userInfoMap) async{
    return await Firestore.instance.collection('chat').document(userId).setData(
          (userInfoMap)
        );
  }
}

// class IndividualChatting{
//   String uid;
//   IndividualChatting({this.uid});
//
//   final CollectionReference user = Firestore.instance.collection('chat');
//
//   Future UpdateUserData(String _message, String _sender) async{
//     return await user.document(uid).collection('Message').document().collection('Individual').add({
//       'Message': _message,
//     });
//   }
// }