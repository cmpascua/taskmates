/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/utils/errorbar.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  late String uid = "";

  void inputData() {
    final User? user = auth.currentUser;
    uid = user!.uid;
    print(uid);
  }

  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  String getUserID() {
    return uid;
  }

  void signIn(String email, String password) async {
    UserCredential credential;
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      inputData();
    } on FirebaseAuthException catch (e) {
      Errorbar.showSnackBar(e.message);
    }
  }

  void signOut() async {
    auth.signOut();
  }

  void signUp(String email, String password, String firstName, String lastName,
      String userName, String location, String birthday) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        saveUserToFirestore(credential.user?.uid, email, firstName, lastName,
            userName, location, birthday);
      }
    } on FirebaseAuthException catch (e) {
      Errorbar.showSnackBar(e.message);
    } catch (e) {
      print(e);
    }
  }

  void saveUserToFirestore(
      String? uid,
      String email,
      String firstName,
      String lastName,
      String userName,
      String location,
      String birthday) async {
    List<String> friends = [];
    List<String> receivedFriendRequests = [];
    List<String> sentFriendRequests = [];
    try {
      await db.collection("users").doc(uid).set({
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "userName": userName,
        "location": location,
        "birthday": birthday,
        "friends": friends,
        "receivedFriendRequests": receivedFriendRequests,
        "sentFriendRequests": sentFriendRequests,
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
