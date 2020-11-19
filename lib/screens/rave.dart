

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:bundle_rave_pay/bundle_rave_pay.dart';



class MyApp extends StatefulWidget {
  String cardno;
  String cvv;
  String expdate;
  String amount;
  String jobuid;
  String uid;
  String wuid;
  String duration;

  MyApp({this.cardno, this.cvv, this.expdate, this.amount, this.jobuid, this.uid,
      this.wuid, this.duration});


  @override
  _MyAppState createState() => _MyAppState(cardno: cardno,cvv: cvv,expdate: expdate,amount: amount,
  wuid: wuid,uid: uid,jobuid: jobuid,duration: duration);
}

class _MyAppState extends State<MyApp> {
  String cardno;
  String cvv;
  String expdate;
  String amount;
  String jobuid;
  String uid;
  String wuid;
  String duration;




  _MyAppState({this.cardno, this.cvv, this.expdate, this.amount, this.jobuid,
      this.uid, this.wuid, this.duration});

  var result;

  @override
  void initState() {
    super.initState();
    // initPlatformState();
  }

  String _randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(
        length,
            (index){
          return rand.nextInt(33)+89;
        }
    );

    return new String.fromCharCodes(codeUnits);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      var cardBody = {
        "amount": '100',
        "cvv": cvv,
        "cardExpiry": expdate,
        "cardNumber": cardno,
        "saveCard": "true",
        "country": "NG",
        "currencyCode": "NGN",
        "email": "hashilekky@gmail.com",
        "firstName": "Oluwaleke",
        "lastName": "Fakorede",
        "transactionReference":"FW --"+ DateTime.now().microsecondsSinceEpoch.toString(),
        "isLive": "true",
        // Update keys before running app
        "publicKey": "FLWPUBK-5d196bc07a2bf2fe657bf34ab3d6cf92-X",
        "encryptionKey": "78dc7962a62ce1f8a2544653",
        "narration": "Bundle Wallet Technology Ltd",
        "paymentMethod": "card",
      };
      result = await BundleRavePay.initializePayment(cardBody);
      if (result != null && result['status'] == 'success') {
        print("PAYMENT RESPONSE JSON IS SUCCESSFUL");
        print(result);
        pendingjob();

      } else {
        print("NOT JSON");
        print(result);
      }
    } on PlatformException {
      print('Failed to get platform version.');
    }

    if (!mounted) return;

    setState(() {
      // _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: FlatButton(
              child: Text('Running on:'),
              onPressed: () => initPlatformState(),
            )
        ),
      );
  }

   pendingjob()async {
   await Firestore.instance.collection("work").document(wuid)
        .setData({
      "jobid":jobuid,
      "uid":uid,
      "amount":amount,
      'status':"not completed"
    });
   await Firestore.instance.collection("order").document(uid)
       .setData({
     "jobid":jobuid,
     "uid":wuid,
     "amount":amount,
     'status':"not completed"
   });
   }
}