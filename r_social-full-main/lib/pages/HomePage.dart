import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:r_social/models/user.dart';
import 'package:r_social/pages/CreateAccountPage.dart';
import 'package:r_social/pages/NotificationsPage.dart';
import 'package:r_social/pages/ProfilePage.dart';
import 'package:r_social/pages/SearchPage.dart';
import 'package:r_social/pages/TimeLinePage.dart';
import 'package:r_social/pages/UploadPage.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
final usersReference = FirebaseFirestore.instance.collection("users");
final storageReference = FirebaseStorage.instance;

final postsReference = FirebaseFirestore.instance.collection("posts");
final activityFeedReference = FirebaseFirestore.instance.collection("feed");
final commentsRefrence = FirebaseFirestore.instance.collection("comments");
final followersRefrence = FirebaseFirestore.instance.collection("followers");
final followingRefrence = FirebaseFirestore.instance.collection("following");
final timelineRefrence = FirebaseFirestore.instance.collection("timeline");

final DateTime timestamp = DateTime.now();
User currentUser;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSignedIn = false;
  PageController pageController;
  int getPageIndex = 0;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();

    pageController = PageController();

    gSignIn.onCurrentUserChanged.listen((gSigninAccount) {
      controlSignIn(gSigninAccount);
    }, onError: (gError) {
      print("Error Message: " + gError);
    });

    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }).catchError((gError) {
      print("Error Message: " + gError);
    });
  }

  controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      await saveUserInfoToFireStore();

      setState(() {
        isSignedIn = true;
      });

      configureRealTimePushNotifications();
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  configureRealTimePushNotifications() {
    final GoogleSignInAccount gUser = gSignIn.currentUser;

    if (Platform.isIOS) {
      getIOSPermissions();
    }

    _firebaseMessaging.getToken().then((token) {
      usersReference.doc(gUser.id).update({"androidNotificationToken": token});
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> msg) async {
        final String recipientId = msg["data"]["recipient"];
        final String body = msg["notification"]["body"];

        if (recipientId == gUser.id) {
          SnackBar snackBar = SnackBar(
            backgroundColor: Colors.grey,
            content: Text(
              body,
              style: TextStyle(color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      },
    );
  }

  getIOSPermissions() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(alert: true, badge: true, sound: true));

    _firebaseMessaging.onIosSettingsRegistered.listen((settings) {
      print("Settings Registered :  $settings");
    });
  }

  saveUserInfoToFireStore() async {
    final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
    DocumentSnapshot documentSnapshot =
        await usersReference.doc(gCurrentUser.id).get();

    if (!documentSnapshot.exists) {
      final username = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateAccountPage()));

      usersReference.doc(gCurrentUser.id).set({
        "id": gCurrentUser.id,
        "profileName": gCurrentUser.displayName,
        "username": username,
        "url": gCurrentUser.photoUrl,
        "email": gCurrentUser.email,
        "bio": "",
        "timestamp": timestamp,
      });

      await followersRefrence
          .doc(gCurrentUser.id)
          .collection("userFollowers")
          .doc(gCurrentUser.id)
          .set({});

      documentSnapshot = await usersReference.doc(gCurrentUser.id).get();
    }

    currentUser = User.fromDocument(documentSnapshot);
  }

  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  loginUser() {
    gSignIn.signIn();
  }

  logoutUser() {
    gSignIn.signOut();
  }

  whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  onTapChangePage(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 400),
      curve: Curves.bounceInOut,
    );
  }

  Scaffold buildHomeScreen() {
    return Scaffold(
      key: _scaffoldKey,
      body: PageView(
        children: <Widget>[
          TimeLinePage(
            gCurrentUser: currentUser,
          ),
          SearchPage(),
          UploadPage(
            gCurrentUser: currentUser,
          ),
          NotificationsPage(),
          ProfilePage(userProfileId: currentUser?.id),
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: onTapChangePage,
        backgroundColor: Theme.of(context).accentColor,
        activeColor: Colors.black,
        inactiveColor: Colors.blueGrey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.photo_camera,
            size: 37.0,
          )),
          BottomNavigationBarItem(icon: Icon(Icons.favorite)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );
  }

  Scaffold buildSignInScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "BuddiesGram",
              style: TextStyle(
                  fontSize: 92.0, color: Colors.black, fontFamily: "Signatra"),
            ),
            GestureDetector(
              onTap: loginUser,
              child: Container(
                width: 270.0,
                height: 65.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/google_signin_button.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSignedIn) {
      return buildHomeScreen();
    } else {
      return buildSignInScreen();
    }
  }
}
