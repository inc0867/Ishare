import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ishare/Widgets/chatpage.dart';

class Toplulukwidget extends StatefulWidget {
  final String id;
  const Toplulukwidget({Key? key, required this.id}) : super(key: key);

  @override
  State<Toplulukwidget> createState() => _ToplulukwidgetState();
}

class _ToplulukwidgetState extends State<Toplulukwidget> {
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
        oname = data!['Groupname'];
      });
      setState(() {
        tname = data!['admin'];
      });
    });

    setState(() {
      _isloading = false;
    });
    super.initState();
  }

  @override
  String oname = "";
  String tname = "";
  bool _isloading = false;
  Widget build(BuildContext context) {
    return _isloading
        ? Center(
            child: CircularProgressIndicator(color: Colors.black),
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChatPage(id: widget.id)),
                  );
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      title: Text(
                        '$oname',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      subtitle: Text(
                        'Created by : $tname',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          '${oname[0]}',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
