import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:r_social/Social/Widget/text.dart';
import 'package:r_social/Social/googlesignin.dart';
import 'package:r_social/Social/model/MyUser.dart';
import 'package:r_social/widgets/CImageWidget.dart';

class Message extends StatefulWidget {
  var messagetext;
  var imageurl;
  var imagepath;
  var imoge;
  var timestemp;
  var wonid;
  var messageid;
  var username;
  var userimage;

  Message(
      {this.messagetext,
      this.imageurl,
      this.imagepath,
      this.imoge,
      this.timestemp,
      this.wonid,
      this.messageid,
      this.username,
      this.userimage});

  factory Message.Formmap(DocumentSnapshot snap) {
    return Message(
      messagetext: snap['messagetext'],
      imageurl: snap['imageurl'],
      imagepath: snap['imagepath'],
      imoge: snap['imoge'],
      timestemp: snap['timestemp'],
      wonid: snap['wonid'],
      messageid: snap['messageid'],
      username: snap['username'],
      userimage: snap['userimage'],
    );
  }
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  var wonerid = googleSignIn.currentUser.id;
  bool iswon = false;
  cackwonmessage() {
    bool iscak = wonerid == widget.wonid;
    if (iscak) {
      setState(() {
        iswon = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
          alignment: wonerid == widget.wonid
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            width: w / 2,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                widget.imageurl != null
                    ? Container(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              widget.imageurl,
                              height: h / 5,
                              width: w / 1.5,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: text(
                    data: widget.messagetext,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                Row(
                  // mainAxisAlignment: wonerid == widget.wonid
                  //     ? MainAxisAlignment.end
                  //     : MainAxisAlignment.start,
                  children: [
                    widget.userimage != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(widget.userimage),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                    text(
                      data: widget.username != null ? widget.username : '',
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
