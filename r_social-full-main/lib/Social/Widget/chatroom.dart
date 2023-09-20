import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:r_social/Social/pages/chatroomM.dart';
import 'package:r_social/Social/Widget/text.dart';
import 'package:r_social/Social/googlesignin.dart';
import 'package:r_social/Social/model/chatlist.dart';

class chatroom extends StatefulWidget {
  var username;
  var email;
  var id;
  var photourl;
  var timestamp;

  chatroom({this.username, this.email, this.id, this.photourl, this.timestamp});

  factory chatroom.formDocument(DocumentSnapshot snapshot) {
    return chatroom(
        username: snapshot['username'],
        id: snapshot['id'],
        email: snapshot['email'],
        photourl: snapshot['photourl'],
        timestamp: snapshot['timestamp']);
  }
  @override
  _chatroomState createState() => _chatroomState();
}

class _chatroomState extends State<chatroom> {
  var wonid = googleSignIn.currentUser.id;

  var request = '';

  bool isfriend = false;

  compireuser() async {
    // main instance  user_id query 1st FrindRwquest colluction doc=>myid coll=>alluser doc=>userid .get

    // 1st compair isrequest = true if(){ return text('Cancel') }
    // 2st compair isfriend = true if(){ return text('Friend') }
    //  deffult{ return text('Add Friend') }

    try {
      print(wonid);
      print(widget.id);
      var query = await userref
          .collection('chatlist')
          .doc('${wonid}')
          .collection('alluser')
          .doc('${widget.id}')
          .get();
      print('Query is Work');
      var d = query.data()['isblock'];
      bool isblock = await query.data()['isblock'];
      print(isblock);
      print(d);
      if (isblock) {
        setState(() {
          request = 'Block You';
        });
      } else {
        setState(() {
          request = 'Message..';
        });
      }
      print(isblock);
    } catch (e) {
      print(e);
    }

    print('Query is Work');

    print(request);
  }

  @override
  void initState() {
    compireuser();
    super.initState();
  }

  startmessage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MessageRoom(
                  herid: widget.id,
                )));
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        startmessage();
      },
      child: Card(
        elevation: 4,
        color: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            color: Colors.green,
            height: h / 6,
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
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: text(
                        data: request,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
