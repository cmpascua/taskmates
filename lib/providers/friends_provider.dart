/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/models/users_model.dart';
import 'package:week7_networking_discussion/api/firebase_friends_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

class FriendListProvider with ChangeNotifier {
  late FirebaseFriendAPI firebaseService;
  late Stream<QuerySnapshot> _friendsStream;
  static String userID = AuthProvider().user!.uid;
  var searchString = "";
  bool searchBoolean = false;
  AppUser? _selectedFriend;

  FriendListProvider() {
    firebaseService = FirebaseFriendAPI();
    fetchFriends();
  }

  Stream<QuerySnapshot> get friends => _friendsStream;
  AppUser get selected => _selectedFriend!;
  String get searchText => searchString;
  bool get searchBool => searchBoolean;

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
    String message =
        await firebaseService.sendRequest(userID, _selectedFriend!.id);
    print(message);
    notifyListeners();
  }

  void unfriend() async {
    String message =
        await firebaseService.unfriend(userID, _selectedFriend!.id);
    print(message);
    notifyListeners();
  }
}
