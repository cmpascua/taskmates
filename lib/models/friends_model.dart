/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'dart:convert';

class Friend {
  String? id;
  final String userName;
  String displayName;
  List<dynamic>? friends;
  List<dynamic>? receivedFriendRequests;
  List<dynamic>? sentFriendRequest;

  Friend({
    this.id,
    required this.userName,
    required this.displayName,
    this.friends,
    this.receivedFriendRequests,
    this.sentFriendRequest,
  });

  // Factory constructor to instantiate object from json format
  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      userName: json['userName'],
      displayName: json['displayName'],
      friends: json['friends'],
      receivedFriendRequests: json['receivedFriendRequests'],
      sentFriendRequest: json['sentFriendRequest'],
    );
  }

  static List<Friend> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Friend>((dynamic d) => Friend.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Friend friend) {
    return {
      'userName': friend.userName,
      'displayName': friend.displayName,
      'friends': friend.friends,
      'receivedFriendRequests': friend.receivedFriendRequests,
      'sentFriendRequest': friend.sentFriendRequest,
    };
  }
}
