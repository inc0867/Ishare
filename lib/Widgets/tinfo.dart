import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ishare/Widgets/members.dart';

class TINFO extends StatefulWidget {
  final String id;
  const TINFO({Key? key, required this.id}) : super(key: key);

  @override
  State<TINFO> createState() => _TINFOState();
}

class _TINFOState extends State<TINFO> {
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('groups')
        .doc('${widget.id}')
        .get()
        .then((value) {
      var data = value.data();
      setState(() {
        gname = data!['Groupname'];
      });
      setState(() {
        admin = data!['admin'];
      });
    });
    var take = FirebaseFirestore.instance
        .collection('groups')
        .doc('${widget.id}')
        .snapshots();
    setState(() {
      stream = take;
    });
    super.initState();
  }

  Stream? stream;
  String? gname;
  String? admin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Text(
            'Uyeler',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          listmember(),
        ],
      )),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
            child: Text(
          '$gname',
          style: TextStyle(color: Colors.white, fontSize: 25),
        )),
      ),
    );
  }

  listmember() {
    return StreamBuilder(
        stream: stream,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              List kd = snapshot.data['users'];
              log('$kd');
              return ListView.builder(
                itemCount: kd.length,
                itemBuilder: ((context, index) {
                  return Member(id: snapshot.data['users'][index]);
                }));
            } else {
              return Container();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(color: Colors.black),
            );


            
          }
        }));
  }
}
