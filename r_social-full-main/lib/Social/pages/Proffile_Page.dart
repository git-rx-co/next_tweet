import 'package:flutter/material.dart';
import 'package:r_social/Social/Widget/text.dart';

class R_Profile_Page extends StatefulWidget {
  @override
  _R_Profile_PageState createState() => _R_Profile_PageState();
}

class _R_Profile_PageState extends State<R_Profile_Page> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: text(
        data: 'ProfilePage',
        size: 30.0,
      ),
    );
  }
}
