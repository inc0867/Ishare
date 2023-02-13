import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ishare/Auth/help.dart';
import 'package:ishare/Widgets/user.dart';
import 'package:ishare/Widgets/yorumwidget.dart';

class Yorum extends StatefulWidget {
  final String paylasim;
  final String paylasan;
  final String id;
  const Yorum(
      {Key? key,
      required this.id,
      required this.paylasan,
      required this.paylasim})
      : super(key: key);

  @override
  State<Yorum> createState() => _YorumState();
}

class _YorumState extends State<Yorum> {
  String yorum = "";
  String? username;
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
    var get = FirebaseFirestore.instance
        .collection('share')
        .doc('${widget.id}')
        .collection('yorumlar')
        .where('zaman')
        .orderBy('zaman', descending: false)
        .snapshots();
    setState(() {
      stream = get;
    });
    setState(() {
      _isload = false;
    });
    super.initState();
  }

  Stream<QuerySnapshot>? stream;
  bool _isload = false;
  @override
  Widget build(BuildContext context) {
    return _isload
        ? Center(
            child: CircularProgressIndicator(color: Colors.black),
          )
        : Scaffold(
            body: Stack(
              children: 
              [
                
                /*Container(
                  alignment: Alignment.bottomCenter,
                  color: Colors.black,
                  child: ListTile(
                    trailing: FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () {
                        if (yorum != "") {
                          FirebaseFirestore.instance
                              .collection('share')
                              .doc('${widget.id}')
                              .collection('yorumlar')
                              .add({
                            'yapan': '$username',
                            'yorum': '$yorum',
                            'zaman': DateTime.now(),
                          }).whenComplete(() {
                            
                          });
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.black,
                      ),
                    ),
                    title: TextField(
                      autofocus: true,
                        onChanged: (value) {
                          setState(() {
                            yorum = value;
                          });
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.white)))),
                  ),
                ),*/
                listofyorum(),
                Container(

        width: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 18),
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                      
                      onChanged: (value) {
                        setState(() {
                          yorum = value;
                        });
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: "Bir Yorum Yazin..",
                          border: InputBorder.none),
                    ),
              ),
              SizedBox(width: 12,),
              Container(
                child: GestureDetector(onTap: () {
                  if (yorum != "") {
                          FirebaseFirestore.instance
                              .collection('share')
                              .doc('${widget.id}')
                              .collection('yorumlar')
                              .add({
                            'yapan': '$username',
                            'yorum': '$yorum',
                            'zaman': DateTime.now(),
                          }).whenComplete(() {
                            
                          });
                }},child: Icon(Icons.send  ,  color: Colors.black,),),
                width: 50,height: 50, decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                
              ),)
            ],
          ),
        ),),
              ],
            ),
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: ListTile(
                  subtitle: Text(
                    widget.paylasan,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  title: Text(
                    widget.paylasim,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
            ));
  }

  listofyorum() {
    return StreamBuilder(
        stream: stream,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              if (snapshot.data!.docs.length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      return Yorumwidget(
                          yorum: snapshot.data!.docs[index]['yorum'],
                          yorumyapan: snapshot.data!.docs[index]['yapan']);
                    }));
              } else {
                return Center(
                  child: Text('Suan Yorum yok '),
                );
              }
            } else {
              return Center(
                child: Text('Suan Yorum yok '),
              );
            }
          } else {
            return CircularProgressIndicator();
          }
        }));
  }
}
