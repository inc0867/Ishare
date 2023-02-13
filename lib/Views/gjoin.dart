import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ishare/Auth/help.dart';
import 'package:ishare/Widgets/toplulukJOIN.dart';

class GJOIN extends StatefulWidget {
  const GJOIN({super.key});

  @override
  State<GJOIN> createState() => _GJOINState();
}

class _GJOINState extends State<GJOIN> {
  searchsystem() async {
    if (searchcnt.text != "") {
      var gettings = FirebaseFirestore.instance
          .collection('groups')
          .where('Groupname', isEqualTo: searchcnt.text)
          .get()
          .then((value) {
        log('${value.docs[0]['admin']}');
        setState(() {
          data = value;
          arandi = true;
        });
      });
    }
  }

  thetopluluk() {
    return arandi
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: data!.docs.length,
            itemBuilder: ((context, index) {
              List<dynamic> kume = data!.docs[index]['users'];
              return Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    trailing: GestureDetector(
                      onTap: () {
                        if (kume.contains(userid)) {
                          Fluttertoast.showToast(
                              msg: 'Bu Topluluga zaten uyesiniz,');
                        } else {
                          FirebaseFirestore.instance
                              .collection('groups')
                              .doc('${data!.docs[index].id}')
                              .update({
                            'users': FieldValue.arrayUnion(['$userid']),
                          }).whenComplete(() {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc('$userid')
                                .update({
                              'topluluk': FieldValue.arrayUnion(
                                  ['${data!.docs[index].id}']),
                            });
                          }).whenComplete(() {
                            Fluttertoast.showToast(msg: 'Topluluga basariyla katildiniz!');
                          });
                        }
                      },
                      child: kume.contains(userid)
                          ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green),
                              child: Text(
                                'Katildiniz',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.red),
                              child: Text(
                                'Katil',
                                style: TextStyle(color: Colors.white),
                              )),
                    ),
                    subtitle: Text(
                      'Admin : ${data!.docs[index]['admin']}',
                      style: TextStyle(color: Colors.white),
                    ),
                    title: Text(
                      '${data!.docs[index]['Groupname']}',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        '${data!.docs[index]['Groupname'][0]}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black),
              ); /*JOINtopluluk(
                  groupAdmin: data!.docs[index]['admin'],
                  groupname: data!.docs[index]['Groupname'],
                  users: data!.docs[index]['users']);*/
            }))
        : Center(
            child: Text(
            'Bir Topluluk Arayin',
            style: TextStyle(color: Colors.grey[500], fontSize: 20),
          ));
  }

  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    helper_functions.getuidfromSF().then((value) {
      setState(() {
        userid = value;
      });
    });
    setState(() {
      _isloading = false;
    });
    super.initState();
  }

  TextEditingController searchcnt = TextEditingController();
  QuerySnapshot? data;
  bool arandi = false;
  bool _isloading = false;
  String? userid;
  @override
  Widget build(BuildContext context) {
    return _isloading
        ? Center(
            child: CircularProgressIndicator(color: Colors.black),
          )
        : Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchcnt,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        suffixIcon: FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: () {
                              // search system
                              searchsystem();
                            },
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.black))),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                thetopluluk()
              ],
            ),
            appBar: AppBar(
                backgroundColor: Colors.black,
                title: Center(
                  child: Text(
                    'Search group',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          );
  }
}
