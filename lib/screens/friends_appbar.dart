import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/friends_provider.dart';

class FriendsAppBar extends StatefulWidget {
  const FriendsAppBar({super.key});

  @override
  State<FriendsAppBar> createState() => _FriendsAppBarState();
}

class _FriendsAppBarState extends State<FriendsAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: !context.watch<FriendListProvider>().searchBool
          ? const Text("Friends")
          : _searchTextField(),
      actions: !context.read<FriendListProvider>().searchBool
          ? [
              IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    context.read<FriendListProvider>().changeSearchBool(true);
                  })
            ]
          : [
              IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    context.read<FriendListProvider>().changeSearchBool(false);
                  })
            ],
    );
  }

  Widget _searchTextField() {
    return TextField(
      onChanged: (value) {
        context.read<FriendListProvider>().changeSearchString(value);
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
        hintText: "Search by username",
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }
}
