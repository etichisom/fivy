
import 'package:fivywork3/screens/loging.dart';
import 'package:fivywork3/screens/signup.dart';
import 'package:flutter/material.dart';


import 'package:introduction_screen/introduction_screen.dart';



class Intro extends StatelessWidget {
  List<PageViewModel> getpages(){
    return[
      PageViewModel(
          title: "Never miss an opportunity",
          body: "Easily find work, chat and collaborate on the go",
          image:Image.asset('images/work.png'),
          decoration: PageDecoration(titleTextStyle: TextStyle(color: Colors.white,fontSize: 30),bodyTextStyle: TextStyle(color: Colors.white))
      ),
      PageViewModel(
          title: "Find project and submit proposals",
          body: "stand out by replying to a client quickly and getting works",
          image: Image.asset('images/connect.png'),
         decoration: PageDecoration(titleTextStyle: TextStyle(color: Colors.white,fontSize: 30),bodyTextStyle: TextStyle(color: Colors.white))
      ),
      PageViewModel(
        title: "collborate on the go",
        decoration: PageDecoration(titleTextStyle: TextStyle(color: Colors.white,fontSize: 30),bodyTextStyle: TextStyle(color: Colors.white)),
        body: "Chat,share files and complete project",
        image: Image.asset('images/secure.png')
      )
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: IntroductionScreen(
        globalBackgroundColor: Colors.blue[900],
        done: Text("Next >",style: TextStyle(color: Colors.white),),

        onDone: (){
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> Login() ));

        },
        pages: getpages(),
      ),
    );
  }
}





