import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/users_model.dart';
import '../providers/auth_provider.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    AppUser loggedUser = context.read<AuthProvider>().loggedUser;
    return AppBar(
      title: Text("About ${loggedUser.userName}"),
    );
  }
}
