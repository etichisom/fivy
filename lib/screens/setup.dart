import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fivywork3/screens/loging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Asetup extends StatefulWidget {
  @override
  _AsetupState createState() => _AsetupState();
}

class _AsetupState extends State<Asetup> {
  int _currentstep = 0;
  String name;
  String address;
  String city;
  String school;
  String department;
  String matnum;
  String phone;
  String gmail;
  String password;
  String password2;
  File image;
  String skill;
  String token;
  String cartegory;
  String slevel;
  int jobdone = 0;
  int balance = 0;
  int activejob = 0;
  String photourl;
  TextEditingController cname = TextEditingController();
  TextEditingController caddress = TextEditingController();
  TextEditingController ccity = TextEditingController();
  TextEditingController cschool = TextEditingController();
  TextEditingController cdepartment = TextEditingController();
  TextEditingController cmat = TextEditingController();
  TextEditingController cphone = TextEditingController();
  TextEditingController cskill = TextEditingController();
  TextEditingController cgmail = TextEditingController();
  TextEditingController cpass = TextEditingController();
  TextEditingController cpass2 = TextEditingController();

 ProgressDialog p;


  List<String> item=[
    '100','200','300','400','500'
  ];
  List<String> skill_level =[
    'Beginner','Intermediate','Expert'
  ];
  List<String> skillitem =[
    'Assignment','Repairs',"Design",'foods','sell'
  ];
  List<String> gitem =[
    'male','female',
  ];
  String gender = 'male';
  String level = '100';
  String error = 'erroo';

  @override
  Widget build(BuildContext context) {
    p = ProgressDialog(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('CREATE ACCOUNT',style: TextStyle(),),
        centerTitle: true,
      ),
      body: Stepper(steps: steps(context),
      type: StepperType.vertical,
        currentStep: _currentstep,
      onStepTapped: (step){
        setState(() {
          _currentstep = step;
        });
      },
        onStepCancel: (){
          cancel();

        },
        onStepContinue: (){
         contine(context);
        },
      ),
    );
  }

   cancel() {
    if(_currentstep != 0){
      setState(() {
        _currentstep = _currentstep - 1;
      });
    }
   }
   contine(BuildContext context){
    if(_currentstep != steps(context).length-1 ){
      setState(() {
        _currentstep = _currentstep +1;
      });
    }else{

     uploaddoc(context);
      
    }

   }
   List<Step> steps(BuildContext context){
     List<Step> steps = [
       Step(title: Text('login info'),
         isActive: _currentstep==0?true:false,
         content: step4(context),
       ),
      Step(title: Text('Basic info'),
          isActive: _currentstep==1?true:false,
          content: step1(context),
      ),
       Step(title: Text('Education info'),
           isActive: _currentstep==2?true:false,
           content: step2(context)
       ),
       Step(title: Text('Skill'),
           isActive: _currentstep==3?true:false,
           content: step3(context),


       )
     ];

     return steps;
   }
   Widget step1(BuildContext context){
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: image!=null?FileImage(image):null,
          backgroundColor: Colors.lightBlue,
        ),
       FlatButton(onPressed: (){
         chooseimag(context);
        },
           child:Text('choose a Photo')
       ),
       TextFormField(
         controller: cname,
         onChanged: (vall){
           setState(() {
             name = vall;
           });
         },
         decoration: InputDecoration(
           labelText: 'Full name',
         ),
       ),
        Row(
          children: [
            Text('Gender',style:TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
            SizedBox(width: 39,),
            DropdownButton<String>(
              items: gitem.map<DropdownMenuItem<String>>((e) {
                return DropdownMenuItem(child: Text(e),
                  value:e ,);
              }).toList(),
              value: gender,
              onChanged: (e){
                setState(() {
                  gender = e;
                });
              },),],),
        TextFormField(
          controller: caddress,
          onChanged: (vall){
            setState(() {
              address= vall;
            });
          },
          decoration: InputDecoration(
            labelText: 'Address',
          ),
        ),
        TextFormField(
          controller: ccity,
          onChanged: (vall){
            setState(() {
              city = vall;
            });
          },
          decoration: InputDecoration(
            labelText: 'city',
          ),
        ),
        TextFormField(
          controller: cphone,
          keyboardType: TextInputType.number,
          onChanged: (vall){
            setState(() {
              phone = vall;
            });
          },
          decoration: InputDecoration(
            labelText: 'Phone No.',
          ),
        )
      ],
    );
   }
  Widget step4(BuildContext context){
    return Column(
      children: [
        TextFormField(
          controller: cgmail,
          onChanged: (vall){
            setState(() {
              gmail = vall;
            });
          },
          decoration: InputDecoration(
            labelText: 'gmail',
          ),
        ),
        TextFormField(
          obscureText: true,
          controller: cpass,
          onChanged: (vall){
            setState(() {
              password= vall;
            });
          },
          decoration: InputDecoration(

            labelText: 'password',
          ),
        ),
        TextFormField(
          controller: cpass2,
          onChanged: (vall){
            setState(() {
              password2 = vall;
            });
          },
          decoration: InputDecoration(
            labelText: 'enter password again',
          ),
        ),

      ],
    );
  }
  Widget step2(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: cschool,
          onChanged: (vall){
            setState(() {
              school = vall;
            });
          },
          decoration: InputDecoration(
            labelText: 'School',
          ),
        ),
        TextFormField(
          controller: cdepartment,
          onChanged: (vall){
            setState(() {
              department= vall;
            });
          },
          decoration: InputDecoration(
            labelText: 'Department',
          ),
        ),
        Row(
          children: [
            Text('Skill',style:TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
            SizedBox(width: 39,),
            DropdownButton<String>(
              items: item.map<DropdownMenuItem<String>>((e) {
                return DropdownMenuItem(child: Text(e + 'Level'),
                  value:e ,);
              }).toList(),
              value: level,
              onChanged: (e){
                setState(() {
                  level = e;
                });
              },),],),
        TextFormField(
          controller: cmat,
          keyboardType: TextInputType.numberWithOptions(),
          onChanged: (vall){
            setState(() {
              matnum= vall;
            });
          },
          decoration: InputDecoration(
            labelText: 'Matriculation Number',
          ),
        ),


      ],
    );
  }
  Widget step3(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: cskill,
          onChanged: (vall){
            setState(() {
              skill = vall;
            });
          },
          decoration: InputDecoration(
            labelText: 'skill',
          ),
        ),

        Row(
          children: [
            Text('Category',style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            SizedBox(width: 39,),
            DropdownButton<String>(
              items: skillitem.map<DropdownMenuItem<String>>((e) {
                return DropdownMenuItem(child: Text(e),
                  value:e ,);
              }).toList(),
              value: 'Repairs',
              onChanged: (e){
                setState(() {
                  cartegory = e;
                });
              },),],),
        Row(
          children: [
            Text('Skill Level',style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            SizedBox(width: 39,),
            DropdownButton<String>(
              items: skill_level.map<DropdownMenuItem<String>>((e) {
                return DropdownMenuItem(child: Text(e),
                  value:e ,);
              }).toList(),
              value: 'Beginner',
              onChanged: (e){
                setState(() {
                  slevel = e;
                });
              },),],),
        Text(error)


      ],
    );
  }

   chooseimag(BuildContext text) {
    return showDialog(
      context: text,
      builder: (context){
        return SimpleDialog(
          title: Text('select image local storage'),
          children: [
           SimpleDialogOption(
             onPressed: (){
              local(context);
             },
             child: Text('Select from local storage'),
           ),
            SimpleDialogOption(
              onPressed: (){
                camera(context);
              },
              child: Text('Select from camera'),
            ),
            SimpleDialogOption(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('cancel'),
            )
          ],
        );
      }
    );
  }

   local(BuildContext context) async{
   File file = await ImagePicker.pickImage(source: ImageSource.gallery);
   setState(() {
     image = file;
   });
   Navigator.pop(context);

   }

   camera(BuildContext context)async {
     File file = await ImagePicker.pickImage(source: ImageSource.camera);
     setState(() {
       image = file;
     });
     Navigator.pop(context);
   }

   uploaddoc(BuildContext context) {
    if(name==null){
      dialog('input not filled', "name field is empty", context);

    }else if(address == null){
      dialog('input not filled', "address field is empty", context);
    }else if(city== null){
      dialog('input not filled', "city field is empty", context);
    }else if(phone == null){
      dialog('input not filled', "phone number field is empty", context);
    }else if(school == null){
      dialog('input not filled', "name field is empty", context);

    }else if(department == null){
      dialog('input not filled', "department field is empty", context);
    }else if(matnum == null){
      dialog('input not filled', "matnum field is empty", context);
    }else if(skill==null){
      dialog('input not filled', "skill field is empty", context);
    }else if(gmail==null){
      dialog('input not filled', "email field is empty", context);
    }else if(password==null){
      dialog('input not filled', "password field is empty", context);
    }
    else if(password2==null){
      dialog('input not filled', "password2 field is empty", context);
    }
    else{
      print('filled');
      if(password2 == password){
        p.show();
        FirebaseAuth.instance.createUserWithEmailAndPassword(email: gmail, password: password)
            .then((value) {
              print('success');

          createuser(context,value.user);
        }).catchError((e){
          p.hide();
          setState(() {
            error = e.toString();
          });
          dialog("Error creating account", error, context);

        });
      }else{
        dialog('input not filled', "the two password does not match", context);
      }

    }



  }
  dialog(String title,String text,BuildContext context){
    return showDialog(context: context
        ,builder: (context){
          return CupertinoAlertDialog(
            title: Text(title),
            content:Text(text) ,
            actions: [
              CupertinoDialogAction(onPressed: (){
                Navigator.pop(context);
              }
                ,child: Text('cancel'),)

            ],
          );
        });
  }

   createuser(BuildContext context, FirebaseUser user) async{
    String nid = DateTime.now().microsecondsSinceEpoch.toString();
     await  FirebaseStorage.instance.ref().child(user.uid).putFile(image).onComplete
         .then((value) async {
       String link = await value.ref.getDownloadURL();
       setState(() {
         photourl = link;
       });
     })
         .catchError((e){print(e);});
    await Firestore.instance.collection('users').document(user.uid).setData({
      "name":name,
      "city":city,
      "phone":phone,
      "school":school,
      "address":address,
      "department":department,
      "skill":skill,
      "uid":user.uid,
      "dp":photourl,
      "matnum":matnum,
      'token':token,
      'job':jobdone,
      'email':user.email,
      'balance':balance,
      'activejob':activejob,
      'gender':gender,
      'status':'offline',
      'slevel':slevel


    }).catchError((e){
      p.hide();
      setState(() {
        error=e.toString();
      });
      dialog('something went wrone',error, context);
    });
     await Firestore.instance.collection("user").document('notification').collection(user.uid).document(nid)
       .setData(
         {
           "body":'Your account has been created please make sure you verify your email',
           "type":'1',
           'uid':user.uid,
           'dp':photourl,
           'token':token,
           'isread':false,
           'nid':nid

         }

     ).then((value){
       p.hide();
       Navigator.push(context, CupertinoPageRoute(builder: (context)=>Login()));
     }).catchError((e){
       setState(() {
         error=e.toString();
       });
       dialog('something went wrone',error, context);
     });
   }
   @override
  void initState() {
    // TODO: implement initState
    super.initState();

     gettoken();


  }

   gettoken()async {
     await FirebaseMessaging().getToken().then((value) {
       setState(() {
         token=value;
       });
     });
     print(token);
   }




   }


