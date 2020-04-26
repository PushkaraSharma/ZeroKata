import 'package:flutter/material.dart';
import 'package:zerokata/offline_mode/offline_play.dart';
import 'package:zerokata/widgets/custom_alertDialog.dart';
import 'package:zerokata/victory/check_victory.dart';
import 'package:zerokata/victory/victory_line.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

final primaryColor = const Color(0xFF616161);

class OfflineState extends State<Offline> {
  BuildContext _context;
  var field = [['', '', ''], ['', '', ''], ['', '', '']];
  var playerChar = 'O',
      otherChar = 'X';
  bool playerTurn = true;
  Victory victory;
  Color playerColor, otherColor;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int playerXscore = 0;
  int playerOscore = 0;

  @override
  Widget build(BuildContext context) {
    playerColor = Colors.white;
    otherColor = Colors.black;

    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(widget.title, style: GoogleFonts.amaticaSc(
            color: Colors.black, fontSize: 28, fontWeight: FontWeight.w700,),),
          backgroundColor: Colors.grey[800],
          centerTitle: true,
        ),
        backgroundColor: primaryColor,
        body: new Center (
            child: new Stack(
                children: [
                  buildGrid(),
                  buildField(),
                  buildLine()
                ]
            )));
  }

  Widget buildLine() {
    return new AspectRatio(
        aspectRatio: 1.0,
        child: new CustomPaint(painter: new VictoryLine(victory)));
  }

  Widget buildGrid() {
    return new AspectRatio(aspectRatio: 1.0,
        child: new Stack(
          children: [
            new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new Container(
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      color: Colors.black,
                      height: 5.0
                  ),
                  new Container(
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      color: Colors.black,
                      height: 5.0
                  ),
                ]
            ),
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new Container(
                      margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      color: Colors.black,
                      width: 5.0
                  ),
                  new Container(
                      margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      color: Colors.black,
                      width: 5.0
                  ),
                ]
            )
          ],
        ));
  }

  Widget buildField() {
    return new AspectRatio(aspectRatio: 1.0,
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new Expanded(
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly,
                      children: [
                        buildCell(0, 0),
                        buildCell(0, 1),
                        buildCell(0, 2),
                      ]
                  )),
              new Expanded(
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildCell(1, 0),
                        buildCell(1, 1),
                        buildCell(1, 2),
                      ]
                  )),
              new Expanded(
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly,
                      children: [
                        buildCell(2, 0),
                        buildCell(2, 1),
                        buildCell(2, 2),
                      ]
                  ))
            ]
        )
    );
  }

  Widget buildCell(int row, int column) {
    Color color = Theme
        .of(context)
        .primaryColor;
    return new AspectRatio(aspectRatio: 1.0,
        child: new MaterialButton(
            onPressed: () {
              setState(() {
                _pressed(row, column);
              });
            },
            child: new Text(field[row][column], style: new TextStyle(
              fontSize: 82.0, fontFamily: 'Chalk',
              color: field[row][column].isNotEmpty &&
                  field[row][column] == playerChar ? playerColor : otherColor,
            )))
    );
  }

  void _pressed(int row, int column) {
    setState(() {
      if (playerTurn && field[row][column] == '') {
        field[row][column] = 'O';
      } else if (!playerTurn && field[row][column] == '') {
        field[row][column] = 'X';
      }

      playerTurn = !playerTurn;
      _checkForVictory();
    });
  }


  void _checkForVictory() {
    victory = VictoryChecker.checkForVictory(field, playerChar);
    if (victory != null) {
      String message, title;


      if (victory.winner == 'p1') {
        message = 'O';
        title = 'Winner Is';
      } else if (victory.winner == 'p2') {
        message = 'X';
        title = 'Winner Is';
      } else if (victory.winner == 'draw') {
        message = 'Draw';
        title = 'Nobody Wins';
      }
      print(message);
      new Timer(const Duration(milliseconds: 1000), () {
        setState(() {
          victory = null;
          field = [
            ['', '', ''],
            ['', '', ''],
            ['', '', '']
          ];
          playerTurn = true;

//        if(winner=="X")
//         {playerXscore+=1;}
//        else if(winner=="O")
//         {playerOscore+=1;}

          showDialog(context: context, builder: (BuildContext context) =>
              CustomDialog(title: title,
                  descrip: message));
        });
      });
    }

  }
}
//  void _showWinDialog(String winner) {
//    showDialog(
//        barrierDismissible: false,
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            title: Text('WINNER IS: ' + winner),
//            actions: <Widget>[
//              FlatButton(
//                child: Text('Play Again!'),
//                onPressed: () {
//                  setState(() {
//                    victory = null;
//                    field = [
//                      ['', '', ''],
//                      ['', '', ''],
//                      ['', '', '']
//                    ];
//                    playerTurn = true;
//                    Navigator.of(context).pop();
//                  });
//                },
//              )
//            ],
//          );
//        });
//    if(winner=="X")
//      {
//        playerXscore+=1;
//      }
//    else if(winner=="O")
//      {
//        playerOscore+=1;
//      }
//  }




