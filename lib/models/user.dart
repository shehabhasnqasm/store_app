import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const String cid = "id";
const String cname = "name";
const String cemail = "email";
const String cphoneNumber = "phoneNumber";
const String cimageUrl = "imageUrl";
const String cjoinedAt = "joinedAt";
const String ccreatedAt = "createdAt";

class UserModel with ChangeNotifier {
  final String uid;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? imageUrl;
  final String? joinedAt;
  final String createdAt;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.imageUrl,
      required this.joinedAt,
      required this.createdAt});

  factory UserModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return UserModel(
      // or
      uid: documentSnapshot[cid], // documentSnapshot['uid'],
      name: documentSnapshot[cname],
      email: documentSnapshot[cemail],
      phoneNumber: documentSnapshot[cphoneNumber],
      imageUrl: documentSnapshot[cimageUrl],
      joinedAt: documentSnapshot[cjoinedAt],
      createdAt: documentSnapshot[ccreatedAt],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      cid: uid,
      cname: name,
      cemail: email,
      cphoneNumber: phoneNumber,
      cimageUrl: imageUrl,
      cjoinedAt: joinedAt,
      ccreatedAt: createdAt,
    };
  }
}
