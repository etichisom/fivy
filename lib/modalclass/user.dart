import 'package:cloud_firestore/cloud_firestore.dart';


class User{
  String occupation;
  String city;
  String school;
  String address;
  String gender;
  String fullname;
  String skills;
  String dp;
  String uid;
  String number;
  String token;
  String matnum;
  int job;
  int activejob;
  int balance;
  String department;
  String email;
  User({
      this.occupation,
      this.city,
      this.school,
      this.address,
      this.gender,
      this.fullname,
      this.skills,
      this.dp,
      this.uid,
      this.number,
      this.token,
      this.matnum,
      this.job,
      this.activejob,
      this.balance,
      this.department,this.email});

  factory User.fromDocument(DocumentSnapshot doc){
    return User(
      fullname: doc["name"],
      occupation: doc["occupation"],
      matnum: doc["matnum"],
      dp: doc["dp"],
      address: doc["address"],
      gender: doc["gender"],
      skills: doc["skill"],
      uid: doc["uid"],
      number: doc["phone"],
      school: doc["school"],
      token: doc["token"],
      department: doc['department'],
      job: doc['job'],
      activejob: doc['active'],
      balance: doc['balance'],
      city: doc['city'],
      email: doc['email']


    );
  }


}