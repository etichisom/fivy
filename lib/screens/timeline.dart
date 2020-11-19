

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fivywork3/modalclass/post.dart';
import 'package:fivywork3/modalclass/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_counter/flutter_counter.dart';


import 'package:google_fonts/google_fonts.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:readmore/readmore.dart';


class Timeline extends StatefulWidget {
  String username;
  String dp;
  String token;


  Timeline({this.username, this.dp,this.token});

  @override
  _TimelineState createState() => _TimelineState(dp: dp,username: username,token: token);
}

class _TimelineState extends State<Timeline> {

  String username;
  String dp;
  String token;

  _TimelineState({this.username, this.dp,this.token});

  ProgressDialog p;
  String uid;
  int ammout = 100;
  String dec;
  List<String>dtime=[
    "1 day",'2 days','3 days','4 days','5 days','6 days','1 week'
  ];
  String duration = "1 day";

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    p =ProgressDialog(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Wrap(
              children: [

                mychip('repairs',Colors.blue),
                mychip('assignment',Colors.deepOrange),
                mychip('motion graphics',Colors.lightBlue),
                mychip('sound engineer',Colors.deepPurple)

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(

              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  hintText: "What are you looking for",
                ),
              ),
            ),
          ),
          Flexible(

            child: Container(

              child: StreamBuilder(
                stream: Firestore.instance.collection("jobs").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator());


                  }
                  return ListView(

                      children: makelist(snapshot, context, key)
                  );
                },
              ),
            ),
          )

        ],
      ),

    );
  }

  List<Widget> makelist(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context, GlobalKey<ScaffoldState> key) {
    return snapshot.data.documents.map<Widget>((doc) {
      Post post = Post.fromdocument(doc);
      return FutureBuilder(
          future:Firestore.instance.collection("users").document(post.uid).get() ,
          builder: (context,snapshot){
            if(!snapshot.hasData){
               return Center(child: CircularProgressIndicator());
            }
            User u = User.fromDocument(snapshot.data);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.all(Radius.circular(15)),
                 color: Colors.white,
                 border: Border.all(
                   width: 1,
                   color: Colors.green

                 ),

               ),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(u.dp),radius: 25,),
                      title: Text(u.fullname,style: GoogleFonts.lato(fontSize: 18),),
                      subtitle: Text(post.timestamp),

                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                        child: Column(

                          children: [


                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ReadMoreText(
                                post.desc,
                                trimLines: 4,
                                colorClickableText: Colors.blue,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: '...Show more',
                                trimExpandedText: ' show less',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(

                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                              child: SizedBox( width: 300,height: 25,
                                  child: OutlineButton(
                                    child: Text('Offers sent :'+post.offers.toString()),
                                  )),
                            ),
                            Row(
                              children: [
                                Icon(Icons.access_time,color: Colors.grey,),
                                SizedBox(width: 10,),
                                Text("Duration",style: TextStyle(color: Colors.grey),),
                                SizedBox(width: 20,),
                                Text(post.devday)

                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Icon(Icons.monetization_on,color: Colors.grey,),
                                SizedBox(width: 10,),
                                Text("Budget",style: TextStyle(color: Colors.grey),),
                                SizedBox(width: 20,),
                                Text("N"+post.budget)

                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Icon(Icons.category,color: Colors.grey,),
                                SizedBox(width: 10,),
                                Text("Cartegory",style: TextStyle(color: Colors.grey),),
                                SizedBox(width: 20,),
                                Text(post.cartigory)

                              ],
                            ),
                            SizedBox(width: 350,
                              child: StreamBuilder(
                                  stream: Firestore.instance.collection('offers').document('postoffer')
                                  .collection(post.postid).where("uid",isEqualTo: uid).snapshots(),
                                  builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
                                    if(snapshot.data == null){
                                      return CircularProgressIndicator();
                                    }

                                    if(snapshot.data.documents.length>0||post.uid==uid){
                                       return RaisedButton(onPressed:null,color: Colors.green,child: Text('Bid for job'),);
                                    }
                                    return RaisedButton(onPressed: (){
                                           return showDialog(
                                               context:context,
                                               builder: (context){
                                                 return StatefulBuilder(builder: (context,setState){
                                                   return AlertDialog(
                                                     title: Center(child: Text("SEND OFFER",style:GoogleFonts.aclonica(color: Colors.green),)),
                                                     shape: RoundedRectangleBorder(
                                                         borderRadius: BorderRadius.circular(10)
                                                     ),
                                                     content:Container(
                                                       width: double.maxFinite,
                                                       height: 270,
                                                       child: ListView(
                                                         children: [

                                                           Counter(initialValue: ammout, minValue: ammout,
                                                             maxValue: 500000, onChanged: (am){
                                                               setState((){
                                                                 ammout = am;
                                                               });
                                                             }, decimalPlaces: 1,step: 100,color: Colors.green,),
                                                           SizedBox(height: 0,),
                                                           Text("N"+ ammout.toString()),
                                                           Row(
                                                             children: [


                                                               Text("Delivery date",
                                                                 style: TextStyle(fontSize: 15,
                                                                     fontWeight: FontWeight.bold,color: Colors.lightBlueAccent),),

                                                               DropdownButton<String>(items: dtime.map<DropdownMenuItem<String>>((e){
                                                                 return DropdownMenuItem(child: Text(e),
                                                                   value: e,

                                                                 );
                                                               }).toList(),


                                                                 onChanged: (e){
                                                                   setState(() {
                                                                     duration = e;
                                                                     print(duration);
                                                                   });
                                                                 },
                                                                 value: duration,
                                                               ),

                                                             ],
                                                           ),
                                                           TextFormField(
                                                             onChanged: (va){
                                                               setState(() {
                                                                 dec = va ;
                                                               });
                                                             },

                                                             decoration: InputDecoration(
                                                                 labelText: 'Decription',
                                                                 border:UnderlineInputBorder()
                                                             ),
                                                           ),
                                                           SizedBox(height: 10,),
                                                           SizedBox(
                                                             width: 300,
                                                             child: RaisedButton(onPressed: (){
                                                               String nid = DateTime.now().microsecondsSinceEpoch.toString();
                                                               print(dec);
                                                               print(uid);
                                                               print(duration);
                                                               print(ammout);

                                                               if(dec.length < 50){
                                                                 print('less');
                                                               }else{
                                                                 p.show();
                                                                 Firestore.instance.collection("offers")
                                                                     .document('postoffer').collection(post.postid)
                                                                     .document(uid).setData(
                                                                     {
                                                                       'description':dec,
                                                                       'duration':duration,
                                                                       'postid':post.postid,
                                                                       'uid':uid,
                                                                       'amount':ammout,
                                                                       'name':u.fullname,
                                                                       'time':DateTime.now().toString(),
                                                                       'token':u.token,


                                                                     }
                                                                 ).whenComplete((){
                                                                   Firestore.instance.collection("bid")
                                                                       .document(uid).collection('mybid')
                                                                       .document(post.postid).setData(
                                                                       {
                                                                         'description':dec,
                                                                         'duration':duration,
                                                                         'postid':post.postid,
                                                                         'uid':uid,
                                                                         'amount':ammout

                                                                       }
                                                                   ).whenComplete((){
                                                                     Firestore.instance.collection("user")
                                                                         .document('notification').collection(u.uid)
                                                                         .document(nid).setData(
                                                                         {
                                                                           "body":'You have a new proposal from '+ username,
                                                                           "type":'2',
                                                                           'uid':uid,
                                                                           'dp':dp,
                                                                           'token':u.token,
                                                                           "isread":false,
                                                                           "nid":nid

                                                                         }

                                                                     ).catchError((err){
                                                                       print(err);
                                                                     });

                                                                     setState((){
                                                                       dec = null;
                                                                       duration = null;
                                                                       ammout = 100;


                                                                     });
                                                                     update(post.postid);
                                                                     p.hide();
                                                                     Navigator.pop(context);
                                                                   });

                                                                 }).catchError((e){print('error');});
                                                               }
                                                             },
                                                               color: Colors.green,
                                                               shape: RoundedRectangleBorder(
                                                                   borderRadius: BorderRadius.all(Radius.circular(20))
                                                               ),

                                                               child: Text('Send'),),
                                                           ),
                                                           SizedBox(width: 300,
                                                             child: OutlineButton(onPressed: (){
                                                               Navigator.pop(context);
                                                               setState((){
                                                                 dec = null;
                                                                 ammout = 100;
                                                                 duration = null;


                                                               });
                                                             },
                                                               child: Text("cancel"),),)

                                                         ],
                                                       ),

                                                     ),
                                                   );
                                                 });
                                               }
                                           );

                                         },
                                           child: Text("Bid for job",
                                             style: TextStyle(color: Colors.white),),color: Colors.green,);
                                  })
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),

              ),
            );
          }
      );
    }).toList();

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getstuff();

  }

  getstuff() {
    FirebaseAuth.instance.onAuthStateChanged.listen((event) {
      setState(() {
        uid = event.uid;
        print(uid);
      });
    });
  }

  Widget store() {



  }

  void update(String uid) async {
   Firestore.instance.collection("offers")
        .document('postoffer').collection(uid).getDocuments().then((value) {
         print(value.documents.length);
         Firestore.instance.collection('jobs').document(uid).updateData({'offers':value.documents.length.toString()})
         .then((value) => print('updated')).catchError((e){print(e);});
    }).catchError((e){
      print(e.toString());
   });
  }

 Widget mychip(String s,MaterialColor colour) {

    return  Padding(
      padding: const EdgeInsets.fromLTRB(1, 0, 1, 1),
      child: Tooltip(
        message: s,
        child: ActionChip(label:Text(s) ,avatar: CircleAvatar(backgroundColor: Colors.white70,),
        onPressed: (){},backgroundColor:colour,shadowColor: Colors.grey,elevation: 4,),
      ),
    );

 }










}
