import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:r_social/Social/Widget/text.dart';
import 'package:r_social/Social/googlesignin.dart';
import 'package:r_social/Social/model/MyUser.dart';
import 'package:r_social/Social/pages/rprofilePage.dart';

class mypost extends StatefulWidget {
  MyUser myUser;
  var posttext;
  var postid;
  var photourl;
  var photopath;
  var wonid;
  Map like;

  mypost(
      {this.postid,
      this.posttext,
      this.photopath,
      this.photourl,
      this.wonid,
      this.like,
      this.myUser});

  factory mypost.formMap(DocumentSnapshot snapshot) {
    return mypost(
      postid: snapshot['postid'],
      posttext: snapshot['posttext'],
      photourl: snapshot['photourl'],
      photopath: snapshot['photopath'],
      wonid: snapshot['wonerid'],
      like: snapshot['like'],
    );
  }
  @override
  _mypostState createState() => _mypostState();
}

class _mypostState extends State<mypost> {
  var currentOnlineuserid = googleSignIn.currentUser.id;

  bool isref = true;
  profile() {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => rprofilepage(
                  myUser: widget.myUser,
                )));
  }

  headmnuitem() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: text(
              data: 'Post Delete',
              size: 20.0,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.green,
            children: [
              GestureDetector(
                onTap: () async {
                  await userref
                      .collection('post')
                      .doc(widget.wonid)
                      .collection('userpost')
                      .doc(widget.postid)
                      .delete();
                  await storeref
                      .ref()
                      .child('userpostimage')
                      .child(widget.wonid)
                      .child(widget.photopath)
                      .delete();
                  print('delete Success');
                  setState(() {
                    widget.photopath = '';
                  });
                  setState(() {
                    isref = false;
                  });
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    text(
                      data: 'Delete',
                      size: 15.0,
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  rhead() {
    return Card(
      color: Colors.black45,
      child: FutureBuilder(
        future: userref.collection('user').doc('${widget.wonid}').get(),
        builder: (context, snap) {
          // if (snap.connectionState == ConnectionState.waiting) {
          //   return Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          return snap.data != null
              ? ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(snap.data['photourl']),
                    radius: 22,
                    backgroundColor: Colors.grey,
                  ),
                  title: text(
                    data: snap.data['username'],
                  ),
                  trailing: isadmin
                      ? IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () {
                            headmnuitem();
                          })
                      : SizedBox(),
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  rmiddle() {
    return Container(
        child: CachedNetworkImage(
      imageUrl: '${widget.photourl}',
      fit: BoxFit.cover,
      placeholder: (uri, context) {
        return Container(
          height: 200,
          width: double.infinity,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                text(
                  data: 'Loading..',
                ),
              ],
            ),
          ),
        );
      },
    ));
  }

  bool islove;
  likecontroll() async {
    islove = widget.like[currentOnlineuserid] == true;
    print(islove);
    if (islove) {
      await userref
          .collection('post')
          .doc(widget.wonid)
          .collection('userpost')
          .doc(widget.postid)
          .update({'like.$currentOnlineuserid': false});
      setState(() {
        islove = false;
        widget.like[currentOnlineuserid] = false;
      });
    } else {
      await userref
          .collection('post')
          .doc(widget.wonid)
          .collection('userpost')
          .doc(widget.postid)
          .update({'like.$currentOnlineuserid': true});
      setState(() {
        islove = true;
        widget.like[currentOnlineuserid] = true;
      });
    }
  }

  int likecount() {
    if (widget.like == null) {
      return 0;
    }
    int count = 0;
    widget.like.values.forEach((value) {
      if (value == true) {
        count += 1;
      }
    });

    return count;
  }

  rfutter() {
    return Container(
      width: double.infinity,
      color: Colors.black45,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: text(
              data: widget.posttext,
              size: 20.0,
            ),
          ),
          Row(
            children: [
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            likecontroll();
                          },
                          child: Icon(islove
                              ? Icons.favorite
                              : Icons.favorite_outline)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 2,
                      ),
                      child: text(
                        data: 'like ${likecount()}',
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  bool isadmin = false;
  cahacladmin() {
    print(widget.wonid);
    print(currentOnlineuserid);
    if (widget.wonid == currentOnlineuserid) {
      print(widget.wonid);
      print(currentOnlineuserid);
      setState(() {
        print(widget.wonid);
        print(currentOnlineuserid);
        isadmin = true;
      });
    }
  }

  @override
  void initState() {
    // if (widget.wonid == currentOnlineuserid) {
    //   setState(() {
    //     isadmin = true;
    //   });
    // }
    print(currentOnlineuserid);
    print(widget.like[currentOnlineuserid]);
    if (widget.like[currentOnlineuserid] != null) {
      setState(() {
        islove = widget.like[currentOnlineuserid];
      });
    } else {
      setState(() {
        islove = false;
      });
    }
    cahacladmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isref
        ? Container(
            color: Colors.grey,
            child: Column(
              children: [
                rhead(),
                rmiddle(),
                rfutter(),
              ],
            ),
          )
        : SizedBox();
  }
}
