import 'package:flutter/material.dart';
import 'package:r_social/Social/Widget/showUser.dart';
import 'package:r_social/Social/Widget/showreq.dart';
import 'package:r_social/Social/Widget/text.dart';
import 'package:r_social/Social/googlesignin.dart';
import 'package:r_social/Social/model/Request.dart';

class allFriend extends StatefulWidget {
  var id;
  allFriend({this.id});
  @override
  _allFriendState createState() => _allFriendState();
}

class _allFriendState extends State<allFriend> {
  var wonid = googleSignIn.currentUser.id;

  List<showreq> showrequest = [];
  List<Request> allreq = [];
  int count = 0;
  friendrequest() async {
    try {
      print(widget.id);
      var query = await userref
          .collection('FriendRequest')
          .doc('${widget.id}')
          .collection('alluser')
          .get();

      setState(() {
        count = query.docs.length;
        allreq = query.docs.map((e) => Request.formMap(e)).toList();
      });
      print(count);
      print(allreq[0].requestid);
    } catch (e) {
      print(e);
    }
    await getuse();
  }

  getuse() async {
    for (int i = 0; i < count; i++) {
      var query =
          await userref.collection('user').doc('${allreq[i].requestid}').get();

      setState(() {
        showreq u = showreq.formDocument(query);
        showrequest.add(u);
      });
    }
    print(showrequest[0].username);
  }

  @override
  void initState() {
    friendrequest();

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
        title: text(data: 'All Friend Request ${count}'),
        actions: [
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      body: count == null || count == 0
          ? Center(
              child: text(
                data: 'No Request',
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
