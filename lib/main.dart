import 'package:flutter/material.dart';
import 'package:zerokata/Game.dart';
import 'package:zerokata/startup_screen.dart';
import 'package:zerokata/startscreen2.dart';

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
      home:  FirstView(),
    );
  }
}

