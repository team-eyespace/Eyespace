import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Center(
          //child: new CircularProgressIndicator(),
          child: new SizedBox(
  width: 250.0,
  child: TypewriterAnimatedTextKit(
    text: [
      "EyeSpace",
    ],
    textStyle: TextStyle(
        fontSize: 30.0,
        fontFamily: "Agne"
    ),
    textAlign: TextAlign.center,
    alignment: AlignmentDirectional.center // or Alignment.topLeft
  ),
),
        ),
      ),
    );
  }
}
