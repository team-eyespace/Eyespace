import 'package:flutter/material.dart';
import 'package:eyespace/containers/auth_button/auth_button_container.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var pageSize = MediaQuery.of(context).size;
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          
          new Container(
            alignment: Alignment.center,
            width: pageSize.width,
            height: pageSize.height,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.2, 1.0],
                colors: [
                  //const Color(0xFF3744B0),
                  //const Color(0xFF3799B0),
                  const Color.fromARGB(230,		117, 117, 117	),
                  //const Color.fromARGB(255, 	144, 164, 174),
                  const Color.fromARGB(255, 	176, 190, 197)          
                  ],
              ),
            ),
          ),

        new Container(
      alignment: Alignment.center,
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 120.0),
                    child: new Image.asset('assets/images/ic_launcher.png', height: 200, width: 200),
                  ),
                ],
              ),
    ),

new Container(
      alignment: Alignment.center,
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 275.0),
                    child: SizedBox(
                      width: 250.0,
                      child: ColorizeAnimatedTextKit(
          text: [
            "Eyespace",
          ],
          textStyle: TextStyle(
              fontSize: 45.0, 
              fontFamily: "Montserrat-Regular"
          ),
          colors: [
            Colors.lightBlue,
            Colors.yellow,
          ],
          textAlign: TextAlign.center,
          alignment: AlignmentDirectional.center // or Alignment.topLeft
        ),
      ),
                        ),
                      ],
                    ),
          ),

          new Container(
      alignment: Alignment.center,
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 450.0),
                    child: SizedBox(
                      width: 250.0,
                      child: ColorizeAnimatedTextKit(
          text: [
            "A new way to look",
          ],
          textStyle: TextStyle(
              fontSize: 23.0, 
              fontFamily: "Montserrat-Regular"
          ),
          colors: [
            Colors.lightBlue,
            Colors.yellow,
          ],
          textAlign: TextAlign.center,
          alignment: AlignmentDirectional.center // or Alignment.topLeft
        ),
      ),
                  ),
                ],
              ),
    ),

           new Container(
             alignment: Alignment.bottomCenter,
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 600.0),
                    child: new GoogleAuthButtonContainer(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

 }
