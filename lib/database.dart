import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _userCollection =
    _firestore.collection('users');

class Database {
  static String? userUid;

  static saveUserData(User? user, Map<String, dynamic> data) {
    _userCollection
        .doc(user!.uid)
        .set(data, SetOptions(merge: true))
        .then((_) => debugPrint("Données sauvegardées sur le cloud"))
        .catchError((onError) {
      print("Data unsaved because of error " + onError.toString());
    });
  }

  static getUserData(User? user) async {
    final docUser = _userCollection.doc(user!.uid);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      print("Data get" + snapshot.data().toString());
      return snapshot.data();
    }
    return null;
  }
}
