import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:r_social/Social/Widget/mypost.dart';
import 'package:r_social/Social/Widget/text.dart';
import 'package:r_social/Social/googlesignin.dart';
import 'package:r_social/Social/model/MyUser.dart';

class Home_page extends StatefulWidget {
  MyUser myUser;
  Home_page({this.myUser});
  @override
  _Home_pageState createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  int postcount = 0;

  List friendid = [];

  getfriendid() async {
    QuerySnapshot snap = await userref
        .collection('timeline')
        .doc('${widget.myUser.id}')
        .collection('alluser')
        .get();

    var length = snap.docs.length;
    print(length);
    var id;
    // for (int i = 0; i < length; i++) {
    snap.docs.forEach((element) {
      id = element.data()['friendid'];
      friendid.add(id);
    });
    // }

    // print('this is friend id = ${id}');

    print(friendid);
    await getuserpost();
  }

  mypost mp = mypost();
  List l = [];
  Map all = {};

  getuserpost() async {
    for (int i = 0; i < friendid.length; i++) {
      QuerySnapshot instance = await userref
          .collection('post')
          .doc('${friendid[i]}')
          .collection('userpost')
          .get();
      var o = instance.docs.length;
      setState(() {
        var mp = instance.docs.map((e) => mypost.formMap(e));
        l.add(mp.toList());
      });
      postcount += o;
    }
    print(postcount);
    print(l[0]);
    print(' last result = ${l[0][0].postid}');
    print(' last result = ${l[0][0].posttext}');
    print(' last result = ${l[0][0].wonid}');
  }

  @override
  void initState() {
    getfriendid();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          height: h,
          width: w,
          child: ListView.builder(
              itemCount: l.length != null ? l.length : 0,
              itemBuilder: (context, index) {
                return Column(
                  children: l[index],
                );
              })),
    );
  }
}
