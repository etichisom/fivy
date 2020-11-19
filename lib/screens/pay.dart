import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fivywork3/modalclass/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rave_flutter/rave_flutter.dart';

class pay extends StatefulWidget {
  DocumentSnapshot doc;
  User u;
  User myu;
  pay({this.doc, this.u,this.myu});

  @override
  _payState createState() => _payState();
}

class _payState extends State<pay> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var autoValidate = true;
  bool acceptCardPayment = true;
  bool acceptAccountPayment = true;
  bool acceptMpesaPayment = false;
  bool shouldDisplayFee = true;
  bool acceptAchPayments = false;
  bool acceptGhMMPayments = false;
  bool acceptUgMMPayments = false;
  bool acceptMMFrancophonePayments = false;
  bool live = false;
  bool preAuthCharge = false;
  bool addSubAccounts = false;
  List<SubAccount> subAccounts = [];
  String email = 'chisometi@gmail.com';
  double amount = 2;
  String publicKey = "FLWPUBK_TEST-6107051db42149cfdb7e6a73e1c656f0-X ";
  String encryptionKey = "FLWSECK_TEST1d15f3c921cc";
  String txRef = DateTime.now().toString();
  String orderRef = DateTime.now().toString();
  String narration = 'payment';
  String currency = 'NGN';
  String country = 'NG';
  String firstName = 'chisom';
  String lastName = 'chisom';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Review',style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Order Details",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Description",style: TextStyle(color: Colors.black,fontSize: 15,),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.doc['description']),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duration'),
                Text(widget.doc['duration'])
              ],
            ),

          ),
          Divider(thickness: 2,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Order Summary",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Job fee'),
                Text('N'+widget.doc['amount'].toString())
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Service'),
                Text('N100')
              ],
            ),
          ),
          Divider(thickness: 2,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total'),
                Text('N'+ (widget.doc['amount']+100).toString())
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 45,
              child: RaisedButton(
                child:Text('PAY',style: TextStyle(color: Colors.white),),
                onPressed: startPayment,
                color: Colors.green,
              ),
            ),
          )
        ],
      )
    );
  }

  void startPayment() async {
    var initializer = RavePayInitializer(
        amount: amount,
        publicKey: publicKey,
        encryptionKey: encryptionKey,
        subAccounts: subAccounts.isEmpty ? null : null)
      ..country =
      country = country != null && country.isNotEmpty ? country : "NG"
      ..currency = currency != null && currency.isNotEmpty ? currency : "NGN"
      ..email = email
      ..fName = firstName
      ..lName = lastName
      ..narration = narration ?? ''
      ..txRef = txRef
      ..orderRef = orderRef
      ..acceptMpesaPayments = acceptMpesaPayment
      ..acceptAccountPayments = acceptAccountPayment
      ..acceptCardPayments = acceptCardPayment
      ..acceptAchPayments = acceptAchPayments
      ..acceptGHMobileMoneyPayments = acceptGhMMPayments
      ..acceptUgMobileMoneyPayments = acceptUgMMPayments
      ..acceptMobileMoneyFrancophoneAfricaPayments = acceptMMFrancophonePayments
      ..displayEmail = false
      ..displayAmount = false
      ..staging = !live
      ..isPreAuth = preAuthCharge
      ..displayFee = shouldDisplayFee;

    var response = await RavePayManager()
        .prompt(context: context, initializer: initializer);
    print(response);
    print(response.message);
    print(response.status);
    if(response.status ==  RaveStatus.success){
      print('nice job');
    }else{
      print('not good');
    }



  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.myu.fullname);
    print(widget.doc['amount']);
    print(widget.u.fullname);
  }
}

