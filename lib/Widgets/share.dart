import 'package:flutter/material.dart';
import 'package:ishare/Widgets/yorum.dart';

class Shared extends StatefulWidget {
  final String id;
  final String paylasan;
  final String paylasim;
  const Shared(
      {Key? key,
      required this.id,
      required this.paylasan,
      required this.paylasim})
      : super(key: key);
  // yakinda resim paylasma ozelligide ekleyecegim ama suan lik bu ozellik yok
  @override
  State<Shared> createState() => _SharedState();
}

class _SharedState extends State<Shared> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        color: Colors.black,
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  widget.paylasan[0] + widget.paylasan[1],
                  style: TextStyle(color: Colors.black),
                ),
              ),
              title: Text(
                widget.paylasan,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              title: Text(
                widget.paylasim,
                style: TextStyle(color: Colors.white, fontSize: 23),
              ),
              subtitle: Row(children: [
                IconButton(
                    onPressed: (() {}),
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    )),
                SizedBox(
                  width: 3,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Yorum(
                          id: widget.id ,
                          paylasan: widget.paylasan ,
                          paylasim: widget.paylasim ,
                        )));
                  },
                  child: Text(
                    'Yorum Yap',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
