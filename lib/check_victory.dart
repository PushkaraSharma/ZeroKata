class Victory {
  int row;
  int col;
  int lineType;
  String winner;

  Victory(this.row, this.col, this.lineType, this.winner);
}

class VictoryChecker {

   static Victory checkForVictory(var field, String playerChar) {
    var v;
    //check horizontal lines
    if (field[0][0].isNotEmpty &&
        field[0][0] == field[0][1] &&
        field[0][0] == field[0][2]) {
      v = new Victory(0, 0, 0,  // o - horizontal 1-vertical
          field[0][0] == playerChar ? 'p1' : 'p2');
    } else if (field[1][0].isNotEmpty &&
        field[1][0] == field[1][1] &&
        field[1][0] == field[1][2]) {
      v = new Victory(1, 0, 0,
          field[1][0] == playerChar ? 'p1' : 'p2');
    } else if (field[2][0].isNotEmpty &&
        field[2][0] == field[2][1] &&
        field[2][0] == field[2][2]) {
      v = new Victory(2, 0, 0,
          field[2][0] == playerChar ? 'p1' : 'p2');
    }

    //check vertical lines
    else if (field[0][0].isNotEmpty &&
        field[0][0] == field[1][0] &&
        field[0][0] == field[2][0]) {
      v = new Victory(0, 0, 1,
          field[0][0] == playerChar ? 'p1':'p2');
    } else if (field[0][1].isNotEmpty &&
        field[0][1] == field[1][1] &&
        field[0][1] == field[2][1]) {
      v = new Victory(0, 1, 1,
          field[0][1] == playerChar ? 'p1':'p2');
    } else if (field[0][2].isNotEmpty &&
        field[0][2] == field[1][2] &&
        field[0][2] == field[2][2]) {
      v = new Victory(0, 2,1,
          field[0][2] == playerChar ? 'p1':'p2');
    }

    //check diagonal
    else if (field[0][0].isNotEmpty &&
        field[0][0] == field[1][1] &&
        field[0][0] == field[2][2]) {
      v = new Victory(0, 0, 2,         // 2 - diagnol 1 3- diagnol2
          field[0][0] == playerChar ? 'p1':'p2');
    } else if (field[2][0].isNotEmpty &&
        field[2][0] == field[1][1] &&
        field[2][0] == field[0][2]) {
      v = new Victory(2, 0, 3,
          field[2][0] == playerChar ? 'p1':'p2');
    } else if (field[0][0].isNotEmpty &&
        field[0][1].isNotEmpty &&
        field[0][2].isNotEmpty &&
        field[1][0].isNotEmpty &&
        field[1][1].isNotEmpty &&
        field[1][2].isNotEmpty &&
        field[2][0].isNotEmpty &&
        field[2][1].isNotEmpty &&
        field[2][2].isNotEmpty) {
      v = new Victory(-1, -1, -1, 'draw');
    }

    return v;
  }
}
