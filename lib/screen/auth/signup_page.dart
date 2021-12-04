import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/screen/home/home_page.dart';

class SignUp extends StatefulWidget {
  final FirebaseAuth auth;
  const SignUp({Key? key, required this.auth}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _name;
  String? _password;
  bool loading = false;
  // String? _confirmPassword;
  // String? _displayName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter User Name';
                  }
                  return null;
                },
                onSaved: (val) {
                  _name = val;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Name",
                    fillColor: Colors.white70),
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Email';
                  }
                  return null;
                },
                onSaved: (val) {
                  _email = val;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Email",
                    fillColor: Colors.white70),
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Password';
                  }
                  return null;
                },
                obscureText: true,
                onSaved: (val) {
                  _password = val;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Password",
                    fillColor: Colors.white70),
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please reenter pssword';
                  } else if (value != _password) {
                    return 'Password and confirm password does not match ';
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Confirm Password",
                    fillColor: Colors.white70),
              ),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          try {
                            setState(() {
                              loading = true;
                            });
                            //create a user //
                            await widget.auth.createUserWithEmailAndPassword(
                                email: _email!, password: _password!);
                            // if success login //
                            await widget.auth.signInWithEmailAndPassword(
                                email: _email!, password: _password!);

                            await widget.auth.currentUser
                                ?.updateDisplayName(_name);
                            //Navigate to home page //
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                                (route) => false);
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              loading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.message.toString())),
                            );
                            log(e.message.toString() + " mag");
                          } catch (e) {
                            setState(() {
                              loading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        }
                      },
                child: const Text('Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
