import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:zerokata/constants.dart';
import 'package:zerokata/user.dart';
import 'package:google_fonts/google_fonts.dart';

final primaryColor = const Color(0xFF616161);
class UserList extends StatefulWidget {
  final String title;

  UserList({Key key, this.title}) : super(key: key);

  @override
  UserListState createState() => UserListState();
}

class UserListState extends State<UserList> {
  List<User> _users = List<User>();
  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    print('build');

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title,style: GoogleFonts.amaticaSc(color:Colors.black ,fontSize: 28,fontWeight: FontWeight.w700,),),
          backgroundColor: Colors.grey[800],
          centerTitle: true,
        ),
        body:
        ListView.builder(
            itemCount: _users.length, itemBuilder: _buildListRow));
  }

  Widget _buildListRow(BuildContext context, int index) => Container(
   child: Padding(
     padding: const EdgeInsets.fromLTRB(8,5,8,0),
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
                  height:55,width:55,
                  child:CircleAvatar(
                      backgroundColor: Colors.blue[200],
                      backgroundImage: NetworkImage('${(_users[index]?.photoUrl == null)
                      ? 'https://www.nicepng.com/png/detail/933-9332131_profile-picture-default-png.png'
                          : _users[index].photoUrl}'),)
                  ),
              SizedBox(
                width: 10,
              ),
              Text('${_users[index].name}', style: GoogleFonts.amaticaSc(color:Colors.black ,fontSize: 26,fontWeight: FontWeight.w600,),),
              Spacer(),
              RaisedButton(
                elevation: 10,
                color: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(1,1,1,2),
                  child: Text('Invite',style: GoogleFonts.amaticaSc(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600)),
                ),
                onPressed: (){
                  Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('clicked on ${_users[index].name}')));
                },
              ),
//              IconButton(
//              icon: Icon(Icons.videogame_asset),
//              color: Colors.white,
//              onPressed: () {
//                Scaffold.of(context).showSnackBar(
//                  SnackBar(content: Text('clicked on ${_users[index].name}')));
//              })
              ],
              ),
              ),
              ),],
              ),
   ));

//  Widget _buildListRow(BuildContext context, int index) => Container(
//      height: 56.0,
//      child: InkWell(
//          onTap: () {
//            Scaffold.of(context).showSnackBar(
//                SnackBar(content: Text('clicked on ${_users[index].name}')));
//          },
//          child: Container(
//              padding: EdgeInsets.all(16.0),
//              alignment: Alignment.centerLeft,
//              child: Text(
//                '${_users[index].name}',
//                style: TextStyle(fontSize: 18.0),
//              ))));

  void _fetchUsers() async {
    var snapshot =
    await FirebaseDatabase.instance.reference().child('users').once();
    Map<String, dynamic> users = snapshot.value.cast<String, dynamic>();
    users.forEach((userId, userMap) {
      User user = _parseUser(userId, userMap);
      setState(() {
        _users.add(user);
      });
    });
  }

  User _parseUser(String userId, Map<dynamic, dynamic> user) {
    String name, photoUrl, pushId;
    user.forEach((key, value) {
      if (key == Constants.NAME) {
        name = value as String;
      }
      if (key == Constants.PHOTO_URL) {
        photoUrl = value as String;
      }
      if (key == Constants.PUSH_ID) {
        pushId = value as String;
      }
    });

    return User(userId, name, photoUrl, pushId);
  }
}