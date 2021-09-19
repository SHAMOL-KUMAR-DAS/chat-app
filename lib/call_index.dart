import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import './call.dart';

class Call_Index extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<Call_Index> {
  final _channelController = TextEditingController();
  bool _validateError = false;

  ClientRole _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Excel IT Live Calling')),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 400,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: TextFormField(
                        controller: _channelController,
                        decoration: InputDecoration(
                            errorText:
                            _validateError ? 'Channel name is mandatory' : null,
                            // border: UnderlineInputBorder(
                            //   borderSide: BorderSide(width: 1),
                            // ),
                            hintText: 'Type excelitai',
                            labelText: 'Channel Name'
                        ),
                      ))
                ],
              ),
              // ListTile(
              //   //title: Icon(Icons.),
              //   leading: Radio(
              //     value: ClientRole.Broadcaster,
              //     groupValue: _role,
              //     onChanged: (ClientRole value) {
              //       setState(() {
              //         _role = value;
              //       });
              //     },
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      onPressed: onJoin,
                      //onHighlightChanged: (),
                      child: Row(
                        children: [
                          Radio(
                            value: ClientRole.Broadcaster,
                            groupValue: _role,
                            onChanged: (ClientRole value) {
                              setState(() {
                                _role = value;
                              });
                            },
                          ),
                          Icon(Icons.video_call_outlined)
                        ],
                      ),

                    ),
                    // Expanded(
                    //   child: RaisedButton(
                    //     onPressed: onJoin,
                    //     child: Text('Join'),
                    //     color: Colors.blueAccent,
                    //     textColor: Colors.white,
                    //   ),
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: _channelController.text,
            role: _role,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}