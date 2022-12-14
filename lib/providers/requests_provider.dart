/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:flutter/material.dart';
import '../models/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/firebase_auth_api.dart';
import '../api/firebase_requests_api.dart';
import 'auth_provider.dart';

class RequestListProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late FirebaseRequestAPI firebaseService;
  late Stream<QuerySnapshot> _friendsStream;
  // static String userID = AuthProvider().user!.uid;
  String userID = "";
  var searchString = "";
  bool searchBoolean = false;
  AppUser? _selectedFriend;

  RequestListProvider() {
    authService = FirebaseAuthAPI();
    firebaseService = FirebaseRequestAPI();
    fetchFriends();
  }

  // getter
  // Future<List<User>> get friend => _friendList;
  Stream<QuerySnapshot> get friends => _friendsStream;
  AppUser get selected => _selectedFriend!;
  String get searchText => searchString;
  bool get searchBool => searchBoolean;

  void saveUserID() {
    userID = authService.getUserID();
  }

  changeSelectedFriend(String itemID, AppUser item) {
    item.id = itemID;
    _selectedFriend = item;
  }

  void fetchFriends() {
    _friendsStream = firebaseService.getAllFriends();
    notifyListeners();
  }

  void acceptRequest() async {
    saveUserID();
    String message =
        await firebaseService.acceptRequest(userID, _selectedFriend!.id);
    print(message);
    notifyListeners();
  }

  void rejectRequest() async {
    saveUserID();
    String message =
        await firebaseService.rejectRequest(userID, _selectedFriend!.id);
    print(message);
    notifyListeners();
  }
}
