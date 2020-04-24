import 'package:flutter/material.dart';
import 'package:zerokata/startup_screens/startup_screen.dart';


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

