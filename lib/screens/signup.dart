/*
    Author: Christian Jewel M. Pascua
    Section: D-1L
    Date created: 20 Nov 2022
    Program description: A Flutter shared todo list app.
*/

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:intl/intl.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController dateController = TextEditingController();
  final passwordConstraint =
      RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$');
  final _signUpKey = GlobalKey<FormState>();
  var signUpFields = List<String>.filled(7, "");

  @override
  void initState() {
    dateController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final name = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.face_outlined),
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

    final userName = TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        labelText: "Username",
        helperText: "",
      ),
      validator: (userName) {
        if (userName!.isEmpty) {
          return "Enter a username!";
        }
      },
      onSaved: (value) {
        setState(() {
          signUpFields[4] = value!;
        });
      },
    );

    final birthday = TextFormField(
      controller: dateController,
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_today),
        labelText: "Birthday",
        helperText: "",
      ),
      readOnly: true,
      validator: (birthday) {
        if (birthday!.isEmpty) {
          return "Enter birthday!";
        }
      },
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101));

        if (pickedDate != null) {
          print(pickedDate);
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          print(formattedDate);

          setState(() {
            dateController.text = formattedDate;
          });
        } else {
          print("Date is not selected");
        }
      },
      onSaved: (birthdate) {
        signUpFields[6] = birthdate!;
      },
    );

    final location = TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.location_on),
        labelText: "Location",
        helperText: "",
      ),
      validator: (location) {
        if (location!.isEmpty) {
          return "Enter location!";
        }
      },
      onSaved: (value) {
        setState(() {
          signUpFields[5] = value!;
        });
      },
    );

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
          signUpFields[0] = value!;
        });
      },
    );

    final password = TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        icon: Icon(Icons.lock),
        labelText: "Password",
        helperText: "",
      ),
      validator: (password) {
        return !passwordConstraint.hasMatch(password!)
            ? "Password must be at least 8 characters with at least a number, a special character, and both uppercase and lowercase letters!"
            : null;
      },
      onSaved: (value) {
        setState(() {
          signUpFields[1] = value!;
        });
      },
    );

    final signupButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          final form = _signUpKey.currentState;

          if (form!.validate()) {
            form.save();
            context.read<AuthProvider>().signUp(
                signUpFields[0],
                signUpFields[1],
                signUpFields[2],
                signUpFields[3],
                signUpFields[4],
                signUpFields[5],
                signUpFields[6]);
            Navigator.pop(context);
          }
        },
        child: const Text("Sign up", style: TextStyle(color: Colors.white)),
      ),
    );

    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextButton(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 14),
        ),
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Text("Go back to login screen"),
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
                  height: 5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              name,
              userName,
              birthday,
              location,
              email,
              password,
              signupButton,
              backButton
            ],
          ),
        ),
      ),
    );
  }
}
