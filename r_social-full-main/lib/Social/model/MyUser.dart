import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  var username;
  var email;
  var id;
  var photourl;
  var timestamp;
  //List alluser = [ rasel,
  // rakib, ];

  MyUser({this.username, this.email, this.id, this.photourl, this.timestamp});

  factory MyUser.formDocument(DocumentSnapshot snapshot) {
    return MyUser(
        id: snapshot['id'],
        username: snapshot['username'],
        email: snapshot['email'],
        photourl: snapshot['photourl'],
        timestamp: snapshot['timestamp']);
  }
}
