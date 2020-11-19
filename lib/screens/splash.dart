import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fivywork3/modalclass/user.dart';
import 'package:fivywork3/screens/home.dart';
import 'package:fivywork3/screens/loging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatefulWidget {
  String uid;


  Splash({this.uid});

  @override
  _SplashState createState() => _SplashState(uid: uid);
}

class _SplashState extends State<Splash> {
  String uid;
  String uuid;
  String err;
  String token;
  User use;
  BuildContext cxt;


  _SplashState({this.uid});

  @override
  Widget build(BuildContext context) {
    cxt = context;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Center(child: Row(
          children: [
            Text('Fivy the real app best app in the world you that right ',style: GoogleFonts.aladin(fontSize: 90,color: Colors.white),),
          ],
        ))
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    getinfo();
  }

   getinfo()async {

   FirebaseMessaging().getToken().then((value){
      setState(() {
        token = value;
      });
      print(token);
    }).catchError((e)=>print(e));
   await Firestore.instance.collection('users').document(uid).get().then((value) {
      use = User.fromDocument(value);
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (cxt)=>Home(use: use,token: token,)));


    }).catchError((e){
      String error=e.toString();
      dialog('something went wrong', uid, cxt);


      print(e);

    });

   }
  dialog(String title,String text,BuildContext context){
    return showDialog(context: context
        ,builder: (context){
          return CupertinoAlertDialog(
            title: Text(title),
            content:Text(text) ,
            actions: [
              CupertinoDialogAction(onPressed: (){
                Navigator.pop(context);
               }
               ,child: Text('cancel'),)

            ],
          );
        });
  }


}
