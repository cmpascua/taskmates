/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/screens/todo_modal.dart';
import 'package:week7_networking_discussion/screens/friends_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;

    return Stack(
      children: [
        StreamBuilder(
          stream: todosStream,
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
                child: Text("No Tasks Found"),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((context, index) {
                Todo todo = Todo.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>);
                return Dismissible(
                  key: Key(todo.id.toString()),
                  onDismissed: (direction) {
                    context.read<TodoListProvider>().changeSelectedTodo(todo);
                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) => TodoModal(
                    //     type: 'Delete',
                    //   ),
                    // );
                    context.read<TodoListProvider>().deleteTodo();

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${todo.title} dismissed')));
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete),
                  ),
                  child: Card(
                    child: ListTile(
                      title: Text(todo.title),
                      subtitle: Text("@${todo.ownerUN}"),
                      onTap: () {
                        context
                            .read<TodoListProvider>()
                            .changeSelectedTodo(todo);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => TodoModal(
                            type: 'Edit',
                          ),
                        );
                      },
                      leading: Checkbox(
                        value: todo.completed,
                        onChanged: (bool? value) {
                          context
                              .read<TodoListProvider>()
                              .changeSelectedTodo(todo);
                          context.read<TodoListProvider>().toggleStatus(value!);
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              // context
                              //     .read<TodoListProvider>()
                              //     .changeSelectedTodo(todo);
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) => TodoModal(
                              //     type: 'Share',
                              //   ),
                              // );
                            },
                            icon: const Icon(Icons.share),
                          ),
                          IconButton(
                            onPressed: () {
                              context
                                  .read<TodoListProvider>()
                                  .changeSelectedTodo(todo);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => TodoModal(
                                  type: 'Delete',
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete_outlined),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => TodoModal(
                  type: 'Add',
                ),
              );
            },
            child: const Icon(Icons.add_outlined),
          ),
          // child: Icon(Icons.add),
          // backgroundColor: Colors.red,
        ),
      ],
    );
  }
}
