
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:fivywork3/screens/home.dart';
import 'package:fivywork3/screens/introscreen.dart';
import 'package:fivywork3/screens/loging.dart';
import 'package:fivywork3/screens/setup.dart';
import 'package:fivywork3/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,));
  runApp(Myapp());

}
class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,


      home: Main(),
    );
  }

}
class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  bool auth = false;
  String mode = 'Light mode';
  String uid;

  @override
  Widget build(BuildContext context) {
    return auth==true?Splash(uid: uid,)
        :Login();
  }
  @override
  void initState() {
    // TODO: implement initState.0
    super.initState();
    handleauth();

  }

  void handleauth() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   String uuid = await prefs.getString('uid');
    if(uuid != null){
      setState(() {
        uid =uuid;
        auth = true;
      });
    }else{
      setState(() {
        auth = false;
      });
    }
  }

}


