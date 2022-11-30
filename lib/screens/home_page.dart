/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/screens/friends_page.dart';
import 'package:week7_networking_discussion/screens/todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int currentPage = 0;
  List<Widget> pages = const [TodoPage(), FriendPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              user.email!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        ListTile(
          title: const Text('Logout'),
          onTap: () {
            context.read<AuthProvider>().signOut();
            Navigator.pop(context);
          },
        ),
      ])),
      appBar: AppBar(
        title: const Text("Tasks"),
      ),
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(
              icon: Icon(Icons.supervisor_account_outlined), label: "Friends"),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
