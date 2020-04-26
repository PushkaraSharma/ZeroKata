import 'package:flutter/material.dart';
import 'package:zerokata/offline_mode/offline_play_state.dart';

class Offline extends StatefulWidget {
  Offline({Key key, this.title}) : super(key: key);

  final String title;

  @override
  OfflineState createState() => new OfflineState();
}
