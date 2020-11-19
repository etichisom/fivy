import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fivywork3/modalclass/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dp.dart';


class userprof extends StatefulWidget {
  @override
  _userprofState createState() => _userprofState();
}

class _userprofState extends State<userprof> {
  String uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream:Firestore.instance.collection("users").document(uid).snapshots() ,
         builder: (context,AsyncSnapshot<DocumentSnapshot>snapshot){
           if(snapshot.connectionState == ConnectionState.waiting){
             return CircularProgressIndicator();
           }else if(snapshot.hasError){
             return CircularProgressIndicator();
           }else if(snapshot.hasData){
             User u = User.fromDocument(snapshot.data);
             return Padding(
               padding: const EdgeInsets.all(0.0),
               child: ListView(
                 children: [
                   Stack(
                     children: [
                       Container(
                         height: 205,



                       ),
                       Container(

                         height: 150,
                         width: 400,
                         color: Colors.blue,

                       ),
                       Positioned(
                         top: 60,
                         right: 75,
                         left: 75,
                         child: GestureDetector(
                           onTap: (){
                             Navigator.push(context, CupertinoPageRoute(builder: (context)=>Dp(u.dp,u.fullname)));
                           },
                           child: CircleAvatar(
                             backgroundColor: Colors.white,
                             radius: 70,
                             child: Hero(
                               tag: "ok",
                               child: CircleAvatar(
                                 backgroundImage: NetworkImage(u.dp),
                                 radius: 65,
                               ),
                             ),
                           ),
                         ),
                       )
                     ],
                   ),
                   Center(child: Text(u.fullname,style:GoogleFonts.aclonica(fontSize: 20),),),
                   Padding(
                     padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                     child: Center(child: Text(u.school,style:GoogleFonts.aclonica(fontSize: 10),),),
                   ),
                   Padding(
                     padding: const EdgeInsets.fromLTRB(15, 10, 20, 10),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [

                       SizedBox(
                         width: 230,
                         child: RaisedButton(onPressed: (){},
                           color: Colors.green,
                           child: Text('Message'),
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                         ),
                       ),
                       SizedBox(width: 10,),
                       SizedBox(
                         width: 60,
                         child: RaisedButton(onPressed: (){},
                           color: Colors.grey,
                           child: Icon(Icons.menu),
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                         ),
                       )
                     ],),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text('User information',style:TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                   ),
                   ListTile(
                     leading: Icon(Icons.people),
                     title: Text('Name',style:TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                     subtitle: Text(u.fullname),
                   ),
                   ListTile(
                     leading: Icon(Icons.pregnant_woman),
                     title: Text('Sex',style:TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                     subtitle: Text(u.gender),
                   ),
                   ListTile(
                     leading: Icon(Icons.school),
                     title: Text('School',style:TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                     subtitle: Text(u.school),
                   ),
                   ListTile(
                     leading: Icon(Icons.science_outlined),
                     title: Text('department',style:TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                     subtitle: Text(u.department),
                   ),
                   Divider(thickness: 5,),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text('Skill',style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                   ),


                   ListTile(
                     leading: Icon(Icons.work_outline_sharp),
                     title: Text('Skill'),
                     subtitle: Text(u.skills),
                   ),
                   Divider(thickness: 5,),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text('Contact information',style:TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                   ),
                   ListTile(
                     leading: Icon(Icons.phone),
                     title: Text('Phone number',style:TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                     subtitle: Text(u.number.toString()),
                   ),
                   ListTile(
                     leading: Icon(Icons.email),
                     title: Text('email',style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                     subtitle: Text(u.email),
                   ),
                   ListTile(
                     leading: Icon(Icons.home_work_outlined),
                     title: Text('address',style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                     subtitle: Text(u.address),
                   ),
                   ListTile(
                     leading: Icon(Icons.location_city),
                     title: Text('city',style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                     subtitle: Text(u.city),
                   ),

                 ],
               ),
             );

           }

             return CircularProgressIndicator();

         }

        ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getid();
  }

  void getid() {
    FirebaseAuth.instance.onAuthStateChanged.listen((event) {
      setState(() {
        uid = event.uid;
      });
    });
  }
}
