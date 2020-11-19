import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Jobbid extends StatefulWidget {
  final String receiverid;
  final String postid;
  final String duration;
  final String jobdec;

  const Jobbid({Key key, this.receiverid, this.postid, this.duration, this.jobdec}) : super(key: key);

  @override
  _JobbidState createState() => _JobbidState();
}

class _JobbidState extends State<Jobbid> {
  @override
  Widget build(BuildContext context) {
    List<String>dtime=[
      "1 day",'2 days','3 days','4 days','5 days','6 days','1 week'
    ];
    String date = 'days';
    return Scaffold(
      appBar: AppBar(),
      body:Container(
        child: Column(
          children: [
            SizedBox(height: 5,),
            Text('Choose catergory'),
            Divider(color: Colors.black54,),
            Row(children: [
              Icon(Icons.insert_drive_file),
              SizedBox(width: 5,),
              Text("Category"),
              SizedBox(width: 5,),
              Text(date.toString(),style: TextStyle(color: Colors.blue,fontSize: 15),),
              SizedBox(width: 15,),

              SizedBox(width: 50,),

              DropdownButton<String>(
                  items:dtime.map<DropdownMenuItem<String>>((item){
                    return DropdownMenuItem(child:Text(item),value: item,);
                  }).toList() ,


                  onChanged: (vall){setState(() {
                    date=vall;
                  });}),
            ],),
          ],
        ),
      ) ,
    );
  }
}
