import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendModel {
  var isfriend;
  var friendid;
  FriendModel({this.isfriend, this.friendid});

  factory FriendModel.formMap(DocumentSnapshot snap) {
    return FriendModel(isfriend: snap['isfriend'], friendid: snap['friendid']);
  }
}
