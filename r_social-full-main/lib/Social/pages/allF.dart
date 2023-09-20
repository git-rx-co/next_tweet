import 'package:flutter/material.dart';
import 'package:r_social/Social/Widget/Friendlist.dart';
import 'package:r_social/Social/Widget/showUser.dart';
import 'package:r_social/Social/Widget/showreq.dart';
import 'package:r_social/Social/Widget/text.dart';
import 'package:r_social/Social/googlesignin.dart';
import 'package:r_social/Social/model/Request.dart';
import 'package:r_social/Social/model/friend.dart';
import 'package:r_social/Social/pages/All_Friend.dart';

class allF extends StatefulWidget {
  int count;
  var id;
  allF({this.id, this.count});
  @override
  _allFState createState() => _allFState();
}

class _allFState extends State<allF> {
  var wonid = googleSignIn.currentUser.id;

  List<friendlist> showrequest = [];

  List<FriendModel> allreq = [];
  int count = 0;

  friend() async {
    try {
      print(widget.id);
      var allf = await userref
          .collection('Friend')
          .doc('${widget.id}')
          .collection('alluser')
          .get();

      setState(() {
        count = allf.docs.length;
        allreq = allf.docs.map((e) => FriendModel.formMap(e)).toList();
      });
      print(count);
      print(allreq[0].friendid);
    } catch (e) {
      print(e);
    }
    await getuse();
  }

  getuse() async {
    for (int i = 0; i < count; i++) {
      var query =
          await userref.collection('user').doc('${allreq[i].friendid}').get();

      setState(() {
        friendlist u = friendlist.formDocument(query);
        showrequest.add(u);
      });
    }
    print(showrequest[0].username);
  }

  @override
  void initState() {
    friend();

    super.initState();
  }

  alluser() {
    return Column(
      children: showrequest,
    );
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: text(data: 'All Friend ${widget.count}'),
        actions: [
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      body: widget.count == null || widget.count == 0
          ? Center(
              child: text(
                data: 'No Friend',
              ),
            )
          : Container(
              height: h,
              width: w,
              child: ListView(
                children: [alluser()],
              ),
            ),
    );
  }
}
