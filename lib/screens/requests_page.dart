/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/users_model.dart';
import '../providers/friends_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import '../screens/friends_modal.dart';
import '../providers/auth_provider.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  // static const String userID = "6OlxYP36yzc9wrixOhYxKZi6aFx1";
  static String userID = AuthProvider().user!.uid;
  bool _searchBoolean = false;

  @override
  Widget build(BuildContext context) {
    // access the list of friends in the provider
    Stream<QuerySnapshot> friendsStream =
        context.watch<FriendListProvider>().friends;

    return Scaffold(
      appBar: AppBar(
        title: !_searchBoolean
            ? const Text("Received Requests")
            : _searchTextField(),
        actions: !_searchBoolean
            ? [
                IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _searchBoolean = true;
                      });
                    })
              ]
            : [
                IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchBoolean = false;
                      });
                    })
              ],
      ),
      body: StreamBuilder(
        stream: friendsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
              // child: Text("Loading..."),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No Friend Requests Found"),
            );
          }

          if (snapshot.data?.docs
              .firstWhere((doc) => doc.id == userID)["receivedFriendRequests"]
              .isEmpty) {
            var receivedRequests = snapshot.data?.docs.firstWhere(
                (doc) => doc.id == userID)["receivedFriendRequests"];
            return ListView.builder(
              itemCount: receivedRequests.length,
              itemBuilder: ((context, index) {
                String friendID = receivedRequests[index];
                AppUser friend = AppUser.fromJson(snapshot.data?.docs
                    .firstWhere((doc) => doc.id == friendID)
                    .data() as Map<String, dynamic>);
                return ListTile(
                  key: Key(friendID.toString()),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text("${friend.firstName} " " ${friend.lastName}"),
                  ),
                  subtitle: Text("@${friend.userName}"),
                  leading: Initicon(
                    text: "${friend.firstName} " " ${friend.lastName}",
                    size: 40,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          context
                              .read<FriendListProvider>()
                              .changeSelectedFriend(friendID, friend);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => FriendModal(
                              type: 'Send',
                            ),
                          );
                        },
                        icon: const Icon(Icons.person_add_alt_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          context
                              .read<FriendListProvider>()
                              .changeSelectedFriend(friendID, friend);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => FriendModal(
                              type: 'Unfriend',
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete_outline),
                      )
                    ],
                  ),
                  onTap: () {},
                );
              }),
            );
          } else {
            return const Center(
              child: Text("No Friend Requests Found"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/');
        },
        label: const Text('Friends'),
        icon: const Icon(Icons.supervisor_account_outlined),
      ),
    );
  }

  Widget _searchTextField() {
    return const TextField(
      autofocus: true,
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }
}
