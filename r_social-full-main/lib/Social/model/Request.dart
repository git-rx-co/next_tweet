import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Request {
  var isrequest;
  var requestid;
  Request({this.isrequest, this.requestid});

  factory Request.formMap(DocumentSnapshot snap) {
    return Request(isrequest: snap['isrequest'], requestid: snap['requestid']);
  }
}
