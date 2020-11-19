
import 'package:fivywork3/main.dart';
import 'package:fivywork3/screens/home.dart';
import 'package:fivywork3/screens/setup.dart';
import 'package:fivywork3/screens/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pay.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String email, password;
  ProgressDialog pr;


  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);

    ProgressDialog p = ProgressDialog(context);
    return Scaffold(
     backgroundColor: Colors.brown,

        body:Container(

          height: 713,
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/busy.png',),
                    fit: BoxFit.cover,
                  )
                ),
                height: 710,

                child: Stack(
                  overflow: Overflow.clip,
                  children: [

                    Positioned(
                      bottom: 200,
                      left: 45,
                      child: Container(child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5
                            )
                          ],

                        ),
                        height:300 ,
                        width: 270,
                        child: ListView(
                          children: [
                            SizedBox(height: 40,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(

                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(7,0,0,0),
                                  child: TextFormField(
                                    onChanged: (e){
                                      setState(() {
                                        email=e;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "enter your email",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(

                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(7,0,0,0),
                                  child: TextFormField(
                                    obscureText: true,
                                    onChanged: (e){
                                      setState(() {
                                        password=e;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "enter your password",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: RaisedButton(onPressed: (){
                                p.show();
                                sigin();
                               }
                              ,child: Text('SIGN IN'),color: Colors.green,
                              shape: RoundedRectangleBorder(borderRadius:
                              BorderRadius.all(Radius.circular(15))),),
                            ),
                            FlatButton(onPressed: (){
                              Navigator.push(context, CupertinoPageRoute(builder: (context)=>Asetup()));
                             },
                                child: Text('Dont have an account?Sign in')
                            )
                          ],
                        ),


                      )),
                    ),
                    Positioned(
                      left: 120,
                        top: 130,
                        child: CircleAvatar(
                      backgroundColor: Colors.black45,radius: 60,
                          child: Text('Fivy',style: GoogleFonts.aladin(fontSize: 24,color: Colors.white),),
                    )),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

   sigin() async{
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
        .then((value)async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if(!value.user.isEmailVerified){
            await prefs.setString('uid',value.user.uid );
            Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=>Splash(uid: value.user.uid,)));
          }else{
            pr.hide();
            value.user.sendEmailVerification();
            dialog('Error', 'Account is not yet verified ,check your mail and click on the link sent', context);
          }
    })
        .catchError((e){
          pr.hide();
          String error =e.toString();
          dialog('error', error, context);
    });
   }
  dialog(String title,String text,BuildContext context){
    return showDialog(context: context
        ,builder: (context){
          return CupertinoAlertDialog(
            title: Text(title),
            content:SelectableText(text) ,
            actions: [
              FlatButton(onPressed: (){
                Navigator.pop(context);
              }
                ,color: Colors.grey[300]
                ,child: Text('cancel'),)
            ],
          );
        });
  }


}
