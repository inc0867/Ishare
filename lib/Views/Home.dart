import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:ishare/Auth/help.dart';
import 'package:ishare/Views/Search.dart';
import 'package:ishare/Views/profil.dart';
import 'package:ishare/Widgets/drawer.dart';
import 'package:ishare/Widgets/share.dart';
import 'package:location/location.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    setState(() {
      _isload = true;
    });
    helper_functions.getusernamefromSF().then((value) {
      setState(() {
        username = value;
      });
    });
    helper_functions.getuidfromSF().then(
      (value) {
        setState(() {
          id = value;
        });
      },
    );
    var get = FirebaseFirestore.instance
        .collection('share')
        .where('zaman')
        .orderBy('zaman', descending: true)
        .snapshots();
    setState(() {
      shares = get;
    });
    setState(() {
      _isload = false;
    });
    super.initState();
  }

  /*final formkey = GlobalKey<FormState>();
  String field = "";
  File? uploadFile;
  String? Filename;
  send() async{
    if (formkey.currentState!.validate()) {
      if (uploadFile != null) {
        
      }else {
        Navigator.pop(context);
      }
    }
  }*/
  Location location = new Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  getloc() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    location.onLocationChanged.listen((LocationData event) {
      log('laT:${event.longitude} , long:${event.latitude}');
    });
  }

  @override
  _imagesharedia() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              'Resim and yazi paylas',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: (() async {
                      /*setState(() {
                        Filename = null;
                        uploadFile = null;
                      });*/
                      try {
                        var imgpicker = await ImagePicker.platform
                            .getImage(source: ImageSource.gallery);
                        FirebaseStorage.instance
                            .ref()
                            .child('shares')
                            .child("share.png")
                            .putFile(File(imgpicker!.path));
                      } catch (e) {
                        log('$e');
                      }

                      //add to firebase
                      /*setState(() {
                        Filename = imgpicker.name;
                        uploadFile = File(imgpicker.path);
                      });*/
                    }),
                    child: Text(
                      'Resim sec',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  /*TextFormField(
                    onChanged: ((value) {
                      setState(() {
                        field = value;
                      });
                    }),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Can't be null";
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Yazi...",
                      focusedBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.black))),
                  ),*/
                  /*ElevatedButton(onPressed: (() {
                    send();
                  }), style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[500]) ,child: Text(
                    
                      'Gonder',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),)*/
                ],
              ),
            ),
          );
        }));
  }

  _secimdia() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              'Bir paylasim turu secin',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        _sharedia();
                      },
                      child: Column(children: [
                        Text(
                          'Yazi paylasin',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.text_format_sharp,
                          color: Colors.white,
                        )
                      ]),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        _imagesharedia();
                      },
                      child: Column(children: [
                        Text(
                          'Resim , yazi',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.image_outlined,
                          color: Colors.white,
                        )
                      ]),
                    ))
                  ],
                )
              ],
            ),
          );
        }));
  }

  _sharedia() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text(
              'Bir seyler yazin..',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            backgroundColor: Colors.black,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      share = value;
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "...",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(20)),
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        child: Text(
                          'Iptal',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        child: Text(
                          'Gonder',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        onPressed: () {
                          if (share == "") {
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              _isload = true;
                            });
                            FirebaseFirestore.instance.collection('share').add({
                              'paylasim': share,
                              'paylasan': username,
                              'zaman': DateTime.now(),
                              'resim': [],
                            }).then((value) {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc('$id')
                                  .update({
                                'shares':
                                    FieldValue.arrayUnion(['${value.id}']),
                              });
                            }).whenComplete(() {
                              Fluttertoast.showToast(
                                  msg: 'Paylasim basariyala gonderirdi');
                              Navigator.pop(context);
                            });
                            setState(() {
                              _isload = false;
                            });
                          } // burasi oldu birazdan stream ekleyerek paylasimlari cekcez
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }));
  }

  Stream<QuerySnapshot>? shares;
  String? id;
  String share = "";
  bool _isload = false;
  String? username;
  Widget build(BuildContext context) {
    return _isload
        ? Center(
            child: CircularProgressIndicator(color: Colors.black),
          )
        : Scaffold(
            body: sharebuilder(),
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              color: Colors.black,
              child: Row(children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => Search()),
                        (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => ProfilPage()),
                        (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ))
              ]),
            ),
            drawer: MyDrawer(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _secimdia();
              },
              child: Icon(
                Icons.share,
                color: Colors.white,
              ),
              backgroundColor: Colors.black,
            ),
            appBar: AppBar(
                backgroundColor: Colors.black,
                title: Center(
                    child: Text(
                  'ISHARE',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                )),
                actions: [
                  SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                  Center(
                    child: Text(
                      '$username',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  )
                ]),
          );
  }

  sharebuilder() {
    return StreamBuilder(
      stream: shares,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Shared(
                  id: snapshot.data!.docs[index].id,
                  paylasan: snapshot.data!.docs[index]['paylasan'],
                  paylasim: snapshot.data!.docs[index]['paylasim']);
            },
          );
        } else {
          return no();
        }
      },
    );
  }

  Widget no() {
    return Center(
      child: Text(
        'NO HAVE A AVAIBLE SHARES',
        style: TextStyle(color: Colors.grey[500]),
      ),
    );
  }
}
