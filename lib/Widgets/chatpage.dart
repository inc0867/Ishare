import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ishare/Auth/help.dart';
import 'package:ishare/Widgets/mesaj.dart';
import 'package:ishare/Widgets/tinfo.dart';

class ChatPage extends StatefulWidget {
  final String id;
  const ChatPage({Key? key, required this.id}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    FirebaseFirestore.instance
        .collection('groups')
        .doc('${widget.id}')
        .get()
        .then((value) async {
      var data = value.data();
      setState(() {
        admin = data!['admin'];
      });
      setState(() {
        Tname = data!['Groupname'];
      });
    });
    helper_functions.getusernamefromSF().then(
      (value) {
        setState(() {
          username = value;
        });
      },
    );
    var get = FirebaseFirestore.instance
        .collection('groups')
        .doc('${widget.id}')
        .collection('msg')
        .where('zaman')
        .orderBy('zaman', descending: false)
        .snapshots();
    setState(() {
      strm = get;
    });
    setState(() {
      _isloading = false;
    });
    super.initState();
  }

  Stream<QuerySnapshot>? strm;
  String? username;
  bool _isloading = false;
  String? admin;
  String? Tname;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return _isloading
        ? const Center(
            child: CircularProgressIndicator(color: Colors.black),
          )
        : Scaffold(
            body: Stack(children: [
              listofm(),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
                              hintText: "Bir mesaj yazin ...",
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
                                  .collection('groups')
                                  .doc('${widget.id}')
                                  .collection('msg')
                                  .add({
                                'username': '$username',
                                'mesaj': '${controller.text}',
                                'zaman': DateTime.now(),
                              }).whenComplete(() {
                                setState(() {
                                  controller.clear();
                                });
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
            appBar: AppBar(
              actions: [
                SizedBox(width: 15,),
                GestureDetector(child: Icon(Icons.info_outline , color: Colors.blue,),onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => TINFO(id: widget.id)));
                },),
                SizedBox(width: 15,),
              ],
              backgroundColor: Colors.black,
              title: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    '${Tname![0]}',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                title: Text(
                  '$Tname',
                  style: TextStyle(color: Colors.white, fontSize: 23),
                ),
                subtitle: Text(
                  '$admin',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ),
          );
  }

  listofm() {
    return StreamBuilder(
        stream: strm,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    return mesaj(
                        mesas: snapshot.data!.docs[index]['mesaj'],
                        user: snapshot.data!.docs[index]['username']);
                  }));
            } else {
              return Container();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }
        }));
  }
}
