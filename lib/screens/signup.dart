/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _signUpKey = GlobalKey<FormState>();
  var signUpFields = List<String>.filled(4, "");

  @override
  Widget build(BuildContext context) {
    final name = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: "First Name",
              helperText: "",
            ),
            validator: (firstName) {
              if (firstName!.isEmpty) {
                return "Enter a first name!";
              }
            },
            onSaved: (value) {
              setState(() {
                signUpFields[2] = value!;
              });
            },
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          flex: 2,
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: "Last Name",
              helperText: "",
            ),
            validator: (lastName) {
              if (lastName!.isEmpty) {
                return "Enter a last name!";
              }
            },
            onSaved: (value) {
              setState(() {
                signUpFields[3] = value!;
              });
            },
          ),
        ),
      ],
    );

    final email = TextFormField(
      decoration: const InputDecoration(
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
          signUpFields[0] = value!;
        });
      },
    );

    final password = TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Password",
        helperText: "",
      ),
      validator: (password) {
        return password != null && password.length < 6
            ? "Password must be at least 6 characters!"
            : null;
      },
      onSaved: (value) {
        setState(() {
          signUpFields[1] = value!;
        });
      },
    );

    final SignupButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          final form = _signUpKey.currentState;

          if (form!.validate()) {
            form.save();
            context.read<AuthProvider>().signUp(signUpFields[0],
                signUpFields[1], signUpFields[2], signUpFields[3]);
            Navigator.pop(context);
          }
        },
        child: const Text("Sign up", style: TextStyle(color: Colors.white)),
      ),
    );

    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Text("Back", style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _signUpKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            children: <Widget>[
              const Text(
                "Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  height: 7,
                ),
              ),
              name,
              email,
              password,
              SignupButton,
              backButton
            ],
          ),
        ),
      ),
    );
  }
}
