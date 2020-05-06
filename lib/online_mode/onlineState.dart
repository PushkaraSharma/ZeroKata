import 'dart:io';

import 'package:zerokata/online_mode/online.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:zerokata/startup_screens/FirstView.dart';
import 'package:zerokata/victory/check_victory.dart';
import 'package:zerokata/victory/victory_line.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:zerokata/widgets/custom_alertDialog.dart';
import 'package:connectivity/connectivity.dart';

final primaryColor = const Color(0xFF616161);

class OnlineState extends State<Online> {
  StreamSubscription connectivitySubscription;

  ConnectivityResult _previousResult;

  bool dialogshown = false;

  BuildContext _context;
  List<List<String>> field = [
    ['', '', ''],
    ['', '', ''],
    ['', '', '']
  ];
  Color blue, orange;
  String playerChar = 'X', aiChar = 'O';
  bool playersTurn = true;
  Victory victory;
  final String type, me, gameId, withId;

  OnlineState({this.type, this.me, this.gameId, this.withId});

  Future<bool> checkinternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }
    } on SocketException catch (_) {
      return Future.value(false);
    }
  }

  @override
  void initState() {
    super.initState();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connresult) {
      if (connresult == ConnectivityResult.none) {
        dialogshown = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          child: AlertDialog(
            backgroundColor: primaryColor,
            elevation: 15,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18))),
            title: Text("No Internet!!",textAlign: TextAlign.center,style: GoogleFonts.amaticaSc(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w700)),
            content: Text("No Data Connection Available.",style: GoogleFonts.amaticaSc(color: Colors.white, fontSize: 18)
                ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => FirstView()),
                  (Route<dynamic> route) => false,
                ),
                child: Text("Go To Home"),
              ),
            ],
          ),
        );
      } else if (_previousResult == ConnectivityResult.none) {
        checkinternet().then((result) {
          if (result == true) {
            if (dialogshown == true) {
              dialogshown = false;
              Navigator.pop(context);
            }
          }
        });
      }
      _previousResult = connresult;
    });

    if (me != null) {
      playersTurn = me == 'X';
      playerChar = me;

      FirebaseDatabase.instance
          .reference()
          .child('games')
          .child(gameId)
          .onChildAdded
          .listen((Event event) {
        String key = event.snapshot.key;
        if (key != 'restart') {
          int row = int.parse(key.substring(0, 1));
          int column = int.parse(key.substring(2, 3));
          if (field[row][column] != me) {
            setState(() {
              field[row][column] = event.snapshot.value;
              playersTurn = true;
              checkForVictory();
            });
          }
        } else if (key == 'restart') {
          FirebaseDatabase.instance.reference().child(gameId).set(null);

          setState(() {
            Scaffold.of(_context).hideCurrentSnackBar();
            cleanUp();
          });
        }
      });

      // Haven't figured out how to display a Snackbar during build yet
      new Timer(Duration(milliseconds: 1000), () {
        String text = playersTurn ? 'Your turn' : 'Opponent\'s turn';
        print(text);
        Scaffold.of(_context).showSnackBar(SnackBar(content: Text(text)));
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    connectivitySubscription.cancel();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => CustomDialog(
            title: "You really want to", descrip: "Exit?", type: 'exit'));
  }

  @override
  Widget build(BuildContext context) {
    print(type);
    print(me);
    print(gameId);
    print(withId);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: new Text(widget.title,
                style: GoogleFonts.amaticaSc(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                )),
            backgroundColor: Colors.grey[800],
            centerTitle: true,
          ),
          backgroundColor: primaryColor,
          body: new Center(
              child: new Stack(
                  children: [buildGrid(), buildField(), buildLine()]))),
    );
  }

  Widget buildLine() {
    return new AspectRatio(
        aspectRatio: 1.0,
        child: new CustomPaint(painter: new VictoryLine(victory)));
  }

  Widget buildGrid() {
    return new AspectRatio(
        aspectRatio: 1.0,
        child: new Stack(
          children: [
            new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new Container(
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      color: Colors.black,
                      height: 5.0),
                  new Container(
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      color: Colors.black,
                      height: 5.0),
                ]),
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new Container(
                      margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      color: Colors.black,
                      width: 5.0),
                  new Container(
                      margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      color: Colors.black,
                      width: 5.0),
                ])
          ],
        ));
  }

  Widget buildField() {
    return new AspectRatio(
        aspectRatio: 1.0,
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new Expanded(
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                    buildCell(0, 0),
                    buildCell(0, 1),
                    buildCell(0, 2),
                  ])),
              new Expanded(
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                    buildCell(1, 0),
                    buildCell(1, 1),
                    buildCell(1, 2),
                  ])),
              new Expanded(
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                    buildCell(2, 0),
                    buildCell(2, 1),
                    buildCell(2, 2),
                  ]))
            ]));
  }

  Widget buildCell(int row, int column) {
    Color color = Theme.of(context).primaryColor;
    return new AspectRatio(
        aspectRatio: 1.0,
        child: new MaterialButton(
            onPressed: () {
              setState(() {
                if (!_gameIsDone() && playersTurn) {
                  setState(() {
                    displayPlayersTurn(row, column);
                  });
                }
              });
            },
            child: new Text(field[row][column],
                style: new TextStyle(
                  fontSize: 82.0,
                  fontFamily: 'Chalk',
                  color:
                      field[row][column] == 'X' ? Colors.black : Colors.white,
                ))));
  }

  Widget buildVictoryLine() => AspectRatio(
      aspectRatio: 1.0, child: CustomPaint(painter: VictoryLine(victory)));

  void displayPlayersTurn(int row, int column) {
    print('clicked on row $row column $column');
    playersTurn = false;
//    field[row][column] = playerChar;
    if (field[row][column] != '') {
      playersTurn = true;
    } else if (field[row][column] == '') {
      field[row][column] = playerChar;
      if (type != null && type == 'wifi') {
        FirebaseDatabase.instance
            .reference()
            .child('games')
            .child(gameId)
            .child('${row}_${column}')
            .set(me);
      }
    }
    checkForVictory();
  }

  bool _gameIsDone() {
    return (field[0][0].isNotEmpty &&
            field[0][1].isNotEmpty &&
            field[0][2].isNotEmpty &&
            field[1][0].isNotEmpty &&
            field[1][1].isNotEmpty &&
            field[1][2].isNotEmpty &&
            field[2][0].isNotEmpty &&
            field[2][1].isNotEmpty &&
            field[2][2].isNotEmpty) ||
        victory != null;
  }

  void checkForVictory() {
    victory = VictoryChecker.checkForVictory(field, playerChar);
    if (victory != null) {
      String message;

      if (victory.winner == 'p1') {
        message = 'WON';
      } else if (victory.winner == 'p2') {
        message = 'LOOSE';
      } else if (victory.winner == 'draw') {
        message = 'DRAW';
      }

      print(message);
      setState(() {
        print("INside setsate");
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => custom_alert(context, message));
      });
    }
  }

  void restart() async {
    await FirebaseDatabase.instance
        .reference()
        .child('games')
        .child(gameId)
        .set(null);

    await FirebaseDatabase.instance
        .reference()
        .child('games')
        .child(gameId)
        .child('restart')
        .set(true);

    setState(() {
      cleanUp();
    });
  }

  void cleanUp() {
    victory = null;
    field = [
      ['', '', ''],
      ['', '', ''],
      ['', '', '']
    ];
    playersTurn = me == 'X';
    String text = playersTurn ? 'Your turn' : 'Opponent\'s turn';
    print(text);
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }

  Widget custom_alert(BuildContext context, String msg) {
    String title = "You";
    if (msg == 'DRAW') title = "Nobody Won";
    return new WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Stack(children: <Widget>[
              Container(
                  width: 600,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(color: Colors.black, blurRadius: 30)
                      ]),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    AutoSizeText(
                      title,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amaticaSc(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AutoSizeText(
                      msg,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 80.0,
                          fontFamily: 'Chalk'),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RaisedButton(
                        elevation: 8,
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.white)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 7, 12, 7),
                          child: AutoSizeText("Play Again",
                              maxLines: 1,
                              style: GoogleFonts.amaticaSc(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                              )),
                        ),
                        onPressed: () {
                          restart();
                          Navigator.of(context).pop();
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                        child: AutoSizeText("Exit",
                            maxLines: 1,
                            style: GoogleFonts.amaticaSc(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            )),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FirstView()),
                            (Route<dynamic> route) => false,
                          );
                        })
                  ]))
            ])));
  }
}
