import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ishare/Auth/help.dart';
import 'package:ishare/Views/Home.dart';
import 'package:ishare/Views/Register.dart';

class Log extends StatefulWidget {
  const Log({super.key});

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {
  final formkey = GlobalKey<FormState>();
  bool _isload = false;
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return _isload
        ? Center(
            child: CircularProgressIndicator(color: Colors.black),
          )
        : Scaffold(
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                        key: formkey,
                        child: Column(
                          children: [
                            Text(
                              'ISHARE & LOGIN',
                              style:
                                  TextStyle(fontSize: 30, color: Colors.black),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Icon(
                              Icons.share,
                              size: 150,
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Can't be null";
                                  }
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.black,
                                  ),
                                  label: Text(
                                    "E-mail",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Can't be null";
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Colors.black,
                                  ),
                                  label: Text(
                                    "Password",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black),
                                onPressed: (() {
                                  login();
                                }),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (_) => Reg()),
                                    (route) => false);
                              },
                              child: Text(
                                'Are you havent account? Register',
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ),
                          ],
                        ))
                  ]),
            ),
          );
  }

  login() async{
    try {
      if (formkey.currentState!.validate()) {
        setState(() {
          _isload = true;
        });

        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) async{
          var uid = value.user!.uid;
          await FirebaseFirestore.instance
              .collection('users')
              .doc('$uid')
              .get()
              .then((value) async{
            String username = value.data()!['username'];
            await helper_functions.saveemail(email);
            await helper_functions.saveuserloggin(true);
            await helper_functions.saveusername(username);
            await helper_functions.saveuid(uid);
          });
        }).whenComplete(() async{
          await Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => Home()), (route) => false);
        });
        setState(() {
          _isload = false;
        });
      }
    } catch (e) {
      setState(() {
        _isload = false;
      });
      Fluttertoast.showToast(msg: '$e');
    }
  }
}
