import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:r_social/Social/Widget/showUser.dart';
import 'package:r_social/Social/Widget/text.dart';
import 'package:r_social/Social/googlesignin.dart';
import 'package:r_social/Social/model/MyUser.dart';

class Add_Friend extends StatefulWidget {
  @override
  _Add_FriendState createState() => _Add_FriendState();
}

class _Add_FriendState extends State<Add_Friend> {
  showUser _showUser;
  MyUser myUser;
  List<showUser> alluser = [];
  List<showUser> forquery = [];
  List<showUser> querysub = [];
  var sarchcr = TextEditingController();
  bool isloading = true;
  getalluser() async {
    setState(() {
      isloading = false;
    });
    QuerySnapshot snap = await userref
        .collection('user')
        .orderBy('timestamp', descending: true)
        .get();
    setState(() {
      alluser = snap.docs.map((e) => showUser.formDocument(e)).toList();
      forquery = alluser;
    });
    print(alluser[0].username);
    print(alluser[0].email);
    print(forquery[1].photourl);
    setState(() {
      isloading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getalluser();
  }

  bool isrequest = false;
  var getdata;
  queryy(value) {
    setState(() {
      alluser = [];
    });
    getdata = value.split(' ').join('').toLowerCase();
    print(getdata);

    bool isdata = getdata.length > 0 ? true : false;

    if (isdata) {
      print('isdata call');
      for (int i = 0; i < forquery.length; i++) {
        var comp = forquery[i].username.split(' ').join('').toLowerCase();
        if (comp.contains(getdata)) {
          alluser.add(forquery[i]);
        }
      }
    } else {
      print('isdata Not call');
      setState(() {
        alluser = forquery;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          height: h,
          width: w,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.green, Colors.blueGrey])),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, right: 10, left: 10),
                child: TextField(
                  controller: sarchcr,
                  onChanged: (value) {
                    queryy(value);
                    print(value);
                  },
                  decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      suffixIcon: sarchcr.text.length > 0
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                sarchcr.clear();
                                setState(() {
                                  alluser = forquery;
                                });
                              },
                            )
                          : null,
                      labelText: 'Sarch hare',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
              ),
              Expanded(
                child: isloading
                    ? ListView(
                        children: alluser,
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ],
          )),
    );
  }
}
