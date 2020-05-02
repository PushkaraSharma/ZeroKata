import 'package:flutter/material.dart';
import 'package:zerokata/ai_mode/Game.dart';
import 'package:zerokata/offline_mode/offline_play.dart';
import 'package:zerokata/online_mode/online.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:zerokata/startup_screens/FirstView.dart';
import 'package:zerokata/constants.dart';
import 'package:zerokata/Users/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zerokata/util.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../Users/user_list.dart';



final primaryColor = const Color(0xFF616161);

class FirstViewState extends State<FirstView> {
  final FirebaseMessaging _firebaseMessaging =  FirebaseMessaging();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");
        handleMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
        handleMessage(message);
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
        handleMessage(message);
      },
    );
    _firebaseMessaging.getToken().then((token){
      print(token);
    });
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    updateFcmToken();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height =  MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        color: primaryColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: height*0.04,),
                AutoSizeText('ZERO KATA',maxLines:1,style: GoogleFonts.amaticaSc(color:Colors.black ,fontSize: 60,fontWeight: FontWeight.w700)),
                SizedBox(height: height*0.06,),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: AvatarGlow(
                      endRadius: 170,
                      duration: Duration(seconds: 2),
                      glowColor: Colors.white,
                      repeat: true,
                      repeatPauseDuration: Duration(seconds: 1),
                      startDelay: Duration(seconds: 1),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              style: BorderStyle.none,
                            ),
                            shape: BoxShape.circle),
                        child: CircleAvatar(
                          backgroundColor: primaryColor,
                          child: Container(
                            child: new Image.asset(
                              'lib/images/tictactoelogo.png',
                              color: Colors.black,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          radius: 80.0,
                        ),
                      ),
                    ),
                  ),
                ),
               // Text("Let's go back to childhood",textAlign: TextAlign.center,style: TextStyle(fontSize: 38,color: Colors.white,),),
                SizedBox(height: height*0.05,),
                RaisedButton(
                  elevation: 10,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15,10,15,10),
                    child: AutoSizeText('Play with A.I.',maxLines: 1,style: GoogleFonts.amaticaSc(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w600)),
                  ),
                  onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) =>  Game(title: 'ZeroKata v/s A.I.')));
                  },
                ),
                SizedBox(height: height*0.03,),
                RaisedButton(
                  elevation: 10,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15,10,15,10),
                    child: AutoSizeText('Play Offline',maxLines: 1,style: GoogleFonts.amaticaSc(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w600)),
                  ),
                  onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) =>  Offline(title: 'ZeroKata Offline')));
                  },
                ),
                SizedBox(height: height*0.03,),
                RaisedButton(
                  elevation: 10,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15,10,15,10),
                    child: AutoSizeText('Play Online',maxLines: 1,style: GoogleFonts.amaticaSc(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w600)),
                  ),
                  onPressed: (){
                    openUserList();
                    },
                ),
                SizedBox(height: height*0.05,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showItemDialog(BuildContext context, Map<String, dynamic> message) {
    print(context == null);

    print('show dialog ');

    new Timer(const Duration(milliseconds: 200), (){
      showDialog<bool>(
        context: context,
        builder: (_) => buildDialog(context, message),
      );

//      Navigator.of(context).pushNamed('singleGame');
    });
  }

  Widget buildDialog(BuildContext context, Map<String, dynamic> message) {
    var noti = (message["data"]);
    var fromName = noti['fromName'];
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Stack(children: <Widget>[
          Container(width: 400,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [BoxShadow(
                        color: Colors.black, blurRadius: 30)]),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 5,),
                    AutoSizeText(
                      '$fromName has invited you to play!',maxLines: 2,textAlign: TextAlign.center,style: GoogleFonts.amaticaSc(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w700,),),
                    SizedBox(height: 20,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 20,),
                        RaisedButton(elevation: 8,
                            color: Colors.black,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Padding(padding: const EdgeInsets.fromLTRB(8,5,8,5),
                              child: AutoSizeText("Accept",maxLines:1,style: GoogleFonts.amaticaSc(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700,)),),
                            onPressed: () {
                              accept(message);}
                              ),
                        Spacer(),
                        RaisedButton(elevation: 8,
                            color: Colors.black,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Padding(padding: const EdgeInsets.fromLTRB(10,7,10,7),
                              child: AutoSizeText("Decline",maxLines:1,style: GoogleFonts.amaticaSc(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700,)),),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        SizedBox(width: 20,),
                      ])
                  ]))])
             );}


  Future<FirebaseUser> _signInWithGoogle() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    FirebaseUser user = authResult.user;
    print("signed in " + user.displayName);
    return user;
  }

  void openUserList() async {
    FirebaseUser user = await _signInWithGoogle();
    await saveUserToFirebase(user);
    print("sae user ok");
//    Navigator.of(context).pushNamed('userList');
    Navigator.push(context,MaterialPageRoute(builder: (context) =>  UserList(title: 'Registered Players')));
  }

  Future<void> saveUserToFirebase(FirebaseUser user) async {
    print('saving user to firebase');
    var token = await _firebaseMessaging.getToken();
    await saveUserToPreferences(user.uid, user.displayName, token);
    var update = {
      NAME: user.displayName,
      PHOTO_URL: user.photoUrl,
      PUSH_ID: token
    };
    return FirebaseDatabase.instance.reference().child('users').child(user.uid).update(update);

  }
  saveUserToPreferences(String userId, String userName, String pushId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_ID, userId);
    prefs.setString(PUSH_ID, pushId);
    prefs.setString(USER_NAME, userName);
  }


  void updateFcmToken() async {
    var currentUser = await _auth.currentUser();
    if (currentUser != null) {
      var token = await _firebaseMessaging.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(PUSH_ID, token);
      FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(currentUser.uid)
          .update({PUSH_ID: token});
      print('updated FCM token');
    }
  }

  void accept(Map<String, dynamic> message) async {
    var noti = (message["data"]);
    String fromPushId = noti['fromPushId'];
    String fromId = noti['fromId'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString(USER_NAME);
    var pushId = prefs.getString(PUSH_ID);
    var userId = prefs.getString(USER_ID);
   // username = username.replaceAll(' ','_');

    var base = 'https://us-central1-zerokata-bf5ca.cloudfunctions.net';
    String dataURL =
        '$base/sendNotification2?to=$fromPushId&fromPushId=$pushId&fromId=$userId&fromName=$username&type=accept';
    print(dataURL);
    http.Response response = await http.get(dataURL);

    String gameId = '$fromId-$userId';

    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => new Online(
            title: 'Tic Tac Toe',
            type: "wifi",
            me: 'O',
            gameId: gameId,
            withId: fromId)));
  }

  void handleMessage(Map<String, dynamic> message) async {
    var noti = (message["data"]);
    var type = noti['type'];
    var fromId = noti['fromId'];
    print(fromId);
    print(type);
    if (type == 'invite') {
      showItemDialog(context, message);
    } else if (type == 'accept') {
      var currentUser = await _auth.currentUser();
      Navigator.pop(context);
      String gameId = '${currentUser.uid}-$fromId';
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) => new Online(
              title: 'Online ZeroKata',
              type: "wifi",
              me: 'X',
              gameId: gameId,
              withId: fromId)));
    } else if (type == 'reject') {}
  }

}
