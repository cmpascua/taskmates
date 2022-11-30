/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/friends_provider.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/screens/home_page.dart';
import 'package:week7_networking_discussion/screens/todo_page.dart';
import 'package:week7_networking_discussion/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:week7_networking_discussion/screens/utils.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => TodoListProvider())),
        ChangeNotifierProvider(create: ((context) => AuthProvider())),
        ChangeNotifierProvider(create: ((context) => FriendListProvider())),
      ],
      child: MyApp(),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: Utils.messengerKey,
      debugShowCheckedModeBanner: false,
      title: 'SimpleTodo',
      initialRoute: '/',
      routes: {'/': (context) => const AuthWrapper()},
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().isAuthenticated) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
