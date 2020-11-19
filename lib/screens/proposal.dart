import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fivywork3/modalclass/post.dart';
import 'package:fivywork3/modalclass/user.dart';
import 'package:fivywork3/screens/reviewoffer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';


class Proposal extends StatefulWidget {
  String uid;
  String username;
  String dp;
  String email;
  String token;
  User use;
  Proposal({this.uid, this.username, this.dp, this.email,this.token,this.use});



  @override
  _ProposalState createState() => _ProposalState(uid: uid,username: username,dp: dp,email: email,token: token,use: use);
}

class _ProposalState extends State<Proposal> {
  String uid;
  String username;
  String dp;
  String email;
  String token;
  User use;



  _ProposalState({this.uid, this.username, this.dp,this.email,this.token,this.use});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: Firestore.instance.collection('jobs').where("uid",isEqualTo: uid).snapshots(),
          builder:(context,AsyncSnapshot<QuerySnapshot>snapshot){
            if(snapshot.data==null){
              return CircularProgressIndicator();
            }
            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }
            return ListView(
              children: snapshot.data.documents.map((e)
              {
                Post p = Post.fromdocument(e);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: Colors.green

                      ),

                      color: Colors.white,

                    ),
                    child: Column(

                      children: [
                        ListTile(
                          leading: CircleAvatar(backgroundImage: NetworkImage(dp),),
                          title: Text(username),
                          subtitle: Text(p.timestamp),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                            ),
                            child:  ReadMoreText(
                              p.desc,
                              trimLines: 4,
                              colorClickableText: Colors.blue,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: '...Show more',
                              trimExpandedText: ' show less',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: OutlineButton(onPressed: (){
                            Navigator.push(context, CupertinoPageRoute(builder: (context)=>Roffers(uid: uid,
                              postid: p.postid,email: email,use: use,)));
                          },
                            child: Text('number of offers : '+ p.offers),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    print(uid);
    print(dp);
    print(username);
    print(email);
  }

 }
