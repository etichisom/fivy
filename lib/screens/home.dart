

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fivywork3/modalclass/user.dart';
import 'package:fivywork3/screens/message.dart';
import 'package:fivywork3/screens/postjob.dart';
import 'package:fivywork3/screens/profile.dart';
import 'package:fivywork3/screens/proposal.dart';
import 'package:fivywork3/screens/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fivywork3/screens/timeline.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'introscreen.dart';

import 'notification.dart';

class Home extends StatefulWidget {
  User use;
  String token;

  Home({this.use,this.token});

  @override
  _HomeState createState() => _HomeState(use: use,token: token);
}

class _HomeState extends State<Home> {
  User use;
  String token;



  _HomeState({this.use,this.token});

  String uid;
  String email;

  bool theme = false;
  final appbars = [
    'TIMELINE',
    'Notification',
    'Message',
    "Search"
  ];
  int currentindex = 0;
  String dp = "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png";
  String username ;

  String mode = 'Light mode';
  @override
  Widget build(BuildContext context) {
    final tab = [
      Timeline(dp: dp,username: username,token: token,),
      Not(use: use,token: token,),
      Message(mytoken: token,use: use,)


    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentindex,
        selectedItemColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 15,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot),title:Text("timeline"),backgroundColor: Colors.green),
          BottomNavigationBarItem(icon: badge2(context),title:Text("Notification"),backgroundColor: Colors.green),
          BottomNavigationBarItem(icon: badge(context),title:Text("message"),backgroundColor: Colors.green),
          BottomNavigationBarItem(icon: Icon(Icons.search),title:Text("search"),backgroundColor: Colors.green),
        ],
        onTap: (index){
          setState(() {
            currentindex = index;
          });
        },
      ),
      appBar: AppBar(backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: Text(appbars[currentindex],style: TextStyle(color: Colors.black),),
        iconTheme: new IconThemeData(color: Colors.green),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: (){
            Navigator.push(context, CupertinoPageRoute(builder: (context)=>Postjob(user: use,)));
          }
          ),
          IconButton(icon: Icon(Icons.search), onPressed: (){
            Navigator.push(context, CupertinoPageRoute(builder: (context)=>Search(token: token,use: use,)));
          }
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(children: [
          DrawerHeader(child: Container(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(dp),
                  radius: 40,
                ),
                SizedBox(height: 10,),
                Text(username,style: TextStyle(fontSize: 17),)
              ],
            ),
          ),decoration: BoxDecoration(),),
          ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap:(){
                Navigator.push(context,CupertinoPageRoute(builder: (context)=>Profile()));
              }
          ),
          ListTile(
              leading: Icon(Icons.logout),
              title: Text("sign_out"),
              onTap: (){
                signout();
              }



          ),
          ListTile(
            leading: Switch(
              value: theme,
              onChanged: (value){
                setState(() {
                  if(theme==false){
                    theme = true;
                    mode = 'Dark mode';

                  }else{
                    theme=false;
                    mode = 'Light mode';

                  }
                });
                print(theme.toString());
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
            title: Text(mode),

          ),
          ListTile(
            leading: Icon(Icons.work_rounded),
            title: Text("proposal"),
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context)=>Proposal(uid: uid,dp: dp,
                email: email,token: token,username: username,use: use,)));
            },
          ),
        ],),
      ),
      body: tab[currentindex],
    );
  }
  @override
  void initState() {
    // TODO: implement initState.0
    super.initState();

    getinfo();

  }

  getinfo() async{


         setState(() {
           uid = use.uid;
           email = use.email;
           dp = use.dp;
           username = use.fullname;
           token = token;


         });

  }
  void signout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', null);
    FirebaseAuth.instance.signOut()
        .whenComplete(() =>  Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>Intro())));
  }

 Widget badge(BuildContext context) {
    return Stack(
      children: [
        Icon(Icons.message_outlined),
        Positioned(
          top: 0,
          right: 0,
          child: StreamBuilder(
                stream: Firestore.instance.collection('contact').document(uid).collection(uid)
                    .where('read',isEqualTo: false).snapshots(),
              builder:(context,AsyncSnapshot<QuerySnapshot>snapshot){
                 if(snapshot.data == null){
                 return Text('0');
            }else{
           return CircleAvatar(
             radius: 8,
             backgroundColor: Colors.red,
               child: Padding(
                 padding: const EdgeInsets.all(1.0),
                 child: Text(snapshot.data.documents.length.toString(),
                   style: TextStyle(
                       fontSize: 13
                   ),),
               ));
           }
           }
          ),
        ),

      ],
    );
 }
  Widget badge2(BuildContext context) {
    return Stack(
      children: [
        Icon(Icons.notifications),
        Positioned(
          right: 0,
          top: 0,
          child: StreamBuilder(
              stream: Firestore.instance.collection('user').document('notification').collection(uid)
                  .where('isread',isEqualTo: false).snapshots(),
              builder:(context,AsyncSnapshot<QuerySnapshot>snapshot){
                if(snapshot.data == null){
                  return Text('0');
                }else{
                  return CircleAvatar(
                       radius: 8,
                      backgroundColor: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(snapshot.data.documents.length.toString(),
                          style: TextStyle(
                              fontSize: 13
                          ),),
                      ));
                }
              }
          ),
        ),

      ],
    );
  }



}
