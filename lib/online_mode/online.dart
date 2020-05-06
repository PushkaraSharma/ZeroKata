import 'package:flutter/material.dart';
import 'package:zerokata/online_mode/onlineState.dart';



class Online extends StatefulWidget {
  Online({Key key, this.title, this.type, this.me, this.gameId, this.withId})
      : super(key: key);

  final String title, type, me, gameId, withId;

  @override
  OnlineState createState() => new OnlineState(type: type, me: me, gameId: gameId, withId: withId);
}