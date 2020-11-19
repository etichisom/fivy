import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fivywork3/modalclass/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Postjob extends StatefulWidget {
  User user;

  Postjob({this.user});

  @override
  _PostjobState createState() => _PostjobState();
}

class _PostjobState extends State<Postjob> {
  String desc,budget,uid,postid;
  String devday = "1 day";
  String subcategory='node.js';
  String cartigory ="web dev";
  int charcount = 0;
  List<String> cart =[
    'computer','logo design',
  ];
  List<String>subcart=[
    "flutter dev",'3d animation','motion graphics'
  ];
  List<String>dtime=[
    "1 day",'2 days','3 days','4 days','5 days','6 days','1 week'
  ];
    final formkey = GlobalKey<FormState>();
  ProgressDialog pr;


  @override
  Widget build(BuildContext context) {
     pr = ProgressDialog(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.clear,color: Colors.black,), onPressed: (){
          Navigator.pop(context);
        }),
        title: Text("post a request",style: TextStyle(color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(

          child: ListView(
            children: [
              Form(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Text('Add a description'),
                  SizedBox(height: 5,),
                  Divider(color: Colors.black54,),
                  Text("minimum of 200 words",style: TextStyle(color: Colors.black54),),

                  Container(
                    height: 150,

                    child: TextFormField(
                      validator: (vall){
                        if(vall.length < 200){
                          return"minimum word is 200";
                        }else{
                          return null;
                        }
                      },

                      onChanged: (des){
                        setState(() {
                          desc = des;
                          charcount = des.length;
                        });

                      },
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,

                      expands: true,
                      minLines: null,
                      maxLines: null,
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end,children: [Text("$charcount/200")],),
                  SizedBox(height: 5,),
                  Text('Choose catergory'),
                  Divider(color: Colors.black54,),
                  Row(children: [
                    Icon(Icons.insert_drive_file),
                    SizedBox(width: 5,),
                    Text("Category"),
                    SizedBox(width: 5,),
                    Text(cartigory.toString(),style: TextStyle(color: Colors.blue,fontSize: 15),),
                    SizedBox(width: 15,),

                    SizedBox(width: 50,),

                    DropdownButton<String>(
                        items:cart.map<DropdownMenuItem<String>>((item){
                          return DropdownMenuItem(child:Text(item),value: item,);
                        }).toList() ,


                        onChanged: (vall){setState(() {
                          cartigory=vall;
                        });}),
                  ],),
                  Divider(color: Colors.black54,),
                  Text('Carteria'),
                  Divider(color: Colors.black54,),
                  Row(
                    children: [
                      Icon(Icons.attach_file),
                      SizedBox(width: 5,),
                      Text("Subcategory"),
                      SizedBox(width: 15,),
                      Text(subcategory.toString(),style: TextStyle(color: Colors.blue,fontSize: 15),),
                      SizedBox(width: 5,),
                      DropdownButton<String>(items:subcart.map<DropdownMenuItem<String>>((item){
                        return DropdownMenuItem(child: Text(item),value: item,);
                      }).toList() ,
                        onChanged: (item){
                          setState(() {
                            subcategory = item;
                          });
                        },
                      )

                    ],
                  ),
                  Divider(color: Colors.black54,),
                  Text('Day to be Delivered'),
                  Divider(color: Colors.black54,),
                  Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 5,),
                      Text("Delivery Time"),
                      SizedBox(width: 50,),
                      Text(devday,style: TextStyle(color: Colors.blue,fontSize: 15),),
                      SizedBox(width: 5,),
                      DropdownButton<String>(items:dtime.map<DropdownMenuItem<String>>((item){
                        return DropdownMenuItem(child: Text(item),value: item,);
                      }).toList() ,
                        onChanged: (item){
                          setState(() {
                            devday = item;
                          });
                        },
                      )

                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.attach_money),
                      SizedBox(width: 5,),
                      Text("Budget"),
                      SizedBox(width: 50,),
                      Container(
                        width: 200,
                        child: TextFormField(
                          validator: (vall){
                            if(vall.isEmpty){
                              return"input a price";
                            }else{
                              return null;
                            }
                          },
                          onChanged: (bb){
                            setState(() {
                              budget = bb;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: 'Enter amount'),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Center(child: SizedBox(child: RaisedButton(onPressed: (){
                    if(formkey.currentState.validate()){
                      pr.show();
                      postjob(context);
                    }
                   },color: Colors.blue,
                    child: Text("Submit request",style: TextStyle(color: Colors.white,fontSize: 17),),

                  ),width: 350,height: 45,))



                ],

              ),key: formkey,)
            ],
          ),
        ),
      ),
          
    );

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


      setState(() {
        postid = DateTime.now().millisecondsSinceEpoch.toString()+widget.user.uid;
      });

      print(postid);
      print(uid);


  }

  postjob(BuildContext context) {
    Firestore.instance.collection("jobs").document(postid)
        .setData({
      "postid":postid,
      "uid":widget.user.uid,
      "time":DateTime.now().millisecondsSinceEpoch,
      "offers":"0",
      "category":cartigory,
      "desc":desc,
      "dtime":devday,
      "timestamp":DateTime.now().toString(),
      "subcategory":subcategory,
      "budget":budget,
    }).then((value) => Navigator.pop(context))
        .catchError((er){
          pr.hide();
          print(er);
    });

  }
}
