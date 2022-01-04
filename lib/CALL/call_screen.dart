import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';


import 'call.dart';
import 'call_methods.dart';

class CallScreen extends StatefulWidget {

  final Call call;

  CallScreen( {
    this.call,
  });

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {

  final CallMethods callMethods = CallMethods();


  StreamSubscription callStreamSubscription;
  SharedPreferences preferences;



  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool hasUserJoined = false;
  bool isJoined = false;

  var APP_ID = "dcf6d81d2db1463082e45c4fda366eef";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Wakelock.enable();
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(null, widget.call.channelName, null, 0);

  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info)
        ;
        print('1111111111111111111111111111');
        print(APP_ID);
        print(widget.call.token);
        print(widget.call.channelName);
        print('$code');
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (

        String channel,
        int uid,
        int elapsed,
        ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info)

        ;
        print('2222222222222222222222222222222');
        print('$info');
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        hasUserJoined = true;
        final info = 'onUserJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
        print('333333333333333333333333333');
      });
    };

    AgoraRtcEngine.onUpdatedUserInfo = (AgoraUserInfo userInfo, int i) {
      setState(() {
        final info = 'onUpdatedUserInfo: ${userInfo.toString()}';
        _infoStrings.add(info)

        ;
        print('444444444444444444444444444444');
      });
    };

    AgoraRtcEngine.onRejoinChannelSuccess = (String string, int a, int b) {
      setState(() {
        final info = 'onRejoinChannelSuccess: $string';
        _infoStrings.add(info)

        ;
        print('6666666666666666666666666');
      });
    };

    AgoraRtcEngine.onUserOffline = (int a, int b) {
      callMethods.endCall(call: widget.call);
      setState(() {
        final info = 'onUserOffline: a: ${a.toString()}, b: ${b.toString()}';
        _infoStrings.add(info)

        ;
        print('7777777777777777777777777');
      });
    };

    AgoraRtcEngine.onRegisteredLocalUser = (String s, int i) {
      setState(() {
        final info = 'onRegisteredLocalUser: string: s, i: ${i.toString()}';
        _infoStrings.add(info)

        ;
        print('88888888888888888888888');
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        isJoined = false;
        _infoStrings.add('onLeaveChannel');
        _users.clear();
        print('99999999999999999999999999999999999999');
      });
    };

    AgoraRtcEngine.onConnectionLost = () {
      setState(() {
        final info = 'onConnectionLost';
        _infoStrings.add(info)

        ;
        print('10101010101010101010');
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      // if call was picked

      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info)
        ;
        _users.remove(uid);
        print('121212112212121212121');
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
        int uid,
        int width,
        int height,
        int elapsed,
        ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info)

        ;
        print('13131313113313131131313131');
      });
    };
  }

  addPostFrameCallback() async {
    SchedulerBinding.instance?.addPostFrameCallback((_) async {
      preferences = await SharedPreferences.getInstance();
      callStreamSubscription = callMethods
          .callStream(uid: preferences.getString('uid'))
          .listen((DocumentSnapshot ds) {
        switch (ds.data) {
          case null:
          // snapshot is null i.e. the call is hanged and document is deleted
            Navigator.pop(context);
            break;

          default:
            break;
        }
      });


    });
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
              children: <Widget>[_videoView(views[0])],
            ));
      case 2:
        return Stack(
          children:<Widget> [
            Container(
                child: Column(
                  children: <Widget>[
                    _expandedVideoRow([views[1]]),
                  ],
                )),
            Container(
                margin: EdgeInsets.only(left: 15, top: 30),
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Column(
                  children: <Widget>[
                    _expandedVideoRow([views[0]]),
                  ],
                )
            ),
          ],
        );
    }
    return Container();
  }


  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () {

              // print("KKKKKKK$T")

              callMethods.endCall(
                call: widget.call,
              );
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }


  @override
  void dispose()async {
    _users.clear();
    Wakelock.disable();
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    callStreamSubscription?.cancel();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            // _panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}