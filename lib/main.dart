/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/friends_provider.dart';
import '../providers/requests_provider.dart';
import '../providers/todo_provider.dart';
import '../providers/auth_provider.dart';
import '../screens/home_page.dart';
import '../screens/requests_page.dart';
import '../screens/todo_page.dart';
import '../screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import '../utils/errorbar.dart';
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
        ChangeNotifierProvider(create: ((context) => RequestListProvider())),
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
      scaffoldMessengerKey: Errorbar.messengerKey,
      debugShowCheckedModeBanner: false,
      title: "TaskMates",
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
      },
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
      context.read<AuthProvider>().saveOwnerData();
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
