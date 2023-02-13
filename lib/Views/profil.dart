import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ishare/Auth/help.dart';
import 'package:ishare/Widgets/arkshares.dart';
import 'package:ishare/Widgets/drawer.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  void initState() {
    helper_functions.getusernamefromSF().then((value) {
      setState(() {
        username = value;
      });
    });
    helper_functions.getuidfromSF().then((value) {
      var the = FirebaseFirestore.instance.collection('users').doc('$value').snapshots();
      setState(() {
        stream = the;
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc('$value')
          .get()
          .then((value) {
        var data = value.data();
        List paylasim = data!['shares'];
        List arklar = data['Friends'];
        setState(() {
          ark = arklar.length;
        });
        setState(() {
          pay = paylasim.length;
        });
      });
      setState(() {
        uid = value;
      });
    });
    setState(() {
      _isloading = false;
    });
    super.initState();
  }

  int? ark;
  int? pay;
  Stream? stream;
  String? uid;
  bool _isloading = true;
  String? username;
  @override
  Widget build(BuildContext context) {
    return _isloading
        ? const Center(
            child: CircularProgressIndicator(color: Colors.black),
          )
        : Scaffold(
            body: Center(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 60,
                      )),
                ),
                Text(
                  '$uid',
                  style: TextStyle(fontSize: 20, color: Colors.grey[500]),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Center(child: Text(' Arkadaslar: $ark')),
                    ),
                    Expanded(child: Center(child: Text(' Paylasimlar: $pay')))
                  ],
                ),
                SizedBox(height: 30,),
                Text('Paylasilanlar',style: TextStyle(fontSize: 20,color: Colors.black),),
                SizedBox(height: 20,),
              Column(children: [listpay()],mainAxisSize: MainAxisSize.min,),
              ]),
            ),
            drawer: MyDrawer(),
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Center(
                  child: Text(
                '$username',
                style: TextStyle(color: Colors.white, fontSize: 25),
              )),
            ));
  }
  listpay(){
    return StreamBuilder(
      stream: stream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            List a = snapshot.data['shares'];
            if (a.isNotEmpty) {
              return ListView.builder(
                itemCount: a.length,
                itemBuilder: ((context, index) {
                  return arkshare(id: snapshot.data['shares'][index]);
                })
                );
            }else {
              return nodata();
            }
          }else {
            return nodata();
          }
        }else {
          return Center(child: CircularProgressIndicator(color: Colors.black),);
        }
      })
      );
  }
  Widget nodata() {
    return Center(child: Text('Bu kullanicinin bir paylasimi bulunmuyor',style: TextStyle(color: Colors.grey[500],fontSize: 20),),);
  }
}
