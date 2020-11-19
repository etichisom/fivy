


import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fivywork3/modalclass/user.dart';
import 'package:fivywork3/screens/dp.dart';
import 'package:fivywork3/screens/video.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



import 'package:image_picker/image_picker.dart';

class Chat extends StatelessWidget {
  String uid;
  String ruid;
  String rname;
  String rdp;
  String token;
  String mytoken;
  User use;

  Chat({Key key,this.uid, this.ruid, this.rname, this.rdp,this.token,this.mytoken,this.use});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title:ListTile(
          title: Text(rname,style: TextStyle(),),
          leading: CircleAvatar(backgroundImage: NetworkImage(rdp),),
        ),

      ),
      body: chatscreen(uid: uid,ruid: ruid,
          rname: rname,rdp: rdp,token: token,mytoken: mytoken,use: use,),
    );
  }
}
class chatscreen extends StatefulWidget {
  String uid;
  String ruid;
  String rname;
  String rdp;
  String token;
  String mytoken;
  User use;





  chatscreen({this.uid, this.ruid, this.rname, this.rdp,this.token,this.mytoken,this.use});

  @override
  chatscreenState createState() => chatscreenState(uid: uid,ruid: ruid,
      rname: rname,rdp: rdp,token: token,mytoken: mytoken);
}

class chatscreenState extends State<chatscreen> {
  String uid;
  String ruid;
  String rname;
  String rdp;
  String sname;
  String sdp;
  String token;
  String mytoken;
  int type;
  File image;
  String imageurl;

  chatscreenState(
      {this.uid, this.ruid, this.rname, this.rdp, this.token, this.mytoken});

  TextEditingController controller = TextEditingController();
  String mess;
  bool iswritting = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      body: Column(
        children: [
          Flexible(child: Container(
            width: 350,
            child: StreamBuilder(
              stream: Firestore.instance.collection("message").document(uid)
                  .collection(ruid)
                  .orderBy('mid', descending: false)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot>snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                return ListView(

                  children: snapshot.data.documents.map((e) {
                    isread(e);
                    if(e['type']==1){
                      return makelist2(e);
                    }else if(e['type']==2){
                      return imageview(e,context);
                    }else{
                      return videoplay(e,context);
                    }
                  }).toList(),
                );
              },
            ),
          )),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextField(
                    controller: controller,
                    onChanged: (vall) {
                      setState(() {
                        type = 1;
                        mess = vall;
                        if (mess.length > 0) {
                          iswritting = true;
                        } else {
                          iswritting = false;
                        }
                      });
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'enter message',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      prefixIcon: IconButton(
                          icon: Icon(Icons.camera_alt_outlined), onPressed: () {
                        dialog(context);
                      }),
                      suffixIcon:  IconButton(
                          icon: Icon(Icons.attach_file_sharp), onPressed: () {
                            video(context);
                          }),
                      fillColor: Colors.white70,
                      contentPadding: EdgeInsets.all(8),
                      filled: true,

                    ),

                  ),
                ),

              ),

              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Container(

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iswritting ? Colors.green : Colors.green,
                  ),
                  child: iswritting ? abutton() : dbutton(),
                ),
              ),


            ],
          )


        ],

      ),
    );
  }

  dialog(BuildContext cont) {
    return showDialog(context: cont,
        builder: (context) {
          return SimpleDialog(
            title: Text('choose'),
            children: [
              SimpleDialogOption(onPressed: () {
                local(cont);
              },
                child: Text('Local storage'),),
              SimpleDialogOption(onPressed: () {
                camera(cont);
              },
                child: Text('camera'),),
              SimpleDialogOption(onPressed: () {
                Navigator.pop(context);
              },
                child: Text('cancel'),)
            ],
          );
        });
  }

  local(BuildContext context) async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    Navigator.pop(context);
    setState(() {
      type = 2;
      image = file;
    });
    print(file);
    print(type);
    upload(file, context);
  }

  upload(File file, BuildContext context) async {

    await FirebaseStorage.instance
        .ref()
        .child(DateTime.now().microsecondsSinceEpoch.toString())
        .putFile(file)
        .onComplete
        .then((value) async {
      String link = await value.ref.getDownloadURL();
      await setState(() {
        imageurl = link;
      });
      send(context);
    });
  }

  camera(BuildContext context) async {
    File file = await ImagePicker.pickImage(source: ImageSource.camera);
    Navigator.pop(context);
    setState(() {
      type = 2;
      image = file;
    });
    print(file);
    print(type);
    upload(file, context);
  }

  sendmessege() async {
    String mid = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    controller.clear();
    await Firestore.instance.collection('message').document(uid)
        .collection(ruid).document(mid).setData({
      "message": mess,
      'timestamp': DateTime
          .now()
          .hour,
      'name': sname,
      "dp": sdp,
      "id": uid,
      'mid': mid,
      'token': null,
      'isread': false,
      'type': type
    });
    await Firestore.instance.collection('message').document(ruid)
        .collection(uid).document(mid).setData({
      "message": mess,
      'timestamp': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      'dp': sdp,
      'name': sname,
      "id": uid,
      'mid': mid,
      'isread': false,
      'token': token,
      'type': type
    });
    await Firestore.instance.collection('contact').document(uid)
        .collection(uid).document(ruid).setData({
      'message': mess,
      'ruid': ruid,
      'dp': rdp,
      "name": rname,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'token': token,
      'isread': false,
      'type': type,
      'id':uid,
      'read':true

    });
    await Firestore.instance.collection('contact').document(ruid)
        .collection(ruid).document(uid).setData({
      'message': mess,
      'ruid': uid,
      'dp': sdp,
      'id':uid,
      "name": sname,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'token': mytoken,
      'isread': false,
      'type': type,
      'read':false

    });
    print('done');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getinfo();
  }

  getinfo() async {
    await Firestore.instance.collection('users').document(uid).get()
        .then((value) {
      setState(() {
        sname = value.data['name'];
        sdp = value.data['dp'];
      });
      print(sname);
      print(sdp);
    });
  }

  Widget makelist2(DocumentSnapshot doc) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 10,),
        Container(
          width: 50,

          alignment: doc['id'] == uid ? Alignment.bottomRight : Alignment
              .centerLeft,

          child: Padding(

            padding: const EdgeInsets.all(0.0),
            child: Container(
                decoration: BoxDecoration(
                  color: doc['id'] == uid ? Colors.green : Colors
                      .white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)
                    ,
                    bottomLeft: uid == doc['id'] ? Radius.circular(10) : Radius
                        .circular(0),
                    bottomRight: uid == doc['id'] ? Radius.circular(0) : Radius
                        .circular(10),
                  ),


                ),

                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(doc['message'],
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                )),
          ),
        ),
        Container(child: doc['id'] == uid ? seen(doc) : Container()
            ,
            alignment: doc['id'] == uid ? Alignment.bottomRight : Alignment
                .centerLeft),

      ],
    );
  }

  Widget makelist(DocumentSnapshot doc) {
    return Container(
      height: 30,
      width: 30,
      color: Colors.deepPurpleAccent,
      child: Text(doc['message']),
    );
  }

  Widget abutton() {
    return Center(
        child: IconButton(icon: Icon(Icons.send,color: Colors.white, size: 24,),
            onPressed: () {
              sendmessege();
            }
        ));
  }

  Widget dbutton() {
    return Center(
      child: IconButton(icon: Icon(Icons.record_voice_over,color: Colors.white,), onPressed: () {
        print(type);
      }),);
  }

  isread(DocumentSnapshot doc) async {
    if (uid != doc['id']) {
      await Firestore.instance.collection('message').document(ruid)
          .collection(uid).document(doc['mid']).updateData({'isread': true})
          .then((value) async {
        Firestore.instance.collection('contact').document(ruid)
            .collection(ruid).document(uid)
            .updateData({'isread': true}).then((value) => {
        Firestore.instance.collection('contact').document(uid)
            .collection(uid).document(ruid)
            .updateData({'read': true})
            .catchError((e) => print(e))
        })
            .catchError((e) => print(e));
      })
          .catchError((e) => print(e));



    }
  }

  Widget seen(DocumentSnapshot doc) {
    if (doc['isread'] == true) {
      return Text('seen');
    } else {
      return Text('not seen');
    }
  }

  send(BuildContext context) async {
    String mid = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    controller.clear();
    await Firestore.instance.collection('message').document(uid)
        .collection(ruid).document(mid).setData({
      "message": imageurl,
      'timestamp': DateTime
          .now()
          .hour,
      'name': sname,
      "dp": sdp,
      "id": uid,
      'mid': mid,
      'token': null,
      'isread': false,
      'type': type
    });
    await Firestore.instance.collection('message').document(ruid)
        .collection(uid).document(mid).setData({
      "message": imageurl,
      'timestamp': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      'dp': sdp,
      'name': sname,
      "id": uid,
      'mid': mid,
      'isread': false,
      'token': token,
      'type': type
    });
    await Firestore.instance.collection('contact').document(uid)
        .collection(uid).document(ruid).setData({
      'message': imageurl,
      'ruid': ruid,
      'dp': rdp,
      "name": rname,
      'timestamp': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      'token': token,
      'isread': false,
      'type': type,
      'id':uid,
      'read':true
    });
    await Firestore.instance.collection('contact').document(ruid)
        .collection(ruid).document(uid).setData({
      'message': imageurl,
      'ruid': uid,
      'dp': sdp,
      "name": sname,
      'timestamp': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      'token': mytoken,
      'isread': false,
      'type': type,
      'id':uid,
      'read':false
    });
    print('done');
  }

  Widget imageview(DocumentSnapshot e, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Dp(e['message'], e['name'])));
        },
        child: Container(
          alignment: e['id'] == uid ? Alignment.bottomRight : Alignment
              .centerLeft,
          child: Container(
            height: 200,
            width: 200,

            decoration: BoxDecoration(
                color: Colors.black,
              image: DecorationImage(
                image: NetworkImage(e['message']),
                fit: BoxFit.contain,

              )
            ),
          ),
        ),
      ),
    );
  }

   video(BuildContext context)async {
    File file = await ImagePicker.pickVideo(source: ImageSource.gallery);
    setState(() {
      type = 3;
    });
    print(file);
    print(type);
    upload(file, context);

   }

  Widget videoplay(DocumentSnapshot e, BuildContext context) {

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoApp(e['message'])));
      },
      child: Container(
        alignment: e['id'] == uid ? Alignment.bottomRight : Alignment
            .centerLeft,
        child: Container(
          height: 150,
          width: 200,

          color: Colors.black,

          child:  Center(child: Icon(Icons.play_circle_outline_sharp,size:60,color: Colors.white,)),
        ),
      ),
    );


  }
}


