import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fivywork3/modalclass/user.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat.dart';


class Search  extends StatefulWidget {
  String token;
  User use;


  Search({this.token,this.use});

  @override
  _SearchState createState() => _SearchState(token: token,use: use);
}

class _SearchState extends State<Search> {
 User use;
 String token;
 String name;


  _SearchState({this.token,this.use});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(icon: Icon(Icons.clear,color: Colors.black,), onPressed:(){Navigator.pop(context);}),
        title: TextField(
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              border: UnderlineInputBorder(),
              prefixIcon: Icon(Icons.person_search)
          ),
          onChanged: (va){
            setState(() {
              name = va;
            });
            },
        ),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('users').where('name',isLessThanOrEqualTo: name).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot>snapshot){
            if(!snapshot.hasData){
         return Center(child: CircularProgressIndicator());
         }
              return Container(

                height:600,
                child: ListView(

                children: snapshot.data.documents.map((e){
                 User u = User.fromDocument(e);
                 return Container(

                   child: Column(
                    children: [
                        ListTile(

                          leading:  CircleAvatar(backgroundImage: NetworkImage(u.dp),radius: 30,),
                          title: Text(u.fullname),
                          subtitle: Text(u.skills),
                          onTap:(){

                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Chat(uid: use.uid
                              ,ruid:u.uid,
                              rname: u.fullname,rdp: u.dp,token: u.token,use: use,)));
                          }
                        ),

                     ],
                 ),
                 );
        }).toList(),
                ),
              );
            }




          ),

    );
  }

}

