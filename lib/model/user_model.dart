import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ChatModel {
  final String uid;
  final String key;
  final String text;
  final String datetime;

  ChatModel({
    required this.uid,
    required this.key,
    required this.text,
    required this.datetime,
  });
}

class UserModelStream {
  final String uid;

  UserModelStream({required this.uid});
}

class UserModel extends ChangeNotifier {
  String? uid;
  String? pic;
  String? bio;
  String? email;
  String? name;
  String? age;
  String? gender;
  String? state;
  String? status;
  DateTime? dateTime;
  GeoPoint? geoPoint;

  UserModel(
      {this.uid,
      this.pic,
      this.bio,
      this.email,
      this.name,
      this.age,
      this.gender,
      this.dateTime,
      this.state,
      this.status,
      this.geoPoint});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        pic: map['pic'],
        bio: map['bio'],
        email: map['email'],
        dateTime: map['dateTime'],
        name: map['name'],
        age: map['age'],
        gender: map['gender'],
        state: map['state'],
        status: map['status'],
        geoPoint: map['geoPoint']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'pic': pic,
      'bio': bio,
      'email': email,
      'name': name,
      'age': age,
      'gender': gender,
      'state': state,
      'status': status,
      'geoPoint': geoPoint
    };
  }
}

Future<UserModel> getUserModel() async {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel usermodel;
  final data = await FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .get();
  usermodel = UserModel.fromMap(data.data());

  return usermodel;
}