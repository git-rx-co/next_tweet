import 'package:flutter/material.dart';
import 'package:r_social/Social/Widget/chatroom.dart';
import 'package:r_social/Social/Widget/text.dart';
import 'package:r_social/Social/googlesignin.dart';
import 'package:r_social/Social/model/MyUser.dart';
import 'package:r_social/Social/model/chatlist.dart';

class Chat extends StatefulWidget {
  MyUser myUser;
  Chat({this.myUser});
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<chatroom> chatuser = [];
  List<chatlist> chatusermodel = [];
  var sarchcr = TextEditingController();
  int countchatlistuser = 0;
  chatuserlist() async {
    try {
      print(widget.myUser.id);
      var allf = await userref
          .collection('chatlist')
          .doc('${widget.myUser.id}')
          .collection('alluser')
          .get();

      setState(() {
        countchatlistuser = allf.docs.length;
        chatusermodel = allf.docs.map((e) => chatlist.formMap(e)).toList();
      });
      print(countchatlistuser);
      print(chatusermodel[0].friendid);
    } catch (e) {
      print(e);
    }
    await getuse();
  }

  getuse() async {
    for (int i = 0; i < countchatlistuser; i++) {
      var query = await userref
          .collection('user')
          .doc('${chatusermodel[i].friendid}')
          .get();

      setState(() {
        var cu = chatroom.formDocument(query);
        chatuser.add(cu);
      });
    }
    print(chatuser[0].username);
  }

  queryy(value) {}
  var sarchtitlelength = 0;
  @override
  void initState() {
    chatuserlist();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, right: 10, left: 10),
              child: TextField(
                controller: sarchcr,
                onChanged: (value) {
                  queryy(value);
                  print(value);
                  setState(() {
                    sarchtitlelength = value.length;
                  });
                  print(sarchtitlelength);
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    suffixIcon: sarchtitlelength > 0
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              sarchcr.clear();
                              setState(() {
                                sarchtitlelength = 0;
                              });
                            },
                          )
                        : null,
                    labelText: 'Sarch hare',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),
            Expanded(
                child: ListView(children: [
              Column(
                children: chatuser,
              )
            ]))
          ],
        ),
      ),
    );
  }
}
