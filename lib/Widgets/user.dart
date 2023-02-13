import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ishare/Auth/help.dart';
import 'package:ishare/Views/Search.dart';

class UserWidget extends StatefulWidget {
  final String username;
  final List<dynamic> friend;
  final List<dynamic> friendsreq;
  final String ouid;
  const UserWidget(
      {Key? key,
      required this.ouid,
      required this.username,
      required this.friend,
      required this.friendsreq})
      : super(key: key);

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  String? userid;
  bool req = false;
  bool fri = false;
  @override
  void initState() {   
    helper_functions.getuidfromSF().then((value) {
      setState(() {
        userid = value;
      });
      if (widget.friend.contains(value)) {
      setState(() {
        fri = true;
        req = false;
      });
    } else {
      if (widget.friendsreq.contains(value)) {
        setState(() {
          log('a');
          req = true;
          fri = false;
        });
      } else {
        setState(() {
          req = false;
          fri = false;
        });
      }
    }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.black,
        child: Text(
          widget.username[0] + widget.username[1],
          style: TextStyle(color: Colors.white),
        ),
      ),
      trailing: userstate(),
      title: Text(
        widget.username,
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
    );
  }

  userstate() {
    if (fri == true) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: (() {
          }),
          child: Text('Arkadas ekli'));
    } else {
      if (req == true) {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: (() {
            }),
            child: Text('Istek gonderildi',
                style: TextStyle(color: Colors.black)));
      } else {

        return ElevatedButton(
          
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: (() {
              FirebaseFirestore.instance.collection('users').doc('${widget.ouid}').update({
                'Friends req': FieldValue.arrayUnion(['$userid']),
              }).whenComplete(() {
                Fluttertoast.showToast(msg: 'istek basaryla gonderirdi.');
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Search()), (route) => false);
              });
            }),
            child: Text('Arkadas ekle'));
      }
    }
  }
}
