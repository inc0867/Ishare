import 'package:flutter/material.dart';

class Yorumwidget extends StatefulWidget {
  final String yorumyapan;
  final String yorum;
  const Yorumwidget({
    Key? key,
    required this.yorum,
    required this.yorumyapan,
  }) : super(key: key);

  @override
  State<Yorumwidget> createState() => _YorumwidgetState();
}

class _YorumwidgetState extends State<Yorumwidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.black,
        child: Text(
          widget.yorumyapan[0],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      subtitle: Text(
        widget.yorumyapan,
        style: TextStyle(color: Colors.grey[500]),
      ),
      title: Text(
        widget.yorum,
        style: TextStyle(fontSize: 20,color: Colors.black),
      ),
    );
  }
}
