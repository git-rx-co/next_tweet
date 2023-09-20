import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r_social/Social/Widget/mypost.dart';
import 'package:r_social/Social/Widget/text.dart';
import 'package:r_social/Social/googlesignin.dart';
import 'package:r_social/Social/model/MyUser.dart';
import 'package:r_social/Social/model/Request.dart';
import 'package:r_social/Social/pages/All_Friend.dart';
import 'package:r_social/Social/pages/allF.dart';
import 'package:r_social/Social/pages/rprofilePage.dart';

class All_Menu extends StatefulWidget {
  MyUser myUser;
  All_Menu({this.myUser});
  @override
  _All_MenuState createState() => _All_MenuState();
}

class _All_MenuState extends State<All_Menu> {
  @override
  void initState() {
    friendrequest();
    frindlistcahack();
    followinguser();
    getwonpost();
    followerget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        height: h,
        width: w,
        child: ListView(
          children: [userProfil(h), userpost(h)],
        ),
      ),
    );
  }

  List<mypost> wonpost = [];
  getwonpost() async {
    QuerySnapshot instance = await userref
        .collection('post')
        .doc('${widget.myUser.id}')
        .collection('userpost')
        .get();

    setState(() {
      wonpost = instance.docs.map((e) => mypost.formMap(e)).toList();
      print(wonpost[0].postid);
    });
  }

  wonp(h) {
    return Column(
      children: wonpost,
    );
  }

  userpost(h) {
    return Container(
      color: Colors.black45,
      height: h / 1.5,
      child: Column(
        children: [
          Expanded(
            child: ListView(children: [wonp(h)]),
          )
        ],
      ),
    );
  }

  showuserDEtils(context, h) {
    return showModalBottomSheet(
        backgroundColor: Colors.black45,
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                usermore(h)
              ],
            ),
          );
        });
  }

  int count = 0;
  friendrequest() async {
    print(widget.myUser.id);
    try {
      var query = await userref
          .collection('FriendRequest')
          .doc('${widget.myUser.id}')
          .collection('alluser')
          .get();

      setState(() {
        count = query.docs.length;
      });
      print(count);
    } catch (e) {
      print(e);
    }
  }

  int friendcount = 0;
  int following = 0;
  int follower = 0;
  followinguser() async {
    print(widget.myUser.id);
    try {
      var friendlist = await userref
          .collection('following')
          .doc('${widget.myUser.id}')
          .collection('alluser')
          .get();

      setState(() {
        following = friendlist.docs.length;
      });
      print(following);
    } catch (e) {
      print(e);
    }
  }

  followerget() async {
    print(widget.myUser.id);
    try {
      var friendlist = await userref
          .collection('follower')
          .doc('${widget.myUser.id}')
          .collection('alluser')
          .get();

      setState(() {
        follower = friendlist.docs.length;
      });
      print(follower);
    } catch (e) {
      print(e);
    }
  }

  frindlistcahack() async {
    print(widget.myUser.id);
    try {
      var friendlist = await userref
          .collection('Friend')
          .doc('${widget.myUser.id}')
          .collection('alluser')
          .get();

      setState(() {
        friendcount = friendlist.docs.length;
      });
      print(friendcount);
    } catch (e) {
      print(e);
    }
  }

  allrequest() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => allFriend(
                  id: widget.myUser.id,
                )));
  }

  eachelement(
    title,
    count,
    icon,
  ) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: text(
                      data: title,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: text(
                      data: '${count}',
                      color: Colors.red,
                      size: 18.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  allf() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => allF(
                  id: widget.myUser.id,
                  count: friendcount,
                )));
  }

  usermore(h) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                allrequest();
              },
              child: eachelement(
                'Friend Request',
                '${count}',
                FontAwesomeIcons.userPlus,
              ),
            ),
            GestureDetector(
              onTap: () {
                allf();
              },
              child: eachelement(
                'Friend',
                ' ${friendcount}',
                FontAwesomeIcons.userFriends,
              ),
            ),
            GestureDetector(
              onTap: () {
                allf();
              },
              child: eachelement(
                'Following',
                ' ${following}',
                FontAwesomeIcons.userFriends,
              ),
            ),
            GestureDetector(
              onTap: () {
                allf();
              },
              child: eachelement(
                'Follower',
                ' ${friendcount}',
                FontAwesomeIcons.userFriends,
              ),
            ),
            GestureDetector(
              onTap: () {
                allf();
              },
              child: eachelement(
                'Edit Profile',
                '',
                FontAwesomeIcons.userCircle,
              ),
            ),
            GestureDetector(
              onTap: () {
                googleSignIn.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => googlesign()));
              },
              child: eachelement(
                'Log Out',
                '',
                FontAwesomeIcons.signOutAlt,
              ),
            ),
          ],
        ),
      ),
    );
  }

  userProfil(h) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
          elevation: 4,
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: h / 5.5,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(300),
                    child: CachedNetworkImage(
                      imageUrl: widget.myUser.photourl,
                      placeholder: (context, uri) {
                        Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(
                          data: '${widget.myUser.username}',
                          size: 16.0,
                        ),
                        text(
                          data: '${widget.myUser.email}',
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  text(
                                    data: '${friendcount}',
                                  ),
                                  text(
                                    data: 'Frind',
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  text(
                                    data: '${follower}',
                                  ),
                                  text(
                                    data: 'Follower',
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  text(
                                    data: '${following}',
                                  ),
                                  text(
                                    data: 'Following',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () {
                            showuserDEtils(context, h);
                          }))
                ],
              ),
            ),
          )),
    );
  }
}
