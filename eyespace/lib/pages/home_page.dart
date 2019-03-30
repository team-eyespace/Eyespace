import 'package:flutter/material.dart';
import 'package:eyespace/constants/colors.dart';
import 'package:eyespace/containers/camera_view/camera_view.dart';
import 'package:eyespace/containers/drawer/drawer.dart';

class HomePage extends StatelessWidget {
  final String title;

  HomePage(this.title);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: MeSuiteColors.blue,
        title: new Text(this.title),
      ),
      drawer: DrawerContainer(),
      body: new Container(child: new CameraView()),
    );
  }
}
