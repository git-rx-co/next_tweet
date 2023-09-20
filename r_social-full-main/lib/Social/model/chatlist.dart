import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class chatlist {
  var isblock;
  var friendid;
  chatlist({this.isblock, this.friendid});

  factory chatlist.formMap(DocumentSnapshot snap) {
    return chatlist(isblock: snap['isblock'], friendid: snap['friendid']);
  }
}
