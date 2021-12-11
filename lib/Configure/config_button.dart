import 'package:chatting_app/Configure/config_color.dart';
import 'package:flutter/material.dart';

class ButtonConfig extends StatelessWidget {
  
  var text, press;
  ButtonConfig({this.text, this.press});
  
  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;
    return FlatButton(
      color: colors,
    minWidth: size.width,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15)
    ),
    onPressed: press, 
        child: Text(text, style: buttonStyle,)
    );
  }
}
