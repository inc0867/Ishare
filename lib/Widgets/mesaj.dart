import 'package:flutter/material.dart';
import 'package:ishare/Auth/help.dart';

class mesaj extends StatefulWidget {
  final String mesas;
  final String user;
  const mesaj({Key? key, required this.mesas, required this.user})
      : super(key: key);

  @override
  State<mesaj> createState() => _mesajState();
}

class _mesajState extends State<mesaj> {
  @override
  void initState() {
    helper_functions.getusernamefromSF().then((value) {
      if (widget.user == value) {
        setState(() {
          TorF = true;
        });
      } else {
        setState(() {
          TorF = false;
        });
      }
    });
    super.initState();
  }

  bool TorF = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
      child: Container(
        child: ListTile(
            subtitle: Text(
              '${widget.user}',
              style: TextStyle(color: TorF ? Colors.white : Colors.grey[500]),
            ),
            title: Text(
              '${widget.mesas}',
              style: TextStyle(
                  color: TorF ? Colors.black : Colors.grey, fontSize: 20),
            )),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: TorF ? Colors.grey : Colors.black),
      ),
    );
  }
}
