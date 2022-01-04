import 'package:chatting_app/CALL/call.dart';
import 'package:chatting_app/CALL/call_methods.dart';
import 'package:chatting_app/CALL/call_screen.dart';
import 'package:chatting_app/CALL/permissions.dart';
import 'package:chatting_app/CALL/pickup/circle_painter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'curve_wave.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  PickupScreen({
    this.call,
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen>
    with TickerProviderStateMixin {
  final CallMethods callMethods = CallMethods();
  AnimationController _controller;
  Color rippleColor = Colors.red;
  bool isCallMissed = true;
  SharedPreferences preferences;

  @override
  void initState() {
    print("============INIT==================");
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    print("=======DISPOSE=========");
    super.dispose();
  }

  Widget _button() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                rippleColor,
                Colors.red
                //Color.lerp(rippleColor, Colors.black, .05)
              ],
            ),
          ),
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: const CurveWave(),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
        ),
      ),
    );
  }

  void pickCall(BuildContext context) async {
    // preferences!.setString("token", widget.call.callerName);
    // preferences!.setString("channel", widget.call.callerName);
    isCallMissed = false;
    //addCallLogsToDb(callStatus: CALL_STATUS_RECEIVED);

    FlutterRingtonePlayer.stop();

    await Permissions.cameraAndMicrophonePermissionsGranted()
        ? {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallScreen(call: widget.call)))
    }
        : {};
  }

  double shake(double animation) =>
      2 * (0.5 - (0.5 - Curves.bounceOut.transform(animation)).abs());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            CustomPaint(
              painter: CirclePainter(
                _controller,
                color: rippleColor,
              ),
              child: SizedBox(
                width: 320.0,
                height: 120.0,
                child: _button(),
              ),
            ),
            Spacer(),
            Text(
              "Incoming...",
              style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              widget.call.callerName.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.redAccent),
                  // color: Colors.redAccent,
                  child: IconButton(
                    iconSize: 30.0,
                    icon: Icon(Icons.call_end),
                    color: Colors.white,
                    onPressed: () async {
                      isCallMissed = false;
                      // addCallLogsToDb(callStatus: CALL_STATUS_RECEIVED);
                      await callMethods.endCall(call: widget.call);
                    },
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.green),
                    child: FlatButton(
                      minWidth: 30,
                      color: Colors.green,
                      onPressed: () {
                        pickCall(context);
                      },
                      child: Image(
                        image: AssetImage('assets/videocall.png'),
                        height: 30,
                        color: Colors.white,
                      ),
                    )
                  // IconButton(
                  //     iconSize: 30.0,
                  //     icon: Icon(Icons.video_call),
                  //     color: Colors.white, onPressed: () {
                  //       pickCall(context);
                  //
                  // },
                  //     // onPressed: () => pickCall(context)
                  //
                  // ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}