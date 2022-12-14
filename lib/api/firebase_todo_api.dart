/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../notification_service.dart';

// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

class FirebaseTodoAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  int notificationID = 0;

  Future<String> addTodo(Map<String, dynamic> todo) async {
    try {
      final docRef = await db.collection("todos").add(todo);
      await db.collection("todos").doc(docRef.id).update({'id': docRef.id});
      // print(todo['title']);
      // print(todo['dateTime'].toString());

      // scheduleTodo(todo);

      print((todo['deadline'].millisecondsSinceEpoch / 1000).floor() -
          (DateTime.now().millisecondsSinceEpoch / 1000).floor());
      NotificationService().showNotification(
        notificationID++,
        todo['title'],
        todo['description'],
        ((todo['deadline'].millisecondsSinceEpoch / 1000).floor() -
            (DateTime.now().millisecondsSinceEpoch / 1000).floor()),
      );

      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // void scheduleTodo(Map<String, dynamic> todo) async {
  //   await flutterLocalNotificationsPlugin.schedule(
  //     notificationID++,
  //     'Time Expired',
  //     todo['title']!,
  //     todo['deadline']!,
  //     const NotificationDetails(
  //         android: AndroidNotificationDetails('1', 'Time Expired',
  //             channelDescription: 'Task Reminder')),
  //     androidAllowWhileIdle: true,
  //   );
  //   await flutterLocalNotificationsPlugin.schedule(
  //     notificationID++,
  //     todo['deadline']!.difference(DateTime.now()).inMinutes / 2 < 60
  //         ? '${todo['deadline']!.difference(DateTime.now()).inMinutes / 2} Mins left'
  //         : '${todo['deadline']!.difference(DateTime.now()).inHours / 2} Hours left',
  //     todo['title']!,
  //     todo['deadline']!.subtract(Duration(
  //         minutes: (todo['deadline']!.difference(DateTime.now()).inMinutes / 2)
  //             .toInt())),
  //     const NotificationDetails(
  //         android: AndroidNotificationDetails('5', 'Time Left',
  //             channelDescription: 'Task Reminder')),
  //     androidAllowWhileIdle: true,
  //   );
  // }

  Stream<QuerySnapshot> getAllTodos() {
    return db.collection("todos").snapshots();
  }

  Future<String> deleteTodo(String? id) async {
    try {
      await db.collection("todos").doc(id).delete();

      return "Successfully deleted todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editTodo(
      String? id, String title, String description, DateTime deadline) async {
    try {
      print("New String: $title");
      await db.collection("todos").doc(id).update({"title": title});

      print("New String: $description");
      await db.collection("todos").doc(id).update({"description": description});

      print("New DateTime: ${deadline.toString()}");
      await db.collection("todos").doc(id).update({"deadline": deadline});

      return "Successfully edited todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> toggleStatus(String? id, bool status) async {
    try {
      await db.collection("todos").doc(id).update({"completed": status});

      return "Successfully edited todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
