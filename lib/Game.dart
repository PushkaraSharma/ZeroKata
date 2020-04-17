import 'package:flutter/material.dart';
import 'package:zerokata/Game_state.dart';

class Game extends StatefulWidget {
  Game({Key key, this.title}) : super(key: key);

  final String title;

  @override
  GameState createState() => new GameState();
}