

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fivywork3/screens/userprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'basicinfo.dart';




class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String uid;
  CollectionReference user = Firestore.instance.collection('user');


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar:AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),

          brightness: Brightness.light,
          bottom: TabBar(tabs: [

            Tab(text: "profile",)
            ,Tab(text: "basic information",)
          ],
          labelColor: Colors.black,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 5.0),
                insets: EdgeInsets.symmetric(horizontal:16.0)
            ),
          ),
        ) ,
        backgroundColor: Colors.white,

        body:TabBarView(children: [
          userprof(),
          Info()
        ],)
        ),

    );
  }



}
