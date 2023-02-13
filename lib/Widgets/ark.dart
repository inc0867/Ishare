import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ishare/Auth/help.dart';
import 'package:ishare/Widgets/fc.dart';

class ark extends StatefulWidget {
  final String id;
  const ark({Key? key, required this.id}) : super(key: key);

  @override
  State<ark> createState() => _arkState();
}

class _arkState extends State<ark> {
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .doc('${widget.id}')
        .get()
        .then((value) {
      var data = value.data();
      setState(() {
        username = data!['username'];
      });
    });
    super.initState();
  }

  // Proje buyuyunce ListTile li Row a cevir
  String? username;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          child: Text(
            'Sohbet',
            style: TextStyle(color: Colors.blue),
          ),
          onPressed: () {
            helper_functions.getuidfromSF().then((value) {
              FirebaseFirestore.instance.collection('fc').get().then((value) {
                for (var i in value.docs) {
                  List a = i['users'];
                  if (a.contains(widget.id)) {
                    helper_functions.getuidfromSF().then((value) {
                      if (a.contains(value)) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => FriendsChat(fcid: i.id)));
                      } else {
                        FirebaseFirestore.instance.collection('fc').add({
                          'users': ['$value', '${widget.id}'],
                        }).then((value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => FriendsChat(fcid: value.id)));
                        });
                      }
                    });
                  } else {
                    FirebaseFirestore.instance.collection('fc').add({
                      'users': ['$value', '${widget.id}'],
                    }).then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => FriendsChat(fcid: value.id)));
                    });
                  }
                }
              });
              /*FirebaseFirestore.instance.collection('fc').add(
                {
                  'users':['$value','${widget.id}'],
                }
              );*/
            });
          },
        ),
        title: Text(
          '$username',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.black,
          child: Text(
            '${username![0]}',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
