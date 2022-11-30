/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/friends_model.dart';
import 'package:week7_networking_discussion/providers/friends_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:week7_networking_discussion/screens/modal_friends.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  static const String userID = "sampleid1";
  var searchString = "";
  bool _searchBoolean = false;

  @override
  Widget build(BuildContext context) {
    // access the list of friends in the provider
    Stream<QuerySnapshot> friendsStream =
        context.watch<FriendListProvider>().friends;

    // return Scaffold(
    //   appBar: AppBar(
    //     title: !_searchBoolean ? const Text("Friends") : _searchTextField(),
    //     actions: !_searchBoolean
    //         ? [
    //             IconButton(
    //                 icon: const Icon(Icons.search),
    //                 onPressed: () {
    //                   setState(() {
    //                     _searchBoolean = true;
    //                   });
    //                 })
    //           ]
    //         : [
    //             IconButton(
    //                 icon: const Icon(Icons.clear),
    //                 onPressed: () {
    //                   setState(() {
    //                     _searchBoolean = false;
    //                   });
    //                 })
    //           ],
    //   ),
    return Stack(children: [
      StreamBuilder(
        stream: friendsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No Friends Found"),
            );
          } else if (_searchBoolean) {
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  String friendID = snapshot.data!.docs[index].id;
                  Friend friend = Friend.fromJson(snapshot.data?.docs[index]
                      .data() as Map<String, dynamic>);

                  if (searchString.isEmpty) {
                    return Container();
                  }

                  if (friend.displayName.toString().startsWith(searchString)) {
                    return ListTile(
                      key: Key(index.toString()),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(friend.displayName),
                      ),
                      subtitle: Text("@${friend.userName}"),
                      leading: Initicon(
                        text: friend.displayName,
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
                  }

                  return Container();
                });
          } else {
            var userFriends = snapshot.data?.docs
                .firstWhere((doc) => doc.id == userID)["friends"];
            return ListView.builder(
              itemCount: userFriends.length,
              itemBuilder: ((context, index) {
                String friendID = userFriends[index];
                Friend friend = Friend.fromJson(snapshot.data?.docs
                    .firstWhere((doc) => doc.id == friendID)
                    .data() as Map<String, dynamic>);
                return ListTile(
                  key: Key(index.toString()),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(friend.displayName),
                  ),
                  subtitle: Text("@${friend.userName}"),
                  leading: Initicon(
                    text: friend.displayName,
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
          }
        },
      ),
      Positioned(
        right: 10,
        bottom: 10,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/');
          },
          label: const Text('Friends'),
          icon: const Icon(Icons.supervisor_account_outlined),
        ),
        // child: Icon(Icons.add),
        // backgroundColor: Colors.red,
      ),
    ]);
    // floatingActionButton: FloatingActionButton.extended(
    //   onPressed: () {
    //     Navigator.pop(context);
    //     Navigator.pushNamed(context, '/');
    //   },
    //   label: const Text('Friends'),
    //   icon: const Icon(Icons.supervisor_account_outlined),
    // ),
  }

  Widget _searchTextField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          searchString = value;
        });
      },
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintText: "Search by display name",
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }
}
