/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week7_networking_discussion/api/firebase_auth_api.dart';
import 'package:week7_networking_discussion/models/users_model.dart';

class AuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  AppUser owner = AppUser(
    userName: "",
    firstName: "",
    lastName: "",
    birthday: "",
    location: "",
    email: "",
    sentFriendRequests: [],
    receivedFriendRequests: [],
    friends: [],
  );
  User? userObj;

  AuthProvider() {
    authService = FirebaseAuthAPI();
    authService.getUser().listen((User? newUser) {
      userObj = newUser;
      notifyListeners();
    }, onError: (e) {});
  }

  User? get user => userObj;
  AppUser get loggedUser => owner;

  String userID() {
    return authService.getUserID();
  }

  String userName() {
    return owner.userName;
  }

  void saveOwnerData() {
    final futureOwner = authService.getUserData();
    futureOwner.then((data) {
      owner.userName = data.userName;
      owner.firstName = data.firstName;
      owner.lastName = data.lastName;
      owner.birthday = data.birthday;
      owner.location = data.location;
      owner.email = data.email;
      owner.sentFriendRequests = data.sentFriendRequests;
      owner.receivedFriendRequests = data.receivedFriendRequests;
      owner.friends = data.friends;
    }, onError: (e) {
      print(e);
    });
    print("Saved owner details!");
  }

  bool get isAuthenticated {
    return user != null;
  }

  void signIn(String email, String password) {
    authService.signIn(email, password);
    Timer(const Duration(seconds: 3), () {
      saveOwnerData();
    });
  }

  void signOut() {
    authService.signOut();
  }

  void signUp(String email, String password, String firstName, String lastName,
      String userName, String location, String birthday) {
    authService.signUp(
        email, password, firstName, lastName, userName, location, birthday);
  }
}
