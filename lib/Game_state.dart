import 'package:flutter/material.dart';
import 'package:zerokata/Game.dart';
import 'dart:async';
import 'package:zerokata/check_victory.dart';
import 'package:zerokata/ai.dart';
import 'package:zerokata/victory_line.dart';

class GameState extends State<Game> {
  BuildContext _context;
  var field = [['', '', ''], ['', '', ''], ['', '', '']];
  var playerChar = 'O',aiChar = 'X';
  bool playerTurn = true;
  Victory victory;
  AI ai;
  Color playerColor, aiColor;

  @override
  Widget build(BuildContext context) {
    ai = new AI(field,playerChar,aiChar);
    playerColor = Colors.lightBlue;
    aiColor = Colors.orange;

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
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
                      color: Colors.grey,
                      height: 5.0
                  ),
                  new Container(
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      color: Colors.grey,
                      height: 5.0
                  ),
                ]
            ),
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new Container(
                      margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      color: Colors.grey,
                      width: 5.0
                  ),
                  new Container(
                      margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      color: Colors.grey,
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
    Color color = Theme.of(context).primaryColor;
    return new AspectRatio(aspectRatio: 1.0,
        child: new MaterialButton(
            onPressed: () {
              setState(() {
                if (!_gameIsDone() && playerTurn) {
                  setState(() {
                    _displayPlayersTurn(row, column);

                    if (!_gameIsDone()) {
                      _displayAiTurn();
                    }
                    });
                  } });
            },
            child: new Text(field[row][column], style: new TextStyle(
              fontSize: 82.0,
              color:field[row][column].isNotEmpty && field[row][column] == playerChar ? playerColor : aiColor,
            )))
    );
  }
  void _displayPlayersTurn(int row, int column) {
    print('clicked on row $row column $column');
    playerTurn = false;
    if(field[row][column]!='') {
      playerTurn = true;
    }
    else if(field[row][column] =='')
    {
      field[row][column]=playerChar;
    }
    _checkForVictory();

  }

  void _displayAiTurn() {
    if(playerTurn==false)
      {
        new Timer(const Duration(milliseconds: 600), () {
          setState((){
            var aiDecision = ai.getDecision();
            print(aiDecision);
            field[aiDecision.row][aiDecision.column] = aiChar;
            playerTurn = true;
            _checkForVictory();
          });
        });
      }

  }
  bool _gameIsDone() {
    return  (field[0][0].isNotEmpty &&
        field[0][1].isNotEmpty &&
        field[0][2].isNotEmpty &&
        field[1][0].isNotEmpty &&
        field[1][1].isNotEmpty &&
        field[1][2].isNotEmpty &&
        field[2][0].isNotEmpty &&
        field[2][1].isNotEmpty &&
        field[2][2].isNotEmpty) || victory!=null;
  }

  void _checkForVictory() {
    var victory = VictoryChecker.checkForVictory(field, playerChar);
    if (victory != null) {
      String message;

      if (victory.winner == 'p1') {
        message = 'You Win!';
      } else if (victory.winner == 'p2') {
        message = 'AI Win!';
      } else if (victory.winner == 'draw') {
        message = 'Draw';
      }
      print(message);
      Scaffold.of(_context).showSnackBar(new SnackBar(
        content: new Text(message),
        duration: const Duration(minutes: 1),
        action: new SnackBarAction(
            label: 'Retry',
            onPressed: () {
              setState(() {
                victory = null;
                field = [
                  ['', '', ''],
                  ['', '', ''],
                  ['', '', '']
                ];
                playerTurn = true;
              });
            }),
      ));
    }
  }
}

