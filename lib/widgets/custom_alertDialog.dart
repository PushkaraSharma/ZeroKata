import 'package:flutter/material.dart';
import 'package:zerokata/startup_screens/FirstView.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomDialog extends StatelessWidget {
  final String title,descrip,type;
  final primaryColor = const Color(0xFF616161);
  CustomDialog({
    @required this.title,@required this.descrip,this.type
  });
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
    child:Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Stack(children: <Widget>[
        Container(width: 600,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    blurRadius: 30
                )
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 15,),
              AutoSizeText(
                title,maxLines: 1,textAlign: TextAlign.center,style: GoogleFonts.amaticaSc(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w700,),
              ),
              SizedBox(height: 15,),
              AutoSizeText(
                descrip,maxLines:1,textAlign: TextAlign.center,style: TextStyle(color:Colors.white,fontSize: 80.0,fontFamily: 'Chalk'),
              ),
              SizedBox(height: 4,),
              showTextForAI(context),
              SizedBox(height: 12,),
              showPrimaryButton(context),
              SizedBox(height: 10,),
              showSecondButton(context)
            ],
          ),
        )
      ],),
    ));
  }
  showTextForAI(BuildContext context){
    if(type=='ai' && descrip=="LOOSE")
      {
        return AutoSizeText("Cant you beat a bot.Lets try once more",maxLines:1,style: GoogleFonts.amaticaSc(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600,));
      }
    else{return SizedBox(height: 0.0,);}
  }
  showPrimaryButton(BuildContext context){
    String button = 'Play Again';
    if(type=='exit')
      {button = 'NO';}
      return  RaisedButton(
        elevation: 8,
          color: Colors.black,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12,7,12,7),
            child: AutoSizeText(button,maxLines:1,style: GoogleFonts.amaticaSc(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700,)),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }
      );}

  showSecondButton(BuildContext context) {
    String button = 'Exit';
    if(type=='exit')
    {button = 'YES';}
      return FlatButton(
        child: AutoSizeText(button,maxLines: 1,style: GoogleFonts.amaticaSc(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w700,)),
        onPressed: () {
          Navigator.of(context).pop();
          //Navigator.push(context,MaterialPageRoute(builder: (context) =>  FirstView()));
          Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => FirstView()),
                (Route<dynamic> route) => false,);
        });
    }
  }

