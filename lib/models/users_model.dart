/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'dart:convert';

class AppUser {
  String? id;
  String userName;
  String firstName;
  String lastName;
  String birthday;
  String location;
  String email;
  List<dynamic>? friends;
  List<dynamic>? receivedFriendRequests;
  List<dynamic>? sentFriendRequests;

  AppUser({
    this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.location,
    required this.email,
    this.friends,
    this.receivedFriendRequests,
    this.sentFriendRequests,
  });

  AppUser copy({
    String? id,
    required final String userName,
    required String firstName,
    required String lastName,
    required String birthday,
    required String location,
    required String email,
    List<dynamic>? friends,
    List<dynamic>? receivedFriendRequests,
    List<dynamic>? sentFriendRequests,
  }) =>
      AppUser(
        id: id ?? this.id,
        userName: userName ?? this.userName,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        birthday: birthday ?? this.birthday,
        location: location ?? this.location,
        email: email ?? this.email,
        friends: friends ?? this.friends,
        receivedFriendRequests:
            receivedFriendRequests ?? this.receivedFriendRequests,
        sentFriendRequests: sentFriendRequests ?? sentFriendRequests,
      );

  // Factory constructor to instantiate object from json format
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      userName: json['userName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthday: json['birthday'],
      location: json['location'],
      email: json['email'],
      friends: json['friends'],
      receivedFriendRequests: json['receivedFriendRequests'],
      sentFriendRequests: json['sentFriendRequests'],
    );
  }

  static List<AppUser> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<AppUser>((dynamic d) => AppUser.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(AppUser user) {
    return {
      'userName': user.userName,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'birthday': user.birthday,
      'location': user.location,
      'email': user.email,
      'friends': user.friends,
      'receivedFriendRequests': user.receivedFriendRequests,
      'sentFriendRequests': user.sentFriendRequests,
    };
  }
}
