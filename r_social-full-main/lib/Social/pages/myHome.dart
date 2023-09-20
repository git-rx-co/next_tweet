import 'package:flutter/material.dart';
import 'package:r_social/Social/Widget/text.dart';
import 'package:r_social/Social/googlesignin.dart';
import 'package:r_social/Social/model/MyUser.dart';
import 'package:r_social/Social/pages/rprofilePage.dart';
import 'package:r_social/Social/pages/uploadpost.dart';

class myHome extends StatefulWidget {
  MyUser myUser;
  myHome({this.myUser});
  @override
  _myHomeState createState() => _myHomeState();
}

class _myHomeState extends State<myHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ignore: deprecated_member_use
          RaisedButton(
              color: Colors.black45,
              child: text(
                data: 'Upload Post',
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => uploadPost(
                              myUser: widget.myUser,
                            )));
              }),
          // ignore: deprecated_member_use
          RaisedButton(
              color: Colors.black45,
              child: text(
                data: 'Profile',
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => rprofilepage(
                              myUser: widget.myUser,
                            )));
              })
        ],
      )),
    );
  }
}
