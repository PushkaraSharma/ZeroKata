import 'package:flutter/material.dart';
import 'package:zerokata/ai_mode/Game.dart';
import 'package:zerokata/offline_mode/offline_play.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:zerokata/startup_screens/FirstView.dart';
import 'package:zerokata/constants.dart';
import 'dart:async';

import '../user_list.dart';



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
//        _showItemDialog(context, message);
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
        Navigator.pushNamed(context, 'singleGame');
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
//        _showItemDialog(context, message);
      },
    );
    _firebaseMessaging.getToken().then((token){
      print(token);
    });
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _updateFcmToken();
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
                Text('ZERO KATA',style: GoogleFonts.amaticaSc(color:Colors.black ,fontSize: 60,fontWeight: FontWeight.w700)),
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
                    child: Text('Play with A.I.',style: GoogleFonts.amaticaSc(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w600)),
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
                    child: Text('Play Offline',style: GoogleFonts.amaticaSc(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w600)),
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
                    child: Text('Play Online',style: GoogleFonts.amaticaSc(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w600)),
                  ),
                  onPressed: (){
                    openUserList();
//                    _signInWithGoogle().then((user) {
//                      _saveUserToFirebase(user);
//                     });
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

  void _showItemDialog(BuildContext context, Map<String, dynamic> message) {
    print(context == null);

    print('show dialog ');

    new Timer(const Duration(milliseconds: 200), (){
      showDialog<bool>(
        context: context,
        builder: (_) => _buildDialog(context),
      );

//      Navigator.of(context).pushNamed('singleGame');
    });
  }

  Widget _buildDialog(BuildContext context) {
    return new AlertDialog(
      content: new Text("Some text"),
      actions: <Widget>[
        new FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        new FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

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

//    var user = await _auth.currentUser();
//    if (user == null) {
//      GoogleSignInAccount googleUser = _googleSignIn.currentUser;
//      if (googleUser == null) {
//        googleUser = await _googleSignIn.signInSilently();
//        if (googleUser == null) {
//          googleUser = await _googleSignIn.signIn();
//        }
//      }
//
//      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//        final FirebaseUser user = await _auth.signInWithGoogle(
//        accessToken: googleAuth.accessToken,
//        idToken: googleAuth.idToken,
//      );
//      print("signed in " + user.displayName);
//    }
//
//    return user;
//  }
  void openUserList() async {
    FirebaseUser user = await _signInWithGoogle();
    await _saveUserToFirebase(user);
    print("sae user ok");
//    Navigator.of(context).pushNamed('userList');
    Navigator.push(context,MaterialPageRoute(builder: (context) =>  UserList(title: 'All users')));
  }

  Future<void> _saveUserToFirebase(FirebaseUser user) async {
    print('saving user to firebase');
    var token = await _firebaseMessaging.getToken();
    var update = {
      Constants.NAME: user.displayName,
      Constants.PHOTO_URL: user.photoUrl,
      Constants.PUSH_ID: token
    };
    return FirebaseDatabase.instance.reference().child('users').child(user.uid).update(update);

  }

  // Not sure how FCM token gets updated yet
  // just to make sure correct one is always set
  void _updateFcmToken() async {
    var currentUser = await _auth.currentUser();
    if (currentUser != null) {
      var token = await _firebaseMessaging.getToken();
      FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(currentUser.uid)
          .update({Constants.PUSH_ID: token});
      print('updated FCM token');
    }
  }
}
