/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';

class FirebaseRequestAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  // static const String userID = "6OlxYP36yzc9wrixOhYxKZi6aFx1";
  static String userID = AuthProvider().user!.uid;

  Stream<QuerySnapshot> getAllFriends() {
    return db.collection("users").snapshots();
  }

  // user accepts friend request of newFriend
  Future<String> acceptRequest(String? userID, String? newFriendID) async {
    try {
      print("Accepted Request: $newFriendID");

      // user appends newFriend to their friends
      await db.collection("users").doc(userID).update({
        "friends": FieldValue.arrayUnion([newFriendID])
      });

      // user appends themselves to newFriend's friends
      await db.collection("users").doc(newFriendID).update({
        "friends": FieldValue.arrayUnion([userID])
      });

      // user removes newFriend from their receivedFriendRequests
      await db.collection("users").doc(userID).update({
        "receivedFriendRequests": FieldValue.arrayRemove([newFriendID])
      });

      // user removes themselves from newFriend's sentFriendRequest
      await db.collection("users").doc(newFriendID).update({
        "sentFriendRequests": FieldValue.arrayRemove([userID])
      });

      return "Successfully added friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // user rejects friend request of newFriend
  Future<String> rejectRequest(String? userID, String? newFriendID) async {
    try {
      print("Rejected Request: $newFriendID");

      // user removes newFriend from their receivedFriendRequests
      await db.collection("users").doc(userID).update({
        "receivedFriendRequests": FieldValue.arrayRemove([newFriendID])
      });

      // user removes themselves from newFriend's sentFriendRequest
      await db.collection("users").doc(newFriendID).update({
        "sentFriendRequests": FieldValue.arrayRemove([userID])
      });

      return "Rejected friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
