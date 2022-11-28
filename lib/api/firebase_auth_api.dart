/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Exercise number: 7
    Program description: A Flutter todo app with user login functionality.
*/

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/screens/utils.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  void signIn(String email, String password) async {
    UserCredential credential;
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  void signOut() async {
    auth.signOut();
  }

  void signUp(
      String email, String password, String firstName, String lastName) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        saveUserToFirestore(credential.user?.uid, email, firstName, lastName);
      }
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    } catch (e) {
      print(e);
    }
  }

  void saveUserToFirestore(
      String? uid, String email, String firstName, String lastName) async {
    try {
      await db
          .collection("users")
          .doc(uid)
          .set({"email": email, "firstName": firstName, "lastName": lastName});
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}