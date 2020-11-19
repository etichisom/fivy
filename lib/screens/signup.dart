import 'package:firebase_auth/firebase_auth.dart';
import 'package:fivywork3/modalclass/route.dart';
import 'package:fivywork3/screens/setup.dart';


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';




import 'pay.dart';
import 'loging.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email,password;
  final formkey =  GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[300],
      body: Padding(

        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Container(

          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0,0),
            child: SingleChildScrollView(
              child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/mult.png',scale: 2,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 70),
                    child: Container(
                      child: Form(
                        key: formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,

                          children: [
                            Center(child: Text("CREATE ACCOUNT",style: TextStyle(fontSize: 20,color: Colors.black,fontStyle: FontStyle.italic),)),
                            SizedBox(height: 20,),
                            TextFormField( validator: (pass){
                              if(pass.isEmpty){
                                return "email cant be empty";

                              } else{
                                return null;
                              }
                            },
                              onChanged: (va){
                              setState(() {
                                email =va;
                              });
                            },
                              decoration: InputDecoration(border: OutlineInputBorder(),
                            labelText: "email",
                            ),),
                            SizedBox(height: 30,),
                            TextFormField(onChanged: (va){
                            setState(() {
                              password =va;
                            });
                            },obscureText: true,
                              validator: (pass){
                                if(pass.isEmpty){
                                  return "password cant be empty";

                                } else{
                                  return null;
                                }
                              },
                              decoration: InputDecoration(border: OutlineInputBorder(),
                              labelText: "password",
                            ),),
                            SizedBox(height: 30,),
                            RaisedButton(onPressed: (){
                              if(formkey.currentState.validate()){
                                print(email);
                                print(password);
                                FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).
                                then((value) {
                                  if(value != null){
                                    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>Asetup()));

                                  }
                                }).catchError((err){
                                  print(err);
                                });
                              }
                             },
                              child: Text("Sign up into fivywork",style: TextStyle(color: Colors.white,),),
                              color:Colors.green[500] ,),
                            FlatButton(onPressed: (){
                              Navigator.push(context,SlideRightRoute(page: Login()));
                              }, child:Text("already have an account?"))

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
