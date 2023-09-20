import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r_social/Social/Widget/text.dart';
import 'package:r_social/Social/model/MyUser.dart';

import 'package:r_social/Social/pages/Add_Friend.dart';
import 'package:r_social/Social/pages/All_Menu.dart';
import 'package:r_social/Social/pages/Chat.dart';
import 'package:r_social/Social/pages/Home_Page.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:r_social/Social/pages/uploadpost.dart';

class R_Social_Home extends StatefulWidget {
  MyUser myUser;
  int pageind;
  R_Social_Home({this.myUser, this.pageind});
  @override
  _R_Social_HomeState createState() => _R_Social_HomeState();
}

class _R_Social_HomeState extends State<R_Social_Home> {
  MyUser myUser;
  // List allpage =;

  var pagcr = PageController();
  PersistentTabController _controller;

  int pageindexx = 0;
  int pageindex = 0;
  @override
  void initState() {
    setState(() {
      pageindex = widget.pageind != null ? widget.pageind : 0;
      pagcr = PageController(
          initialPage: widget.pageind != null ? widget.pageind : 0);
    });

    print(widget.myUser.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: PageView(
        controller: pagcr,
        onPageChanged: (value) {
          setState(() {
            pageindex = value;
          });
        },
        children: [
          Home_page(myUser: widget.myUser),
          Add_Friend(),
          uploadPost(
            myUser: widget.myUser,
          ),
          Chat(myUser: widget.myUser),
          All_Menu(myUser: widget.myUser)
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: pageindex,
        onItemSelected: (index) {
          setState(() {
            pageindex = index;
          });
          pagcr.animateToPage(
            pageindex,
            duration: Duration(milliseconds: 400),
            curve: Curves.bounceInOut,
          );
        },
        showElevation: true,
        itemCornerRadius: 20,
        backgroundColor: Colors.black,
        curve: Curves.easeIn,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              icon: Icon(
                FontAwesomeIcons.home,
                size: 26,
              ),
              activeColor: Colors.green,
              inactiveColor: Colors.white,
              title: Center(
                child: text(
                  data: ' Home',
                ),
              )),
          BottomNavyBarItem(
              icon: Icon(
                FontAwesomeIcons.userFriends,
                size: 26,
              ),
              activeColor: Colors.green,
              inactiveColor: Colors.white,
              title: Center(
                child: text(
                  data: 'Add Friend',
                ),
              )),
          BottomNavyBarItem(
              icon: Icon(
                FontAwesomeIcons.plusCircle,
                size: 26,
              ),
              activeColor: Colors.green,
              inactiveColor: Colors.white,
              title: Center(
                child: text(
                  data: 'Profile',
                ),
              )),
          BottomNavyBarItem(
              icon: Icon(
                FontAwesomeIcons.facebookMessenger,
                size: 26,
              ),
              activeColor: Colors.green,
              inactiveColor: Colors.white,
              title: Center(
                child: text(
                  data: 'Chat',
                ),
              )),
          BottomNavyBarItem(
              icon: Icon(
                Icons.segment,
                size: 26,
              ),
              activeColor: Colors.green,
              inactiveColor: Colors.white,
              title: Center(
                child: text(
                  data: 'Menu',
                ),
              )),
        ],
      ),
    );
  }
}

class Profile_Page {}
