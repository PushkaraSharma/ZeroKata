import 'package:flutter/material.dart';
import 'package:zerokata/Game.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZeroKata',
      theme: new ThemeData(

        primarySwatch: Colors.grey,
      ),
      home: new Game(title: 'ZeroKata'),
    );
  }
}

