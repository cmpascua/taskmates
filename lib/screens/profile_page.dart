import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // return buildAvatar();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildAvatar(),
          const SizedBox(
            height: 12,
          ),
          buildName(),
          const SizedBox(height: 32.0),
          buildUserDetails(context),
          const SizedBox(height: 32.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12)),
            onPressed: () {
              context.read<AuthProvider>().signOut();
              Navigator.pop(context);
            },
            child: const Text("Logout"),
          ),
          // const SizedBox(height: 32.0),
          // buildDetails(),
        ],
      ),
    );
  }
}

Widget buildAvatar() {
  return Stack(children: [
    IconButton(
      onPressed: () {},
      icon: const Initicon(
        text: "User McUser",
        size: 96,
      ),
      iconSize: 96,
    ),
    Positioned(bottom: 0, right: 4, child: buildStarsIcon(Colors.lightBlue)),
  ]);
}

Widget buildName() {
  return Column(children: const [
    Text("User McUser",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
    Text(
      "user@email.com",
      style: TextStyle(color: Colors.grey),
    ),
  ]);
}

Widget buildDetails() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("About",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        SizedBox(height: 16),
        Text(
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );
}

Widget buildUserDetails(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      buildButton(context, "November 19", "Birthday"),
      buildDivider(),
      buildButton(context, "Quezon, City", "Location"),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 2),
          Text(
            text,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );

Widget buildStarsIcon(Color color) => buildCircle(
      color: Colors.white,
      all: 3,
      child: buildCircle(
        color: color,
        all: 8,
        child: const Icon(
          Icons.stars,
          color: Colors.white,
          size: 20,
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
