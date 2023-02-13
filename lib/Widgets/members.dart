import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Member extends StatefulWidget {
  final String id;
  const Member({Key? key, required this.id}) : super(key: key);

  @override
  State<Member> createState() => _MemberState();
}

class _MemberState extends State<Member> {
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

  String? username;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
        
        child: ListTile(
          leading: CircleAvatar(
            child: Text(
              '${username![0]}',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
          ),
          title: Text(
            '$username',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
