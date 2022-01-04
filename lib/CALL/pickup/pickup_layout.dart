import 'package:chatting_app/CALL/call.dart';
import 'package:chatting_app/CALL/call_methods.dart';
import 'package:chatting_app/CALL/pickup/pickup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final String uid;
  final CallMethods callMethods = CallMethods();

  PickupLayout({
     this.scaffold,
     this.uid,
  });

  @override
  Widget build(BuildContext context) {
    print('uid ${uid}');
    return uid != null
        ? StreamBuilder<DocumentSnapshot>(
        stream: callMethods.callStream(uid: uid),
        // initialData: null,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.data != null) {
            //Call call = Call.fromMap(snapshot.data!["caller_id" "caller_name" 'receiver_id' 'receiver_name' 'channel_id' 'has_dialled']);
            Call call = Call.fromMap(snapshot.data.data as Map<String, dynamic>);
            print('call log ${call}');
            if (!call.hasDialled) {
              FlutterRingtonePlayer.playRingtone();
              // print("PLAY");
              return PickupScreen(
                call: call,
              );
            }
            // print("STOP");
            print("=====================////====");
            FlutterRingtonePlayer.stop();
            return scaffold;
          }
          // print("STOP");
          FlutterRingtonePlayer.stop();
          return scaffold;
        })
        : Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}