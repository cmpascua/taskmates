import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/requests_provider.dart';
import 'package:week7_networking_discussion/screens/requests_page.dart';
import '../models/users_model.dart';
// import '../providers/friends_provider.dart';
import '../providers/requests_provider.dart';
import 'modal_friends.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // String userID = context.read<AuthProvider>().userID();
    // print(userID);
    String userID = "6OlxYP36yzc9wrixOhYxKZi6aFx1";
    Stream<QuerySnapshot> friendsStream =
        context.watch<RequestListProvider>().friends;

    // return buildAvatar();
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32.0),
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
              },
              child: const Text("Logout"),
            ),
            const SizedBox(height: 48.0),
            const Text("Received Friend Requests",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: friendsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error encountered! ${snapshot.error}"),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                      // child: Text("Loading..."),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: Text("No Friend Requests Found"),
                    );
                  } else {
                    // if (snapshot.data?.docs
                    //     .firstWhere(
                    //         (doc) => doc.id == userID)["receivedFriendRequests"]
                    //     .isEmpty) {
                    var receivedRequests = snapshot.data?.docs.firstWhere(
                        (doc) => doc.id == userID)["receivedFriendRequests"];
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: receivedRequests.length,
                      itemBuilder: ((context, index) {
                        String friendID = receivedRequests[index];
                        User friend = User.fromJson(snapshot.data?.docs
                            .firstWhere((doc) => doc.id == friendID)
                            .data() as Map<String, dynamic>);
                        return Card(
                          child: ListTile(
                            key: Key(friendID.toString()),
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                  friend.firstName + " " + friend.lastName),
                            ),
                            subtitle: Text("@${friend.userName}"),
                            leading: Initicon(
                              text: friend.firstName + " " + friend.lastName,
                              size: 40,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<RequestListProvider>()
                                        .changeSelectedFriend(friendID, friend);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          FriendModal(
                                        type: 'Accept',
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.check),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<RequestListProvider>()
                                        .changeSelectedFriend(friendID, friend);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          FriendModal(
                                        type: 'Reject',
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.close),
                                )
                              ],
                            ),
                            onTap: () {},
                          ),
                        );
                      }),
                    );
                  }
                  // else {
                  //   return const Center(
                  //     child: Text("No Friend Requests Found"),
                  //   );
                  // }
                },
              ),
            ),
            // buildDetails(),
          ],
        ),
      ],
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

// Widget buildRequests() {
//   return Container(
//     child: StreamBuilder(
//         stream: friendsStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text("Error encountered! ${snapshot.error}"),
//             );
//           } else if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//               // child: Text("Loading..."),
//             );
//           } else if (!snapshot.hasData) {
//             return const Center(
//               child: Text("No Friend Requests Found"),
//             );
//           }

//           if (snapshot.data?.docs
//               .firstWhere((doc) => doc.id == userID)["receivedFriendRequests"]
//               .isEmpty) {
//             var receivedRequests = snapshot.data?.docs.firstWhere(
//                 (doc) => doc.id == userID)["receivedFriendRequests"];
//             return ListView.builder(
//               itemCount: receivedRequests.length,
//               itemBuilder: ((context, index) {
//                 String friendID = receivedRequests[index];
//                 User friend = User.fromJson(snapshot.data?.docs
//                     .firstWhere((doc) => doc.id == friendID)
//                     .data() as Map<String, dynamic>);
//                 return ListTile(
//                   key: Key(friendID.toString()),
//                   title: Padding(
//                     padding: const EdgeInsets.only(bottom: 5.0),
//                     child: Text("${friend.firstName} " " ${friend.lastName}"),
//                   ),
//                   subtitle: Text("@${friend.userName}"),
//                   leading: Initicon(
//                     text: "${friend.firstName} " " ${friend.lastName}",
//                     size: 40,
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           context
//                               .read<FriendListProvider>()
//                               .changeSelectedFriend(friendID, friend);
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) => FriendModal(
//                               type: 'Send',
//                             ),
//                           );
//                         },
//                         icon: const Icon(Icons.person_add_alt_outlined),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           context
//                               .read<FriendListProvider>()
//                               .changeSelectedFriend(friendID, friend);
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) => FriendModal(
//                               type: 'Unfriend',
//                             ),
//                           );
//                         },
//                         icon: const Icon(Icons.delete_outline),
//                       )
//                     ],
//                   ),
//                   onTap: () {},
//                 );
//               }),
//             );
//           } else {
//             return const Center(
//               child: Text("No Friend Requests Found"),
//             );
//           }
//         },
//       ),
//   )
// }

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
