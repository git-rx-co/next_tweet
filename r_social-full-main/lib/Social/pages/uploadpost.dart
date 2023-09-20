import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission/permission.dart';
import 'package:r_social/Social/Widget/postscreen.dart';
import 'package:r_social/Social/Widget/text.dart';
import 'package:r_social/Social/googlesignin.dart';
import 'package:r_social/Social/model/MyUser.dart';

bool isupload = true;

class uploadPost extends StatefulWidget {
  MyUser myUser;
  uploadPost({this.myUser});
  @override
  _uploadPostState createState() => _uploadPostState();
}

class _uploadPostState extends State<uploadPost> {
  File imgpath;
  bool isradypost = true;
  @override
  void initState() {
    isupload = true;
    print(widget.myUser.username);
    print(widget.myUser.id);
    print(widget.myUser.photourl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: isupload
            ? Center(
                // ignore: deprecated_member_use
                child: RaisedButton(
                    color: Colors.grey,
                    onPressed: () {
                      uplodOfson(context);
                    },
                    child: text(
                      data: 'Uplod Post',
                      size: 20.0,
                    )))
            : postscreen(
                fileimg: imgpath,
                wonid: widget.myUser.id,
                myUser: widget.myUser));
  }

  uplodOfson(contextt) {
    return showDialog(
        context: contextt,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.grey,
            title: text(
              data: 'Pick Image',
              size: 25.0,
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                // ignore: deprecated_member_use
                child: FlatButton(
                    onPressed: () {
                      pickimg();
                    },
                    child: text(
                      data: 'Pick Image',
                      size: 19.0,
                    )),
              )
            ],
          );
        });
  }

  pickimg() async {
    var pickimg =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    imgpath = File(pickimg.path);
    if (imgpath != null) {
      setState(() {
        isradypost = false;
        Navigator.pop(context);
        isupload = false;
      });
    }

    print(imgpath);
  }
}
