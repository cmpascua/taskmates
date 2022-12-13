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
      email: "");
  User? userObj;

  AuthProvider() {
    authService = FirebaseAuthAPI();
    authService.getUser().listen((User? newUser) {
      userObj = newUser;
      notifyListeners();
    }, onError: (e) {});
  }

  User? get user => userObj;

  String userID() {
    return authService.getUserID();
  }

  // void updateOwnerData(String key, String details) {
  //   ownerDetails.update(key, (value) => details);
  // }

  void saveOwnerData() {
    final futureOwner = authService.getUserData();
    futureOwner.then((data) {
      owner.userName = data.userName;
      owner.firstName = data.firstName;
      owner.lastName = data.lastName;
      owner.birthday = data.birthday;
      owner.location = data.location;
      owner.email = data.email;
    }, onError: (e) {
      print(e);
    });
    print("Saved owner details!");
  }

  // void getOwnerData() {
  //   final futureOwner = authService.getUserData();
  //   futureOwner.then((data) {
  //     // print(data.userName);
  //     updateOwnerData("userName", data.userName);
  //     owner.userName = data.userName;
  //     owner.firstName = data.firstName;
  //     owner.lastName = data.lastName;
  //     owner.birthday = data.birthday;
  //     owner.location = data.location;
  //     owner.email = data.email;
  //     // print(ownerDetails["userName"]);
  //     print(owner.location);
  //   }, onError: (e) {
  //     print(e);
  //   });
  //   print("Saved owner!");
  // }

  // Map<String, dynamic>? getOwnerData(String field) {
  //   final futureOwner = authService.getUserData();
  //   futureOwner.then((data) {
  //     print("Owner data...");
  //     return data?.containsKey(field);
  //   }, onError: (e) {
  //     print(e);
  //   });
  //   return null;
  // }

  // Future<AppUser?> userDetails() {
  //   return authService.getUserDetails();
  // }

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
