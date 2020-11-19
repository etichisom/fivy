import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fivywork3/modalclass/user.dart';
import 'package:fivywork3/screens/profile.dart';
import 'package:fivywork3/screens/proposal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Not extends StatefulWidget {
 User use;
 String token;


 Not({this.use, this.token});



  @override
  _NotState createState() => _NotState(use:use,token: token);
}

class _NotState extends State<Not> {
  User use;
  String token;


  _NotState({this.use, this.token});





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('user').document('notification').collection(use.uid).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.data == null){
            return Center(child: Text('empty'));
          }

          return ListView(
            children:snapshot.data.documents.map((e) {

              return Column(
                children: [
                  ListTile(
                    title: Text(e['body']),
                    leading: CircleAvatar(backgroundImage: NetworkImage(e['dp']),),
                    onTap: (){
                      isread(e);
                      if(e['type']=='1'){
                        Navigator.push(context, CupertinoPageRoute(builder: (context)=>Profile()));
                      }else if(e['body']=='2'){
                        Navigator.push(context, CupertinoPageRoute(builder: (context)=>Proposal(
                            uid: use.uid,username: use.fullname,dp: use.dp,email:use.email,token: token
                        )));
                      }
                    },
                  ),
                  Divider()
                ],
              ) ;
            }).toList(),
          );
        },
      ),
    );
  }

   isread(DocumentSnapshot e)async {
    Firestore.instance.collection('user').document('notification').collection(use.uid)
        .document(e['nid']).updateData({"isread":true}).catchError((e)=>print(e));
   }
}
