import 'package:flutter/material.dart';
import 'package:r_social/Social/Widget/text.dart';
import 'package:r_social/Social/googlesignin.dart';
import 'package:r_social/Social/model/MyUser.dart';
import 'package:r_social/Social/pages/All_Menu.dart';
import 'package:r_social/Social/pages/R_Social_Home.dart';
import 'package:r_social/Social/pages/rprofilePage.dart';
import 'package:r_social/Social/pages/uploadpost.dart';
import 'package:r_social/pages/HomePage.dart';
import 'package:uuid/uuid.dart';

class postscreen extends StatefulWidget {
  var fileimg;
  var wonid;
  MyUser myUser;
  postscreen({this.fileimg, this.wonid, this.myUser});

  @override
  _postscreenState createState() => _postscreenState();
}

class _postscreenState extends State<postscreen> {
  var key = GlobalKey<FormState>();
  var postid = Uuid().v4();
  var imgpath = Uuid().v1();
  var posttext;
  var photourl;
  Map like = {};
  var photopath;
  bool isprogress = false;

  var textcontroller = TextEditingController();
  uplodimage() async {
    var putimg = await storeref
        .ref()
        .child('userpostimage')
        .child('${widget.wonid}')
        .child('${imgpath}postimage')
        .putFile(widget.fileimg);

    var url = await putimg.ref.getDownloadURL();

    print(url);
    setState(() {
      photourl = url;
      photopath = '${imgpath}postimage';
    });
  }

  poststore() async {
    var valid = key.currentState.validate();

    if (valid) {
      setState(() {
        isprogress = true;
      });
      key.currentState.save();
      await uplodimage();
      await userref
          .collection('post')
          .doc('${widget.wonid}')
          .collection('userpost')
          .doc('${postid}')
          .set({
        'postid': postid,
        'posttext': posttext,
        'like': like,
        'photopath': photopath,
        'wonerid': widget.wonid,
        'photourl': photourl,
      });
      setState(() {
        isupload = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => R_Social_Home(
                    pageind: 2,
                    myUser: widget.myUser,
                  )));
      key.currentState.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var weight = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: text(
                    data: 'R Social Post',
                    size: 30.0,
                  ),
                ),
                Form(
                    key: key,
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Image.file(
                                widget.fileimg,
                                width: double.infinity,
                                height: height / 2,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (isprogress)
                              Center(child: CircularProgressIndicator()),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.length == 0) {
                                return 'Write Somthing';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                posttext = value;
                              });
                            },
                            decoration:
                                InputDecoration(labelText: 'Enter Blog'),
                          ),
                        ),
                        // ignore: deprecated_member_use
                        RaisedButton(
                            color: Colors.grey,
                            child: text(
                              data: 'Post',
                            ),
                            onPressed: () {
                              poststore();
                            })
                      ],
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
