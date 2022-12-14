/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/auth_provider.dart';
import '../screens/signup.dart';

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
      key: const Key("emailFieldL"),
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
      key: const Key("passwordFieldL"),
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
      key: const Key("loginButton"),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          final form = _loginKey.currentState;

          if (form!.validate()) {
            form.save();
            // await UserSimplePreferences.setUsername();
            context.read<AuthProvider>().signIn(loginFields[0], loginFields[1]);
          }
        },
        child: const Text("Log In", style: TextStyle(color: Colors.white)),
      ),
    );

    final signupButton = Padding(
      key: const Key("signupButtonL"),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextButton(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 14),
        ),
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SignupPage(),
            ),
          );
        },
        child: const Text("Got no account yet? Click here to sign up!"),
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
                  fontWeight: FontWeight.bold,
                ),
              ),
              email,
              password,
              loginButton,
              signupButton,
            ],
          ),
        ),
      ),
    );
  }
}
