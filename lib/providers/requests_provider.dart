/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/models/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/firebase_requests_api.dart';

class RequestListProvider with ChangeNotifier {
  late FirebaseRequestAPI firebaseService;
  late Stream<QuerySnapshot> _friendsStream;
  static const String userID = "6OlxYP36yzc9wrixOhYxKZi6aFx1";
  var searchString = "";
  bool searchBoolean = false;
  AppUser? _selectedFriend;

  RequestListProvider() {
    firebaseService = FirebaseRequestAPI();
    fetchFriends();
  }

  // getter
  // Future<List<User>> get friend => _friendList;
  Stream<QuerySnapshot> get friends => _friendsStream;
  AppUser get selected => _selectedFriend!;
  String get searchText => searchString;
  bool get searchBool => searchBoolean;

  changeSelectedFriend(String itemID, AppUser item) {
    item.id = itemID;
    _selectedFriend = item;
  }

  void fetchFriends() {
    _friendsStream = firebaseService.getAllFriends();
    notifyListeners();
  }

  void acceptRequest() async {
    String message =
        await firebaseService.acceptRequest(userID, _selectedFriend!.id);
    print(message);
    notifyListeners();
  }

  void rejectRequest() async {
    String message =
        await firebaseService.rejectRequest(userID, _selectedFriend!.id);
    print(message);
    notifyListeners();
  }
}
