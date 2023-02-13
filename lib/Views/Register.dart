import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ishare/Auth/help.dart';
import 'package:ishare/Views/Home.dart';
import 'package:ishare/Views/log.dart';

class Reg extends StatefulWidget {
  const Reg({super.key});

  @override
  State<Reg> createState() => _RegState();
}

class _RegState extends State<Reg> {
  @override
  final formkey = GlobalKey<FormState>();
  String username = "";
  String email = "";
  String Password = "";
  bool _isloading = false;

  Widget build(BuildContext context) {
    return _isloading
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
                              'ISHARE & Register',
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
                                    username = value;
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Can't br null";
                                  }
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: Colors.black,
                                  ),
                                  label: Text(
                                    "Username",
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
                                onChanged: (value) {
                                  setState(() {
                                    Password = value;
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Can't be null";
                                  }
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
                                  register();
                                }),
                                child: Text(
                                  'Register',
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
                                    MaterialPageRoute(builder: (_) => Log()),
                                    (route) => false);
                              },
                              child: Text(
                                'Are you have account? Login',
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ),
                          ],
                        ))
                  ]),
            ),
          );
  }

  register() async {
    if (formkey.currentState!.validate()) {
      try {
        setState(() {
          _isloading = true;
        });
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: Password)
            .then((value) async {
          var id = value.user!.uid;
          await FirebaseFirestore.instance.collection('users').doc('$id').set({
            'username': username,
            'email': email,
            'uid': id,
            'shares': [],
            'topluluk':[],
            'Friends': [],
            'Friends req':[],
          });
          await helper_functions.saveemail(email);
          await helper_functions.saveuid(id);
          await helper_functions.saveusername(username);
          await helper_functions.saveuserloggin(true);
        }).whenComplete(() async{
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Home()), (route) => false);
        });
        setState(() {
          _isloading = false;
        });
      } catch (e) {
        setState(() {
          _isloading = false;
        });
        Fluttertoast.showToast(msg: '$e');
      }
    }
  }
}
