import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ishare/Auth/help.dart';
import 'package:ishare/Widgets/drawer.dart';
import 'package:ishare/Widgets/mesaj.dart';

class FriendsChat extends StatefulWidget {
  final String fcid;
  const FriendsChat({Key? key, required this.fcid}) : super(key: key);

  @override
  State<FriendsChat> createState() => _FriendsChatState();
}

class _FriendsChatState extends State<FriendsChat> {
  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    helper_functions.getusernamefromSF().then(
      (value) {
        setState(() {
          username = value;
        });
      },
    );
    FirebaseFirestore.instance
        .collection('fc')
        .doc('${widget.fcid}')
        .get()
        .then((value) async {
      var data = value.data();
      var ids = data!['users'][0];
      helper_functions.getuidfromSF().then((value) {
        if (ids != value) {
          FirebaseFirestore.instance
              .collection('users')
              .doc('$ids')
              .get()
              .then((value) async {
            var datas = value.data();
            setState(() {
              otherusername = datas!['username'];
            });
          });
        } else {
          var ide = data['users'][1];
          FirebaseFirestore.instance
              .collection('users')
              .doc('$ide')
              .get()
              .then((value) {
            var dataa = value.data();
            setState(() {
              otherusername = dataa!['username'];
            });
          });
        }
      });
    });
    var snap = FirebaseFirestore.instance
        .collection('fc')
        .doc('${widget.fcid}')
        .collection('mesaj')
        .where(
          'zaman',
        )
        .orderBy(
          'zaman',
          descending: false,
        )
        .snapshots();
    setState(() {
      strm = snap;
    });
    setState(() {
      _isloading = false;
    });
    super.initState();
  }

  Stream<QuerySnapshot>? strm;
  String? username;
  String? otherusername;
  bool _isloading = true;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        listmessages(),
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: "Bir mesaj...",
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      if (controller.text != "") {
                        FirebaseFirestore.instance
                            .collection('fc')
                            .doc('${widget.fcid}')
                            .collection('mesaj')
                            .add({
                          'gonderen': username,
                          'mesaj': controller.text,
                          'zaman': DateTime.now(),
                        }).whenComplete(() {
                          controller.clear();
                        });
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                  ),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
      drawer: MyDrawer(),
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    '${otherusername![0]}',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                title: Text(
                  '$otherusername',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )),
          )),
    );
  }

  listmessages() {
    return StreamBuilder(
        stream: strm,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              List a = snapshot.data!.docs;
              if (a.isNotEmpty) {
                return ListView.builder(
                    itemCount: a.length,
                    itemBuilder: ((context, index) {
                      return mesaj(
                        mesas: snapshot.data!.docs[index]['mesaj'],
                        user: snapshot.data!.docs[index]['gonderen'],
                      );
                    }));
              } else {
                return none();
              }
            } else {
              return none();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }
        }));
  }

  Widget none() {
    return Center(
      child: Text(
        'Mesaj Yok',
        style: TextStyle(color: Colors.grey[500]),
      ),
    );
  }
}
