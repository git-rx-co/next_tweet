import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:r_social/Social/Widget/mypost.dart';
import 'package:r_social/Social/googlesignin.dart';
import 'package:r_social/Social/model/MyUser.dart';
import 'package:r_social/main.dart';

class rprofilepage extends StatefulWidget {
  MyUser myUser;
  rprofilepage({this.myUser});
  @override
  _rprofilepageState createState() => _rprofilepageState();
}

class _rprofilepageState extends State<rprofilepage> {
  List<mypost> maindataadd = [];
  getallpost() async {
    QuerySnapshot snap = await userref
        .collection('post')
        .doc(widget.myUser.id)
        .collection('userpost')
        .get();
    print(snap.docs.length);
    var userdata = await userref.collection('user').doc(widget.myUser.id).get();
    MyUser myUser = MyUser.formDocument(userdata);
    print(myUser.email);
    setState(() {
      maindataadd = snap.docs.map((e) => mypost.formMap(e)).toList();
      print(maindataadd);
      print(snap.docs.length);
    });
  }

  postshow() {
    return Column(
      children: maindataadd,
    );
  }

  @override
  void initState() {
    print(widget.myUser.username);
    getallpost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [postshow()],
      ),
    );
  }
}
