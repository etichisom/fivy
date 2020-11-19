import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fivywork3/modalclass/user.dart';
import 'package:fivywork3/screens/pay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_read_more_text/flutter_read_more_text.dart';


import 'card.dart';
import 'chat.dart';



class Roffers extends StatefulWidget {
  String uid;
  String postid;
  String email;
  User use;

  Roffers({this.uid, this.postid,this.email,this.use});

  @override
  _RoffersState createState() => _RoffersState(uid: uid,postid: postid,email: email,use: use);
}

class _RoffersState extends State<Roffers> {
  String uid;
  String postid;
  String email;
  String amount;
  User use;



  _RoffersState({this.uid, this.postid,this.email,this.use});

  User u ;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review offers'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('offers').document('postoffer').collection(postid).snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.data == null){
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
              children: snapshot.data.documents.map((e){
                return buildlist(context, e);
              }).toList(),
          );
        },
      ),
    );
  }

  Widget buildlist(BuildContext context, DocumentSnapshot doc) {

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
         child: Column(
           children: [
             FutureBuilder(

               future: Firestore.instance.collection('users').document(doc['uid']).get(),
                 builder: (context,snapshot){
                   if(!snapshot.hasData){
                     return Center(child: CircularProgressIndicator());
                   }
                   u   =   User.fromDocument(snapshot.data);

                   return ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(u.dp),),
                     title: Text(u.fullname),
                     subtitle: Text(doc['time']),
                   );
                 }
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
                child: Container(
                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey),
                 child: ReadMoreText(doc['description']),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Row(
                 children: [
                   Icon(Icons.access_time,color: Colors.grey,),
                   SizedBox(width: 10,),
                   Text("Duration",style: TextStyle(color: Colors.grey),),
                   SizedBox(width: 20,),
                   Text(doc['duration'])

                 ],
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   SizedBox(
                     width: 200,
                       child: RaisedButton(onPressed:(){
                         Navigator.push(context, CupertinoPageRoute(builder: (context)=>pay(doc: doc,u: u,myu: use,)));

                       },
                         child: Text('Order'+'('+doc['amount'].toString()+')'),
                       )),
                   SizedBox(
                       child: OutlineButton(onPressed:(){
                         Navigator.push(context, CupertinoPageRoute(builder: (context)=>Chat(uid: uid,ruid:doc['uid'],
                           rname: u.fullname,rdp: u.dp,)));
                        },
                         child: Text('Message'),
                       )),

                 ],
               ),
             )
           ],
         ),
     ),
      );
  }
}
