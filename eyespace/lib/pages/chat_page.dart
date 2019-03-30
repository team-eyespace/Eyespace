import 'package:flutter/material.dart';
import 'package:eyespace/constants/colors.dart';
import 'package:eyespace/containers/chatbot/chatbot.dart';
import 'package:eyespace/containers/drawer/drawer.dart';

class ChatPage extends StatelessWidget {
  final String title;

  ChatPage(this.title);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: MeSuiteColors.blue,
        title: new Text(this.title),
      ),
      drawer: DrawerContainer(),
      body: new Container(child: new ChatMessages()),
    );
  }
}
