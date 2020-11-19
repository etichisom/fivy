
import 'package:fivywork3/screens/rave.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:credit_card/credit_card_form.dart';
import 'package:credit_card/credit_card_model.dart';
import 'package:credit_card/flutter_credit_card.dart';

void main() => runApp(MySample());

class MySample extends StatefulWidget {
  String amount;
  String jobuid;
  String uid;
  String wuid;
  String duration;

  MySample({this.amount, this.jobuid, this.uid, this.wuid, this.duration});

  @override
  State<StatefulWidget> createState() {
    return MySampleState(amount: amount,jobuid: jobuid,uid: uid,wuid: wuid,duration: duration);
  }
}

class MySampleState extends State<MySample> {
  String amount;
  String jobuid;
  String uid;
  String wuid;
  String duration;


  MySampleState({this.amount, this.jobuid, this.uid, this.wuid, this.duration});
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
              ),
              Container(
                child: SingleChildScrollView(
                  child: CreditCardForm(
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                ),
              ),
              RaisedButton(onPressed: (){
                Navigator.push(context, CupertinoPageRoute(builder: (context)=>MyApp(cardno: cardNumber.trim(),
                cvv: cvvCode,expdate: expiryDate,uid: uid,wuid: wuid,jobuid: jobuid,duration: duration,amount: amount,)));
               },
                child: Text('NEXT'),
                color: Colors.blue[800],
              )
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}

