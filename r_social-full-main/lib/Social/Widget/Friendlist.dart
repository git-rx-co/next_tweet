import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:r_social/Social/Widget/text.dart';
import 'package:r_social/Social/googlesignin.dart';

class friendlist extends StatefulWidget {
  var username;
  var email;
  var id;
  var photourl;
  var timestamp;
  friendlist(
      {this.username, this.email, this.id, this.photourl, this.timestamp});

  factory friendlist.formDocument(DocumentSnapshot snapshot) {
    return friendlist(
        id: snapshot['id'],
        username: snapshot['username'],
        email: snapshot['email'],
        photourl: snapshot['photourl'],
        timestamp: snapshot['timestamp']);
  }
  @override
  _friendlistState createState() => _friendlistState();
}

class _friendlistState extends State<friendlist> {
  var wonid = googleSignIn.currentUser.id;

  var frind = 'Friend';

  var request = '';

  bool isfriend = false;

  compireuser() async {
    // main instance  user_id query 1st FrindRwquest colluction doc=>myid coll=>alluser doc=>userid .get

    // 1st compair isrequest = true if(){ return text('Cancel') }
    // 2st compair isfriend = true if(){ return text('Friend') }
    //  deffult{ return text('Add Friend') }

    var query = await userref
        .collection('FriendRequest')
        .doc('${wonid}')
        .collection('alluser')
        .doc('${widget.id}')
        .get();
    print('Query is Work');

    bool isreq = await query.data()['isrequest'];
    bool isfrend = await query.data()['isfriend'];

    if (isfrend) {
      setState(() {
        request = frind;
      });
    } else if (isreq) {
      setState(() {
        isfriend = true;
      });
    }

    print(isfrend);
    print('Query is Work');
  }

  _add_friend() async {
    if (request == 'Add Friend') {
      print('Now Work');
      var addfrindWon = await userref
          .collection('FriendRequest')
          .doc('${wonid}')
          .collection('alluser')
          .doc('${widget.id}')
          .set({
        'requestid': widget.id,
        'isrequest': true,
        'isfriend': false,
      });
      var addfrindthey = await userref
          .collection('FriendRequest')
          .doc('${widget.id}')
          .collection('alluser')
          .doc('${wonid}')
          .set({
        'requestid': wonid,
        'isrequest': true,
        'isfriend': false,
      });
      await compireuser();
      print('Now Work... Complete');
    }
    print('Now Work');
  }

  unfriend() async {
    try {
      var unfriendmyfild = await userref
          .collection('Friend')
          .doc('${wonid}')
          .collection('alluser')
          .doc('${widget.id}')
          .delete();
      var deletetimelenwon = await userref
          .collection('timeline')
          .doc('${wonid}')
          .collection('alluser')
          .doc('${widget.id}')
          .delete();
      var deletetimelenher = await userref
          .collection('timeline')
          .doc('${widget.id}')
          .collection('alluser')
          .doc('${wonid}')
          .delete();
      var unfriendmyher = await userref
          .collection('Friend')
          .doc('${widget.id}')
          .collection('alluser')
          .doc('${wonid}')
          .delete();
      var deletefollower = await userref
          .collection('follower')
          .doc('${wonid}')
          .collection('alluser')
          .doc('${widget.id}')
          .delete();
      var deletefollowerher = await userref
          .collection('follower')
          .doc('${widget.id}')
          .collection('alluser')
          .doc('${wonid}')
          .delete();
    } catch (e) {
      print(e);
    }
    print('UnFriend User...');
  }

  showdilog() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: text(
              data: 'Datails',
              size: 20.0,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.green,
            children: [
              GestureDetector(
                onTap: () async {
                  unfriend();
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.account_circle),
                    SizedBox(
                      width: 10,
                    ),
                    text(
                      data: 'Unfriend',
                      size: 15.0,
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    compireuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Card(
      elevation: 4,
      color: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          color: Colors.green,
          height: h / 8.5,
          width: w - 10,
          child: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.photourl,
                        placeholder: (context, uri) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(
                        data: widget.username,
                      ),
                      text(
                        data: widget.email,
                        size: 12.0,
                      )
                    ],
                  )
                ],
              )),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: text(
                    data: 'Friend',
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      showdilog();
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
