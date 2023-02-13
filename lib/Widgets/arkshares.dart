import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class arkshare extends StatefulWidget {
  final String id;
  const arkshare({Key? key, required this.id}) : super(key: key);

  @override
  State<arkshare> createState() => _arkshareState();
}

class _arkshareState extends State<arkshare> {
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('share')
        .doc('${widget.id}')
        .get()
        .then((value) {
      var data = value.data();
      setState(() {
        paylasan = data!['paylasan'];
      });
      setState(() {
        paylasim = data!['paylasim'];
      });
    });
    super.initState();
  }

  String paylasim = "";
  String paylasan = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Colors.black,
              size: 20,
            ),
          ),
          subtitle: Text(
            '$paylasan',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          title: Text(
            '$paylasim',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
