/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/users_model.dart';
import 'package:week7_networking_discussion/providers/friends_provider.dart';

class UserModal extends StatelessWidget {
  const UserModal({super.key});

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildAvatar(context),
        const SizedBox(
          height: 12,
        ),
        buildName(context),
        const SizedBox(height: 24.0),
        buildUserDetails(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("User Details"),
      content: _buildContent(context),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text("Close"),
        ),
      ],
    );
  }

  Widget buildAvatar(BuildContext context) {
    return Stack(children: [
      IconButton(
        onPressed: () {},
        icon: Initicon(
          text: context.read<FriendListProvider>().selected.firstName +
              " " +
              context.read<FriendListProvider>().selected.lastName,
          size: 72,
        ),
        iconSize: 72,
      ),
      Positioned(bottom: 0, right: 4, child: buildPersonIcon(Colors.lightBlue)),
    ]);
  }

  Widget buildName(BuildContext context) {
    return Column(children: [
      Text(
          context.read<FriendListProvider>().selected.firstName +
              " " +
              context.read<FriendListProvider>().selected.lastName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
      Text(
        context.read<FriendListProvider>().selected.email,
        style: TextStyle(color: Colors.grey),
      ),
    ]);
  }

  Widget buildUserDetails(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildButton(context,
            context.read<FriendListProvider>().selected.birthday, "Birthday"),
        buildDivider(),
        buildButton(context,
            context.read<FriendListProvider>().selected.location, "Location"),
      ],
    );
  }

  Widget buildDivider() => Container(
        height: 24,
        // width: 24,
        child: const VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );

  Widget buildPersonIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 5,
          child: const Icon(
            Icons.person_outline,
            color: Colors.white,
            size: 15,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
  }
}
