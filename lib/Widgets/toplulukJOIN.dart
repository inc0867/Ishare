import 'package:flutter/material.dart';
import 'package:ishare/Auth/help.dart';

class JOINtopluluk extends StatefulWidget {
  final String groupAdmin;
  final String groupname;
  final List<dynamic> users;
  const JOINtopluluk(
      {Key? key,
      required this.groupAdmin,
      required this.groupname,
      required this.users})
      : super(key: key);

  @override
  State<JOINtopluluk> createState() => _JOINtoplulukState();
}

class _JOINtoplulukState extends State<JOINtopluluk> {
  @override
  void initState() {
    helper_functions.getuidfromSF().then((value) {
      if (widget.users.contains(value)) {
        setState(() {
          joinornot = true;
        });
      }else {
        setState(() {
          joinornot = false;
        });
      }
    });
    super.initState();
  }
  bool joinornot = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        trailing: XxX(),
        subtitle: Text('Admin : ${widget.groupAdmin}',style: TextStyle(color: Colors.white),),
        title: Text(
          '${widget.groupname}',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            '${widget.groupname[0]}',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.black),
    );
  }
  XxX () async {
    if (joinornot == true) {
      return ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green),onPressed: (() {
        
      }), child: Text('Katildiniz',style: TextStyle(color: Colors.white),));
    }else {
      return ElevatedButton( style: ElevatedButton.styleFrom(backgroundColor: Colors.black) ,onPressed: (() {
        
      }), child: Text('Katil',style: TextStyle(color: Colors.white , ),));
    }
  }
}
