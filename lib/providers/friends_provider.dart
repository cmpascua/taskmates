/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/models/friends_model.dart';
import 'package:week7_networking_discussion/api/firebase_friends_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendListProvider with ChangeNotifier {
  late FirebaseFriendAPI firebaseService;
  late Stream<QuerySnapshot> _friendsStream;
  static const String userID = "sampleid1";
  var searchString = "";
  bool searchBoolean = false;
  Friend? _selectedFriend;

  FriendListProvider() {
    firebaseService = FirebaseFriendAPI();
    fetchFriends();
  }

  // getter
  // Future<List<Friend>> get friend => _friendList;
  Stream<QuerySnapshot> get friends => _friendsStream;
  Friend get selected => _selectedFriend!;
  String get searchText => searchString;
  bool get searchBool => searchBoolean;

  changeSelectedFriend(String itemID, Friend item) {
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
    // _friendList = friendAPI.fetchFriends();
    _friendsStream = firebaseService.getAllFriends();
    notifyListeners();
  }

  void sendRequest() async {
    String message =
        await firebaseService.sendRequest(userID, _selectedFriend!.id);
    print(message);
    notifyListeners();
  }

  void acceptRequest() async {
    String message =
        await firebaseService.sendRequest(userID, _selectedFriend!.id);
    print(message);
    notifyListeners();
  }

  void rejectRequest() async {
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
