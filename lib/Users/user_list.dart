import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zerokata/constants.dart';
import 'package:zerokata/Users/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:zerokata/startup_screens/FirstView.dart';
import 'package:zerokata/widgets/loading.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

final primaryColor = const Color(0xFF616161);

class UserList extends StatefulWidget {
  final String title;

  UserList({Key key, this.title}) : super(key: key);

  @override
  UserListState createState() => UserListState();
}

class UserListState extends State<UserList> {
  List<User> _users = List<User>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    print(_users.isEmpty);

    return _users.isEmpty
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(
                widget.title,
                style: GoogleFonts.amaticaSc(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: Colors.grey[800],
              centerTitle: true,
              actions: <Widget>[
                FlatButton(child: Text("Logout", style: GoogleFonts.amaticaSc(color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            )),
                onPressed: () async {
                  try {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    var userid = prefs.getString(USER_ID);
                    FirebaseDatabase.instance.reference().child("users").child(userid).remove();
                    await _auth.signOut();
                    await _googleSignIn.signOut();
                    print('Signed Out');
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => FirstView()),
                            (Route<dynamic> route) => false,);
                  } catch (e) {
                    print(e.toString());
                  }
                },)
              ],
            ),
            body: new ListView.builder(
                itemCount: _users.length, itemBuilder: _buildListRow));
  }

  Widget _buildListRow(BuildContext context, int index) => Container(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
        child: Column(
          children: <Widget>[
            Card(
              color: primaryColor,
              elevation: 15.0,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 55,
                        width: 55,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue[200],
                          backgroundImage: NetworkImage(
                              '${(_users[index]?.photoUrl == null) ? 'https://www.nicepng.com/png/detail/933-9332131_profile-picture-default-png.png' : _users[index].photoUrl}'),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    AutoSizeText(
                      '${_users[index].name}',
                      maxLines: 1,
                      style: GoogleFonts.amaticaSc(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    ArgonTimerButton(
                      initialTimer: 0,
                      height: 40,
                      width: 80,
                      minWidth: 100,
                      borderRadius: 12.0,
                      borderSide: BorderSide(color: Colors.white, width: 2),
                      elevation: 10,
                      color: Colors.black,
                      child: Text(
                        "Invite",
                        style: GoogleFonts.amaticaSc(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      loader: (timeLeft) {
                        return Text(
                          "Wait...$timeLeft",
                          style: GoogleFonts.amaticaSc(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        );
                      },
                      onTap: (startTimer, btnState) {
                        if (btnState == ButtonState.Idle) {
                          startTimer(60);
//                      Scaffold.of(context).showSnackBar(
//                      SnackBar(content: Text('clicked on ${_users[index].name}'))
//                      );
                          invite(_users[index]);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));

  void _fetchUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString(USER_ID);
    var snapshot =
        await FirebaseDatabase.instance.reference().child('users').once();
    Map<String, dynamic> users = snapshot.value.cast<String, dynamic>();
    users.forEach((userId, userMap) {
      User user = _parseUser(userId, userMap);
      if (userid != userId) {
        setState(() {
          _users.add(user);
        });
      }
    });
  }

  User _parseUser(String userId, Map<dynamic, dynamic> user) {
    String name, photoUrl, pushId;
    user.forEach((key, value) {
      if (key == NAME) {
        name = value as String;
      }
      if (key == PHOTO_URL) {
        photoUrl = value as String;
      }
      if (key == PUSH_ID) {
        pushId = value as String;
      }
    });

    return User(userId, name, photoUrl, pushId);
  }

  invite(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString(USER_NAME);
    var pushId = prefs.getString(PUSH_ID);
    var userId = prefs.getString(USER_ID);
    username = username.replaceAll(' ', '_');
    print(username);

    var base = 'https://us-central1-zerokata-bf5ca.cloudfunctions.net';
    String dataURL =
        '$base/sendNotification2?to=${user.pushId}&fromPushId=$pushId&fromId=$userId&fromName=$username&type=invite';
    print(dataURL);
    String gameId = '$userId-${user.id}';
    FirebaseDatabase.instance
        .reference()
        .child('games')
        .child(gameId)
        .set(null);
    http.Response response = await http.get(dataURL);
  }
}
