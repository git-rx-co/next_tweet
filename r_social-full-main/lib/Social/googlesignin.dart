import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:r_social/Social/model/MyUser.dart';
import 'package:r_social/Social/pages/R_Social_Home.dart';
import 'package:r_social/Social/pages/myHome.dart';
import 'package:r_social/Social/pages/uploadpost.dart';
import 'package:r_social/pages/HomePage.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseFirestore userref = FirebaseFirestore.instance;
final FirebaseStorage storeref = FirebaseStorage.instance;
MyUser myUser;

class googlesign extends StatefulWidget {
  @override
  _googlesignState createState() => _googlesignState();
}

class _googlesignState extends State<googlesign> {
  bool issign = false;

  @override
  void initState() {
    print(
        ' ################### .......init State is run...................................');
    test();
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((account) {
      if (account != null) {
        logincontrol(account);
        print('this is user Account $account');
      } else {
        print('user not Signin');
      }
    });

    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      if (account != null) {
        logincontrol(account);
      }
    }).catchError((error) {
      print(error);
    });
  }

  login() async {
    await googleSignIn.signIn();
  }

  Timestamp time = Timestamp.now();
  storeuserData(GoogleSignInAccount account) async {
    await userref.collection('user').doc('${account.id}').set({
      'username': account.displayName,
      'email': account.email,
      'id': account.id,
      'photourl': account.photoUrl,
      'timestamp': time
    });

    if (account != null) {
      var saveuser =
          await userref.collection('user').doc('${account.id}').get();

      var alldata = MyUser.formDocument(saveuser);
      print(alldata.email);
      print(alldata.id);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => R_Social_Home(
                    myUser: alldata,
                  )));
    }
  }

  test() async {
    var saveuser =
        await userref.collection('user').doc('104556971083644970386').get();

    var alldata = MyUser.formDocument(saveuser);
    print(alldata.email);
    print(alldata.id);
  }

  logincontrol(account) async {
    print('loginc comntroll is run.........................');
    if (account != null) {
      print(account);
      await storeuserData(account);
    } else {
      return print('User Not Regster Successfull');
    }
  }

  navigator() {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => R_Social_Home(
                  myUser: myUser,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return issign
        ? navigator()
        : Container(
            color: Colors.green,
            child: Center(
              // ignore: deprecated_member_use
              child: RaisedButton(
                child: Text('Signin'),
                color: Colors.green,
                onPressed: () {
                  login();
                },
              ),
            ),
          );
  }
}
