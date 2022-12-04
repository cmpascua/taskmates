/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/main.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/screens/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginKey = GlobalKey<FormState>();
  var loginFields = List<String>.filled(2, "");

  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.email),
        labelText: "Email",
        helperText: "",
      ),
      validator: (email) {
        return email != null && !EmailValidator.validate(email)
            ? "Enter a valid email!"
            : null;
      },
      onSaved: (value) {
        setState(() {
          loginFields[0] = value!;
        });
      },
    );

    final password = TextFormField(
      obscureText: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        icon: Icon(Icons.lock),
        labelText: "Password",
        helperText: "",
      ),
      validator: (password) {
        return password != null && password.length < 8
            ? "Enter a password!"
            : null;
      },
      onSaved: (value) {
        setState(() {
          loginFields[1] = value!;
        });
      },
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          final form = _loginKey.currentState;

          if (form!.validate()) {
            form.save();
            context.read<AuthProvider>().signIn(loginFields[0], loginFields[1]);
          }
        },
        child: const Text("Log In", style: TextStyle(color: Colors.white)),
      ),
    );

    final logoutButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SignupPage(),
            ),
          );
        },
        child: const Text("Sign Up", style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _loginKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            children: <Widget>[
              const Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  height: 7,
                ),
              ),
              email,
              password,
              loginButton,
              logoutButton,
            ],
          ),
        ),
      ),
    );
  }
}
