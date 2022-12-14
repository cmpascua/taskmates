/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:flutter/material.dart';
import '../models/users_model.dart';
import '../api/firebase_friends_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';
import '../api/firebase_auth_api.dart';

class FriendListProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late FirebaseFriendAPI firebaseService;
  late Stream<QuerySnapshot> _friendsStream;
  // static String userID = AuthProvider().user!.uid;
  String userID = "";
  var searchString = "";
  bool searchBoolean = false;
  AppUser? _selectedFriend;

  FriendListProvider() {
    authService = FirebaseAuthAPI();
    firebaseService = FirebaseFriendAPI();
    fetchFriends();
  }

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

  changeSearchString(String username) {
    searchString = username;
    notifyListeners();
  }

  changeSearchBool(bool value) {
    searchBoolean = value;
    notifyListeners();
  }

  void fetchFriends() {
    _friendsStream = firebaseService.getAllFriends();
    notifyListeners();
  }

  void sendRequest() async {
    saveUserID();
    String message =
        await firebaseService.sendRequest(userID, _selectedFriend!.id);
    print("Selected Friend ID is...");
    print(_selectedFriend!.id);
    print(message);
    notifyListeners();
  }

  void unfriend() async {
    saveUserID();
    String message =
        await firebaseService.unfriend(userID, _selectedFriend!.id);
    print(message);
    notifyListeners();
  }
}
