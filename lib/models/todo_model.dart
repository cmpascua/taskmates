/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'dart:convert';

class Todo {
  final String ownerID;
  String? id;
  String ownerUN;
  String title;
  String description;
  DateTime deadline;
  bool completed;

  Todo({
    required this.ownerID,
    this.id,
    required this.ownerUN,
    required this.title,
    required this.description,
    required this.deadline,
    required this.completed,
  });

  // Factory constructor to instantiate object from json format
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      ownerID: json['ownerID'],
      id: json['id'],
      ownerUN: json['ownerUN'],
      title: json['title'],
      description: json['description'],
      deadline: json['deadline'].toDate(),
      completed: json['completed'],
    );
  }

  static List<Todo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Todo>((dynamic d) => Todo.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Todo todo) {
    return {
      'ownerID': todo.ownerID,
      'ownerUN': todo.ownerUN,
      'title': todo.title,
      'description': todo.description,
      'deadline': todo.deadline,
      'completed': todo.completed,
    };
  }
}
