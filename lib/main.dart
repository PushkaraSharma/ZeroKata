import 'package:flutter/material.dart';
import 'package:zerokata/startup_screens/FirstView.dart';
import 'package:zerokata/offline_mode/offline_play.dart';
import 'package:zerokata/ai_mode/Game.dart';
//import 'package:flutter_tic_tac_toe/user_list/user_list.dart';


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
      home:  FirstView(title:"ZeroKata"),
//      routes: <String, WidgetBuilder>{
//        'AI Mode': (BuildContext context) => Game(title:"AI mode"),
//        'Offline': (BuildContext context) => Offline(title:"Offline"),
//        'multiplayerGame': (BuildContext context) =>
//            Game(title: 'Online'),
//        'userList': (BuildContext context) => UserList(title: 'All users')
//      },
    );
  }
}

