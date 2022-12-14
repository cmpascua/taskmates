/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart';

import '../providers/auth_provider.dart';

class TodoModal extends StatelessWidget {
  String type;
  DateTime? dateTime;
  TextEditingController _titleFieldController = TextEditingController();
  TextEditingController _descFieldController = TextEditingController();

  TodoModal({
    super.key,
    required this.type,
  });

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (type) {
      case 'Add':
        return const Text("Add new todo");
      case 'Edit':
        return const Text("Edit todo");
      case 'Delete':
        return const Text("Delete todo");
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    // Use context.read to get the last updated list of todos
    // List<Todo> todoItems = context.read<TodoListProvider>().todo;
    switch (type) {
      case 'Delete':
        {
          return Text(
            "Are you sure you want to delete '${context.read<TodoListProvider>().selected.title}'?",
          );
        }
      case 'Add':
        {
          return Column(
            children: [
              TextField(
                controller: _titleFieldController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Title",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              DateTimeFormField(
                decoration: const InputDecoration(
                  hintText: "Deadline",
                  hintStyle: TextStyle(color: null),
                  errorStyle: TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.event_note),
                ),
                mode: DateTimeFieldPickerMode.dateAndTime,
                initialDatePickerMode: DatePickerMode.day,
                firstDate: DateTime.now(),
                autovalidateMode: AutovalidateMode.always,
                validator: (e) =>
                    (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                onDateSelected: (DateTime value) {
                  dateTime = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                controller: _descFieldController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Description",
                ),
              ),
            ],
          );
        }
      // Edit will have input field in them
      default:
        return Column(
          children: [
            TextField(
              controller: _titleFieldController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: context.read<TodoListProvider>().selected.title,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            DateTimeFormField(
              decoration: InputDecoration(
                hintText: context
                    .read<TodoListProvider>()
                    .selected
                    .deadline
                    .toString(),
                hintStyle: TextStyle(color: null),
                errorStyle: TextStyle(color: Colors.redAccent),
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.event_note),
              ),
              mode: DateTimeFieldPickerMode.dateAndTime,
              initialDatePickerMode: DatePickerMode.day,
              firstDate: DateTime.now(),
              autovalidateMode: AutovalidateMode.always,
              validator: (e) =>
                  (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
              onDateSelected: (DateTime value) {
                dateTime = value;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              controller: _descFieldController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: context.read<TodoListProvider>().selected.description,
              ),
            ),
          ],
        );
    }
  }

  TextButton _dialogAction(
      BuildContext context, String userID, String userName) {
    return TextButton(
      onPressed: () {
        switch (type) {
          case 'Add':
            {
              // Instantiate a todo objeect to be inserted, default userID will be 1, the id will be the next id in the list
              Todo temp = Todo(
                  ownerID: userID,
                  completed: false,
                  ownerUN: userName,
                  deadline: dateTime!,
                  description: _descFieldController.text,
                  title: _titleFieldController.text);

              context.read<TodoListProvider>().addTodo(temp);

              // Remove dialog after adding
              Navigator.of(context).pop();
              break;
            }
          case 'Edit':
            {
              context.read<TodoListProvider>().editTodo(
                  _titleFieldController.text,
                  _descFieldController.text,
                  dateTime!);

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'Delete':
            {
              context.read<TodoListProvider>().deleteTodo();

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(type),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userName = context.read<AuthProvider>().userName();
    String userID = context.read<AuthProvider>().userID();

    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),

      // Contains two buttons - add/edit/delete, and cancel
      actions: <Widget>[
        _dialogAction(context, userID, userName),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
