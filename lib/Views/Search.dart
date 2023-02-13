import 'dart:developer';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ishare/Auth/help.dart';
import 'package:ishare/Widgets/drawer.dart';
import 'package:ishare/Widgets/user.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  void initState() {
    helper_functions.getusernamefromSF().then((value) {
      setState(() {
        myname = value;
      });
    });
    var get = FirebaseFirestore.instance.collection('users').snapshots();
    setState(() {
      idcol = get;
    });

    super.initState();
  }

  Stream<QuerySnapshot>? idcol;
  String? myname;
  bool hasuser = false;
  String username = "";
  bool _isload = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: listofuser(),
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: Text(
              'ISHARE',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          )),
    );
  }

  listofuser() {
    return StreamBuilder(
        stream: idcol,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: ((context, index) {
                  if (myname != snapshot.data!.docs[index]['username']) {
                    return
                   UserWidget(
                    ouid: snapshot.data!.docs[index]['uid'],
                      username: snapshot.data!.docs[index]['username'],
                      friend: snapshot.data!.docs[index]['Friends'],
                      friendsreq: snapshot.data!.docs[index]['Friends req']);
                  }else {
                    return SizedBox(width: 1,);
                  }
                }));
          } else {
            return Container();
          }
        }));
  }
}
