import 'dart:developer';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ishare/Auth/help.dart';
import 'package:ishare/Widgets/drawer.dart';
import 'package:ishare/Widgets/frireq.dart';

class Istek extends StatefulWidget {
  const Istek({super.key});

  @override
  State<Istek> createState() => _IstekState();
}

class _IstekState extends State<Istek> {
  @override
  void initState() {
    helper_functions.getuidfromSF().then((value) {
      var data = FirebaseFirestore.instance
          .collection('users')
          .doc('$value')
          .snapshots();
      setState(() {
        doc = data;
      });
      setState(() {
        uid = value;
      });
    });
    super.initState();
  }

  String? uid;
  Stream? doc;
  Widget build(BuildContext context) {
    return Scaffold(
      body: getFriend(),
      drawer: MyDrawer(),
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: Text(
              'ISHARE',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          )),
    );
  }

  getFriend() {
    return StreamBuilder(
        stream: doc,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              List a = snapshot.data['Friends req'];
              log('$a');
              if (a.isNotEmpty) {
                return ListView.builder(
                    itemCount: a.length,
                    itemBuilder: ((context, index) {
                      return Frireq(userid: snapshot.data['Friends req'][index]);
                    }));
              } else {
                return Center(
                    child: Text(
                  'Herhangi bir arkadaşlik isteginiz bulunmuyor',
                  style: TextStyle(color: Colors.grey[500], fontSize: 20),
                ));
              }
            } else {
              return Center(
                  child: Text(
                'Herhangi bir arkadaşlik isteginiz bulunmuyor',
                style: TextStyle(color: Colors.grey[500], fontSize: 20),
              ));
            }
          } else {
            return Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }
        }));
  }
}
