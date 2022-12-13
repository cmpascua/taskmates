/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/users_model.dart';
import 'package:week7_networking_discussion/providers/friends_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:week7_networking_discussion/screens/modal_friends.dart';
import 'package:week7_networking_discussion/screens/modal_users.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  static const String userID = "6OlxYP36yzc9wrixOhYxKZi6aFx1";
  // var searchString = "";
  // bool _searchBoolean = false;

  @override
  Widget build(BuildContext context) {
    // access the list of friends in the provider
    Stream<QuerySnapshot> friendsStream =
        context.watch<FriendListProvider>().friends;

    return StreamBuilder(
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
        } else if (context.watch<FriendListProvider>().searchBool) {
          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                String friendID = snapshot.data!.docs[index].id;
                AppUser friend = AppUser.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>);

                if (context.watch<FriendListProvider>().searchText.isEmpty) {
                  return Container();
                }

                if (friend.userName.toString().startsWith(
                    context.watch<FriendListProvider>().searchText)) {
                  return Card(
                    child: ListTile(
                      key: Key(index.toString()),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(friend.firstName + " " + friend.lastName),
                      ),
                      subtitle: Text("@${friend.userName}"),
                      leading: Initicon(
                        text: friend.firstName + " " + friend.lastName,
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
                      onTap: () {
                        context
                            .read<FriendListProvider>()
                            .changeSelectedFriend(friendID, friend);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => const UserModal(),
                        );
                      },
                    ),
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
              AppUser friend = AppUser.fromJson(snapshot.data?.docs
                  .firstWhere((doc) => doc.id == friendID)
                  .data() as Map<String, dynamic>);
              return Card(
                child: ListTile(
                  key: Key(index.toString()),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(friend.firstName + " " + friend.lastName),
                  ),
                  subtitle: Text("@${friend.userName}"),
                  leading: Initicon(
                    text: friend.firstName + " " + friend.lastName,
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
                  onTap: () {
                    context
                        .read<FriendListProvider>()
                        .changeSelectedFriend(friendID, friend);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => const UserModal(),
                    );
                  },
                ),
              );
            }),
          );
        }
      },
    );
  }
}
