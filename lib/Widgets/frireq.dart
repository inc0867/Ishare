import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ishare/Auth/help.dart';

class Frireq extends StatefulWidget {
  final String userid;
  const Frireq({Key? key, required this.userid}) : super(key: key);

  @override
  State<Frireq> createState() => _FrireqState();
}

class _FrireqState extends State<Frireq> {
  @override
  void initState() {
    setState(() {
      _isload = true;
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc('${widget.userid}')
        .get()
        .then((value) async {
      var data = value.data();
      setState(() {
        username = data!['username'];
      });
    });
    setState(() {
      _isload = false;
    });
    super.initState();
  }

  _redek() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              'Arkadaslik istegini Kabul Edin veya Reddet!',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: (() {
                        helper_functions.getuidfromSF().then((value) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc('$value')
                              .get()
                              .then((value) {
                            var data = value.data();
                            var field = data!['Friends req'];
                            log('${value.id}');
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc('${value.id}')
                                .update({
                              'Friends req': FieldValue.arrayRemove(field),
                            });
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc('${value.id}')
                                .update({
                              'Friends': FieldValue.arrayUnion(field),
                            });
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc('${field[0]}')
                                .update({
                              'Friends': FieldValue.arrayUnion([value.id]),
                            });
                          });
                        });
                        Navigator.pop(context);
                      }),
                      child: Text(
                        'Kabulet',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text(
                        'Reddet',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        helper_functions.getuidfromSF().then((value) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc('${value}')
                              .get()
                              .then((value) {
                            var data = value.data();
                            var field = data!['Friends req'];
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc('${value.id}')
                                .update(
                              {'Friends req': FieldValue.arrayRemove(field)},
                            );
                          });
                        });
                      },
                    ))
                  ],
                ),
              ],
            ),
          );
        }));
  }

  String username = "";
  bool _isload = false;
  @override
  Widget build(BuildContext context) {
    return _isload
        ? Center(
            child: CircularProgressIndicator(color: Colors.black),
          )
        : Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: ListTile(
              subtitle: Text(
                'Tarafindan gelen arkadaslik istegi',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
              trailing: GestureDetector(
                child: Icon(Icons.arrow_upward),
                onTap: () {
                  _redek();
                },
              ),
              title: Text(
                '$username',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.black,
                child: Text(
                  '${username[0]}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
  }
}
