import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fivywork3/modalclass/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat.dart';


class Message extends StatefulWidget {
  String mytoken;
   User use;

  Message({this.mytoken,this.use});

  @override
  _MessageState createState() => _MessageState(mytoken: mytoken,use: use);
}

class _MessageState extends State<Message> {

  String mytoken;
  User use;

  _MessageState({this.mytoken,this.use});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection("contact").document(use.uid).collection(use.uid)
            .orderBy('timestamp',descending: true).snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
          if(snapshot.data ==null){

            return CircularProgressIndicator();
          }


          return ListView(

            children: snapshot.data.documents.map((e){
              return Column(
                children: [
                  ListTile(

                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(e['dp']),
                      radius: 25,
                    ),
                    title: Text(e['name']),
                    subtitle: messege(e),
                    onTap: (){
                      print(use.uid);
                      print(e['id']);
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=>Chat(uid: use.uid,
                        rdp: e['dp'],rname: e['name'],ruid: e['ruid'],token: e['token'],mytoken: mytoken,)));
                    },
                    trailing: e['id']==use.uid?readd(e):reead(e),

                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(60, 0, 10, 0),
                    child: Divider(
                      thickness: 2,
                    ),

                  )
                ],
              );
            }).toList(),
          );
        },
      ),
    );

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(use.uid);
  }

 Widget readd(DocumentSnapshot e) {
    if(e['isread'] == true){
      return CircleAvatar(backgroundImage: NetworkImage(e['dp']),radius: 7,);
    }else{
      return Text('');
    }

 }

  reead(DocumentSnapshot e) {
    if(e['read'] == false){
      return CircleAvatar(backgroundColor: Colors.green,child: Text('1'),radius: 10,);
    }else{
      return Text('');
    }
  }

 Widget messege(DocumentSnapshot e) {
    if(e['type'] == 1){
      return Text(e['message']);
    }else if(e["type"]==2){
      return Row(
        children: [
          Icon(Icons.photo,color: Colors.grey,),
          Text('Photo')
        ],
      );
    }else if(e['type']==3){
      return  Row(
        children: [
          Icon(Icons.videocam_rounded,color: Colors.grey,),
          Text('Video')
        ],
      );
    }
 }


}



