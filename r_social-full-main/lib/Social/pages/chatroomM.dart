import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:r_social/Social/Widget/message.dart';
import 'package:r_social/Social/Widget/text.dart';
import 'package:r_social/Social/googlesignin.dart';
import 'package:r_social/Social/model/MyUser.dart';
import 'package:r_social/pages/HomePage.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as tAgo;

class MessageRoom extends StatefulWidget {
  var herid;
  MessageRoom({this.herid});
  @override
  _MessageRoomState createState() => _MessageRoomState();
}

class _MessageRoomState extends State<MessageRoom> {
  var messagetext;
  var imageurl;
  var imagepath;
  var imoge;
  var imogepath;
  var timestemp;
  var wonerid = googleSignIn.currentUser.id;
  var messageid;
  var messageTc = TextEditingController();
  var imagename;
  var messagekey = Uuid().v1();
  var username;
  var userimage;
  var usernameher;
  var userimageher;
  MyUser myUser;

  List<MyUser> usr = [];
  bool userloading = false;

  getwonprofile() async {
    try {
      var instance = await userref.collection('user').doc('${wonerid}').get();

      setState(() {
        username = instance.data()['username'];
        userimage = instance.data()['photourl'];
      });
    } catch (e) {
      print(e);
    }
  }

  getuser() async {
    setState(() {
      userloading = true;
    });
    try {
      var instance =
          await userref.collection('user').doc('${widget.herid}').get();

      setState(() {
        usernameher = instance.data()['username'];
        userimageher = instance.data()['photourl'];

        var u = MyUser.formDocument(instance);
        usr.add(u);
      });
    } catch (e) {
      print(e);
    }
    print('user email is = ${usr[0].email}');
    setState(() {
      userloading = false;
    });
  }

  gaeallmessage() async {
    try {
      return StreamBuilder(
        stream: userref
            .collection('chat')
            .doc('${wonerid}')
            .collection('allchat')
            .doc('${widget.herid}')
            .collection('message')
            .orderBy('timestemp', descending: false)
            .snapshots(),
        builder: (context, snap) {
          allpost = snap.data.docs.map((e) => Message.Formmap(e)).toList();
        },
      );
    } catch (e) {}
  }

  Message message;
  List<Message> allpost = [];
  bool isrefress = true;

  bool ispick = false;
  File imgpath;
  pickphoto() async {
    var pat = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      imgpath = File(pat.path);
      ispick = true;
    });
  }

  uplodimage() async {
    var putimg = await storeref
        .ref()
        .child('message')
        .child('${imagename}postimage')
        .putFile(imgpath);

    var url = await putimg.ref.getDownloadURL();

    print(url);
    setState(() {
      imageurl = url;
      imagepath = '${imagename}postimage';
    });
  }

  bool messageissend = true;
  sendmessage() async {
    try {
      await getwonprofile();
    } catch (e) {
      print(e);
    }
    setState(() {
      timestemp = Timestamp.now();
      messageid = Uuid().v1();
      imagename = Uuid().v4();
      messagetext = messageTc.text;
    });
    try {
      if (imgpath != null) {
        await uplodimage();
      }
    } catch (e) {
      print(e);
    }
    ;
    try {
      var sendmessagewon = await userref
          .collection('chat')
          .doc('${wonerid}')
          .collection('allchat')
          .doc('${widget.herid}')
          .collection('message')
          .doc('${messageid}')
          .set({
        'messagetext': messagetext,
        'imageurl': imageurl,
        'imagepath': imagepath,
        'imoge': imoge,
        'timestemp': timestemp,
        'wonid': wonerid,
        'messageid': messageid,
        'username': username,
        'userimage': userimage
      });
      var sendmessageher = await userref
          .collection('chat')
          .doc('${widget.herid}')
          .collection('allchat')
          .doc('${wonerid}')
          .collection('message')
          .doc('${messageid}')
          .set({
        'messagetext': messagetext,
        'imageurl': imageurl,
        'imagepath': imagepath,
        'imoge': imoge,
        'timestemp': timestemp,
        'wonid': wonerid,
        'messageid': messageid,
        'username': username,
        'userimage': userimage
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      messageTc.clear();
      imageurl = null;
      imagepath = null;

      ispick = false;
    });

    // await gaeallmessage();
  }

  @override
  void initState() {
    getuser();

    print(widget.herid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: userref
          .collection('chat')
          .doc('${wonerid}')
          .collection('allchat')
          .doc('${widget.herid}')
          .collection('message')
          .orderBy('timestemp', descending: true)
          .snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snap.hasData) {
          allpost = snap.data.docs.map((e) => Message.Formmap(e)).toList();
        }

        return Container(
          height: h,
          width: w,
          color: Colors.black87,
          child: Column(
            children: [
              row(h, w),
              Expanded(
                child: allpost != null
                    ? ListView(
                        reverse: true,
                        shrinkWrap: true,
                        children: allpost,
                      )
                    : SizedBox(),
              ),
              bottomrow(h, w)
            ],
          ),
        );
      },
    ));
  }

  showimg(h, w) {
    return Container(
      color: Colors.black54,
      height: h / 9,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          imgpath != null
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.file(
                    imgpath,
                    width: w / 3.5,
                    fit: BoxFit.cover,
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  bottomrow(h, w) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      ),
      width: w,
      height: ispick ? h / 4.5 : h / 9,
      child: Column(
        children: [
          ispick ? showimg(h, w) : SizedBox(),
          Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    pickphoto();
                  }),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: messageTc,
                      decoration: InputDecoration(
                          hintMaxLines: 2,
                          helperMaxLines: 2,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          labelText: '  Writr Somethings'),
                    )),
              )),
              IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    sendmessage();
                  })
            ],
          ),
        ],
      ),
    );
  }

  row(h, w) {
    return userloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 28),
            child: Container(
              color: Colors.black54,
              width: w,
              height: h / 9.5,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Row(
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            Padding(
                              padding: const EdgeInsets.only(right: 5, left: 5),
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                      radius: 27,
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          NetworkImage(usr[0].photourl)),
                                  Positioned(
                                    right: 2,
                                    bottom: 2,
                                    child: CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.green,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                text(
                                  data: usr[0].username,
                                  size: 15.0,
                                  color: Colors.white,
                                ),
                                text(
                                  data: tAgo.format(usr[0].timestamp.toDate()),
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
