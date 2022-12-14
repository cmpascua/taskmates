/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/users_model.dart';
import '../providers/friends_provider.dart';
import '../providers/requests_provider.dart';

class FriendModal extends StatelessWidget {
  String type;

  FriendModal({
    super.key,
    required this.type,
  });

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (type) {
      case 'Send':
        return const Text("Send friend request");
      case 'Accept':
        return const Text("Accept friend request");
      case 'Reject':
        return const Text("Reject friend request");
      case 'Unfriend':
        return const Text("Unfriend");
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    switch (type) {
      case 'Unfriend':
        {
          return Text(
            "Are you sure you want to unfriend '${context.read<FriendListProvider>().selected.userName}'?",
          );
        }
      default:
        return const Text("Confirm action?");
    }
  }

  TextButton _dialogAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        switch (type) {
          case 'Send':
            {
              context.read<FriendListProvider>().sendRequest();

              // Remove dialog after adding
              Navigator.of(context).pop();
              break;
            }
          case 'Accept':
            {
              context.read<RequestListProvider>().acceptRequest();

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'Reject':
            {
              context.read<RequestListProvider>().rejectRequest();

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'Unfriend':
            {
              context.read<FriendListProvider>().unfriend();

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
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
