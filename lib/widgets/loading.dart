
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

final primaryColor = const Color(0xFF616161);
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitRotatingCircle(color: Colors.white,),
          Text('Loading',style: GoogleFonts.amaticaSc(color:Colors.white ,fontSize: 28,fontWeight: FontWeight.w700,),)
        ],
      ),
    );
  }
}
