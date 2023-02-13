import 'package:flutter/material.dart';
import 'package:ishare/Auth/help.dart';
import 'package:ishare/Views/Home.dart';
import 'package:ishare/Views/arkadaslar.dart';
import 'package:ishare/Views/log.dart';
import 'package:ishare/Views/requests.dart';
import 'package:ishare/Views/topluluklar.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  _logoutdia() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              'Are you want to logout??',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                            size: 30,
                          ),
                          Text(
                            'No!!',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        ],
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        helper_functions.saveemail("");
                        helper_functions.saveuid("");
                        helper_functions.saveuid("");
                        helper_functions.saveuserloggin(false).whenComplete(() {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => Log()),
                              (route) => false);
                        });
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 30,
                          ),
                          Text(
                            'Yes!!',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              ],
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Center(
        child: Column(children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'ISHARE',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          SizedBox(
            height: 5,
          ),
          Icon(
            Icons.share,
            color: Colors.white,
            size: 60,
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (_) => Home()), (route) => false);
            },
            child: Row(
              children: [
                Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                Text(
                  ' Home Page',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Arkadaslar()), (route) => false);
            },
            child: Row(children: [
              Icon(Icons.group , size: 30,color: Colors.white,),
              Text(' Arkadaslar',style: TextStyle(color: Colors.white , fontSize: 20),)
            ]),
          ),
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Topluluklar()), (route) => false);
            },
            child: Row(children: [
              Icon(
                Icons.groups,
                size: 30,
                color: Colors.white,
              ),
              Text(
                ' Topluluklar',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ]),
          ),
          InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => Istek()),
                    (route) => false);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 30,
                  ),
                  Text(' Istekler',
                      style: TextStyle(color: Colors.white, fontSize: 20))
                ],
              )),
          InkWell(
            onTap: () {
              _logoutdia();
            },
            child: Row(children: [
              Icon(
                Icons.logout,
                size: 30,
                color: Colors.white,
              ),
              Text(
                ' Logout',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ]),
          )
        ]),
      ),
    );
  }
}
