import 'dart:math';
import 'package:flutter/material.dart';
import 'call.dart';
import 'call_methods.dart';
import 'call_screen.dart';


var channelId = Random().nextInt(1000).toString();

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial(
      {
        var currUserName,
        var currUserId,
        var receiverName,
        var receiverId,
        var channelName,
        var tokenId,
        context}) async {

    Call call = Call(
      callerId: currUserId,
      callerName: currUserName,
      receiverId: receiverId,
      receiverName: receiverName,
      channelId: channelId,
      channelName: channelName,
      token: tokenId,

    );

    bool callMade = await callMethods.makeCall(call: call);

    if (callMade) {

      print('Current User Name: ************* $currUserName');
      print('Current User Id: ************$currUserId');
      print('Receiver Name: *************$receiverName');
      print('Receiver Id: ***********$receiverId');
      print('Channel Id: ***********$channelId');
      print('Receiver Id: ***********$channelName');
      print('Channel Id: ***********$tokenId');

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(
              call: call,
            ),
          ));

    }
  }
}