import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:r_social/Social/Widget/text.dart';
import 'package:r_social/Social/googlesignin.dart';

class showreq extends StatefulWidget {
  var username;
  var email;
  var id;
  var photourl;
  var timestamp;
  showreq({this.username, this.email, this.id, this.photourl, this.timestamp});

  factory showreq.formDocument(DocumentSnapshot snapshot) {
    return showreq(
        id: snapshot['id'],
        username: snapshot['username'],
        email: snapshot['email'],
        photourl: snapshot['photourl'],
        timestamp: snapshot['timestamp']);
  }
  @override
  _showreqState createState() => _showreqState();
}

class _showreqState extends State<showreq> {
  var wonid = googleSignIn.currentUser.id;
  var addfrind = 'Accept';
  var cancel = 'Cancel';

  var request = '';

  bool isfriend = false;

  canceluser() async {
    try {
      var frindrequestdelete = await userref
          .collection('FriendRequest')
          .doc('${wonid}')
          .collection('alluser')
          .doc('${widget.id}')
          .delete();
      var followingdelete = await userref
          .collection('following')
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
    } catch (e) {
      print(e);
    }
    print('Cancel FRiend ......');
  }

  aceptuser() async {
    try {
      var chatlistadwon = await userref
          .collection('chatlist')
          .doc('${wonid}')
          .collection('alluser')
          .doc('${widget.id}')
          .set({
        'isblock': false,
        'friendid': widget.id,
      });
      var chatlistadher = await userref
          .collection('chatlist')
          .doc('${widget.id}')
          .collection('alluser')
          .doc('${wonid}')
          .set({
        'isblock': false,
        'friendid': wonid,
      });
      var addmyfriend = await userref
          .collection('Friend')
          .doc('${wonid}')
          .collection('alluser')
          .doc('${widget.id}')
          .set({
        'isfriend': true,
        'friendid': widget.id,
      });
      var addherfriend = await userref
          .collection('Friend')
          .doc('${widget.id}')
          .collection('alluser')
          .doc('${wonid}')
          .set({
        'isfriend': true,
        'friendid': wonid,
      });
      var frindrequestdelete = await userref
          .collection('FriendRequest')
          .doc('${wonid}')
          .collection('alluser')
          .doc('${widget.id}')
          .delete();
      var addtimelenwon = await userref
          .collection('timeline')
          .doc('${wonid}')
          .collection('alluser')
          .doc('${widget.id}')
          .set({
        'friendid': widget.id,
      });
      var addtimelenher = await userref
          .collection('timeline')
          .doc('${widget.id}')
          .collection('alluser')
          .doc('${wonid}')
          .set({
        'friendid': wonid,
      });

      var followingremove = await userref
          .collection('following')
          .doc('${widget.id}')
          .collection('alluser')
          .doc('${wonid}')
          .delete();
      var followeradd = await userref
          .collection('follower')
          .doc('${widget.id}')
          .collection('alluser')
          .doc('${wonid}')
          .set({
        'followerid': wonid,
        'isfollower': true,
      });
    } catch (e) {
      print(e);
    }
    print('Accept FRiend ......');
  }

  @override
  void initState() {
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        aceptuser();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: text(data: 'Acept'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        canceluser();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: text(
                            data: 'Cancel',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
