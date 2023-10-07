import 'package:flutter/material.dart';
import 'package:newapp123/chatbot.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Chatbot App'),
        ),
        body: ChatScreen()
      ),
    );
  }
}
