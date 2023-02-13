import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ishare/Auth/help.dart';
import 'package:ishare/Widgets/ark.dart';
import 'package:ishare/Widgets/drawer.dart';

class Arkadaslar extends StatefulWidget {
  const Arkadaslar({super.key});

  @override
  State<Arkadaslar> createState() => _ArkadaslarState();
}

class _ArkadaslarState extends State<Arkadaslar> {

  @override
  void initState() {
    helper_functions.getuidfromSF().then((value) {
      var data = FirebaseFirestore.instance.collection('users').doc('$value').snapshots();
      setState(() {
        ud = data;
      });
    });
    super.initState();
  }

  Stream? ud; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: studb(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
            child: Text(
          'ISHARE',
          style: TextStyle(color: Colors.white, fontSize: 20),
        )),
      ),
      drawer: MyDrawer(),
    );
  }
  studb () {
    return StreamBuilder(
      stream: ud,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            List a = snapshot.data['Friends'];
            return ListView.builder(
              itemCount: a.length,
              itemBuilder: ((context, index) {
                return ark(id: snapshot.data['Friends'][index],);
              }));
          }else {
            return no();
          }
        }else {
          return Center(child: CircularProgressIndicator(color: Colors.black,),);
        }
      }));
  }
  Widget no () {
    return Center(child: Text('Herhangi bir arkadasiniz Yok!',style: TextStyle(color: Colors.grey[500],fontSize: 20),),);
  }
}