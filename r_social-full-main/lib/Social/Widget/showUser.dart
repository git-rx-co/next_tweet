import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:r_social/Social/Widget/text.dart';
import 'package:r_social/Social/googlesignin.dart';

class showUser extends StatefulWidget {
  var username;
  var email;
  var id;
  var photourl;
  var timestamp;
  showUser({this.username, this.email, this.id, this.photourl, this.timestamp});

  factory showUser.formDocument(DocumentSnapshot snapshot) {
    return showUser(
        id: snapshot['id'],
        username: snapshot['username'],
        email: snapshot['email'],
        photourl: snapshot['photourl'],
        timestamp: snapshot['timestamp']);
  }
  @override
  _showUserState createState() => _showUserState();
}

class _showUserState extends State<showUser> {
  bool isrequest = false;
  var wonid = googleSignIn.currentUser.id;
  var addfrind = 'Add Friend';
  var cancel = 'Cancel';

  var you = 'You';
  var request = '';
  bool nullvalue = true;
  bool ischangeloading = false;
  chackuserrequest() async {}
  compireuser() async {
    // main instance  user_id query 1st FrindRwquest colluction doc=>myid coll=>alluser doc=>userid .get

    // 1st compair isrequest = true if(){ return text('Cancel') }
    // 2st compair isfriend = true if(){ return text('Friend') }
    //  deffult{ return text('Add Friend') }
    setState(() {
      request = addfrind;
    });
    if (wonid == widget.id) {
      setState(() {
        nullvalue = false;
      });
    }
    try {} catch (e) {
      print(e);
    }
    try {
      var friendchack = await userref
          .collection('Friend')
          .doc('${wonid}')
          .collection('alluser')
          .doc('${widget.id}')
          .get();

      bool isf = await friendchack.data()['isfriend'];
      if (isf) {
        setState(() {
          nullvalue = false;
        });
      }
      print('isFRiend = ${isf}');
    } catch (e) {
      print(e);
    }
    try {
      var followingchack = await userref
          .collection('following')
          .doc('${wonid}')
          .collection('alluser')
          .doc('${widget.id}')
          .get();

      bool isfollow = await followingchack.data()['isfollowing'];
      print('is following = ${isfollow}');
      if (isfollow) {
        setState(() {
          request = cancel;
        });
      }

      print('Query is Work');
    } catch (e) {
      print(e);
    }

    print('Query is Work try catch is too error handlear ..');
  }

  _add_friend() async {
    if (request == 'Add Friend') {
      setState(() {
        ischangeloading = true;
      });
      print('Now Work');
      var addfrindWon = await userref
          .collection('following')
          .doc('${wonid}')
          .collection('alluser')
          .doc('${widget.id}')
          .set({
        'followingid': widget.id,
        'isfollowing': true,
      });
      var addfollower = await userref
          .collection('follower')
          .doc('${widget.id}')
          .collection('alluser')
          .doc('${wonid}')
          .set({
        'followerid': wonid,
        'isfollower': true,
      });
      var addfrindthey = await userref
          .collection('FriendRequest')
          .doc('${widget.id}')
          .collection('alluser')
          .doc('${wonid}')
          .set({
        'requestid': wonid,
        'isrequest': true,
      });
      await compireuser();
      setState(() {
        ischangeloading = false;
      });
      print('Now Work... Complete');
    } else if (request == 'Cancel') {
      setState(() {
        ischangeloading = true;
      });
      print('Now Work');
      var deletefrindWon = await userref
          .collection('following')
          .doc('${wonid}')
          .collection('alluser')
          .doc('${widget.id}')
          .delete();
      var deletefollower = await userref
          .collection('follower')
          .doc('${widget.id}')
          .collection('alluser')
          .doc('${wonid}')
          .delete();
      var deletefrindthey = await userref
          .collection('FriendRequest')
          .doc('${widget.id}')
          .collection('alluser')
          .doc('${wonid}')
          .delete();
      await compireuser();
      setState(() {
        ischangeloading = false;
      });
      print('Now Work... Complete');
    }

    print('Now Work');
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
    return nullvalue
        ? Card(
            elevation: 4,
            color: Colors.green,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _add_friend();
                              setState(() {
                                isrequest = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue,
                              ),
                              child: ischangeloading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.black)),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: text(
                                        data: request,
                                      ),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : SizedBox();
  }
}
