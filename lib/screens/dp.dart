import 'package:flutter/material.dart';

class Dp extends StatelessWidget {
  String dp;
  String username;


  Dp(this.dp, this.username);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(username),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          height: 300,
          child:Hero(
            tag: 'ok',
            child:  Image.network(dp,fit: BoxFit.cover,),
          )
        ),
      ),
    );
  }
}
