import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:r_social/Social/googlesignin.dart';
import 'package:r_social/Social/pages/R_Social_Home.dart';
import 'package:r_social/Social/pages/uploadpost.dart';
import 'package:r_social/pages/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    title: 'R Social',
    home: googlesign(),
  ));
}
