import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ishare/Auth/help.dart';
import 'package:ishare/Views/gjoin.dart';
import 'package:ishare/Widgets/drawer.dart';
import 'package:ishare/Widgets/toplulukJOIN.dart';
import 'package:ishare/Widgets/topluluks.dart';

class Topluluklar extends StatefulWidget {
  const Topluluklar({super.key});

  @override
  State<Topluluklar> createState() => _TopluluklarState();
}

class _TopluluklarState extends State<Topluluklar> {
  TextEditingController searchcnt = TextEditingController();
  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    helper_functions.getusernamefromSF().then((value) {
      setState(() {
        username = value;
      });
    });
    helper_functions.getuidfromSF().then((value) {
      var steam = FirebaseFirestore.instance
          .collection('users')
          .doc('$value')
          .snapshots();
      setState(() {
        top = steam;
      });
      setState(() {
        id = value;
      });
    });
    // :)
    setState(() {
      _isloading = false;
    });
    super.initState();
  }

  searchsystem() async {
    if (searchcnt.text != "") {
      var gettings = FirebaseFirestore.instance
          .collection('groups')
          .where('Groupname', isEqualTo: searchcnt.text)
          .get()
          .then((value) {
        setState(() {
          data = value;
          arandi = true;
        });
      });
    }
  }

  thetopluluk() async {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: data!.docs.length,
        itemBuilder: ((context, index) {
          return JOINtopluluk(
              groupAdmin: data!.docs[index]['admin'],
              groupname: data!.docs[index]['Groupname'],
              users: data!.docs[index]['users']);
        }));
  }

  QuerySnapshot? data;
  bool arandi = false;
  bool _isloading = false;
  Stream? top;
  String? id;
  String? username;
  String Tname = "";
  _diaofjoin() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              'Topluluklari arastir ve katil!!',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: searchcnt,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      suffixIcon: FloatingActionButton(
                          onPressed: () {
                            // search system
                            searchsystem();
                          },
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white))),
                ),
                SizedBox(
                  height: 10,
                ),
                arandi ? thetopluluk() : Container()
              ],
            ),
          );
        }));
  }

  _creategroupsdia() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              "Bir Topluluk olusturun",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      Tname = value;
                    });
                  },
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: "Topluluk adi",
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white))),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    )),
                    SizedBox(
                      width: 3,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () {
                        if (Tname != "") {
                          FirebaseFirestore.instance.collection('groups').add({
                            'Groupname': '$Tname',
                            'users': [id],
                            'admin': '$username'
                          }).then((value) {
                            var Tid = value.id;
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc('$id')
                                .update({
                              'topluluk': FieldValue.arrayUnion([Tid]),
                            }).whenComplete(() {
                              Navigator.pop(context);
                              Fluttertoast.showToast(
                                  msg: 'Topluluk basariyla olustururdu.');
                            });
                          });
                        }
                      },
                      child: Text(
                        "Create",
                        style: TextStyle(color: Colors.white),
                      ),
                    ))
                  ],
                )
              ],
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return _isloading
        ? CircularProgressIndicator(
            color: Colors.blue,
          )
        : Scaffold(
            body: listoftopluluks(),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: (() {
                _creategroupsdia();
                //create a groups and group admin
              }),
              child: Icon(
                Icons.share,
                color: Colors.white,
              ),
            ),
            appBar: AppBar(
              actions: [
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  child: Icon(Icons.search),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => GJOIN()));
                  },
                ),
                SizedBox(
                  width: 5,
                )
              ],
              backgroundColor: Colors.black,
              title: Center(
                child: Text(
                  'ISHARE',
                  style: TextStyle(color: Colors.white, fontSize: 26),
                ),
              ),
            ),
            drawer: MyDrawer(),
          );
  }

  listoftopluluks() {
    return StreamBuilder(
        stream: top,
        builder: ((context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            try {
              if (snapshot.data['topluluk'] != null) {
                List a = snapshot.data['topluluk'];
                if (a.isNotEmpty) {
                  return ListView.builder(
                      itemCount: a.length,
                      itemBuilder: ((context, index) {
                        int reserveindex = a.length - index - 1;

                        return Toplulukwidget(id: snapshot.data['topluluk'][reserveindex]);
                      }));
                } else {
                  return no();
                }
              } else {
                return no();
              }
            } catch (e) {
              return no();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }
        }));
  }

  Widget no() {
    return Center(
      child: Text(
        'Henuz bir Topluluga uye deilsiniz',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 30,
        ),
      ),
    );
  }
}
